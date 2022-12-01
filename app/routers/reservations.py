from fastapi import APIRouter, Depends, status, HTTPException
from routers import Authentication
from database import models, connection
from schemas import reservationSchemas
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from datetime import datetime, timedelta
from typing import List

router = APIRouter(tags=["Reservation And Transactions"])


@router.get("/reserved-dates/guest/{listingid}", status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.ReservedDates])
def get_reserved_dates(listingid: int, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if listing exists or not and also the guest cant be the host
    listing = db.query(models.Listings).filter(models.Listings.listing_id == listingid, models.Listings.host_id != current_user_id).first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"listing with id {listingid} doesn't exist, or the host is trying to reserve their own listing")
    # Get all transactions involving this listingid
    reserved_dates = db.query(models.Transactions).filter(
        models.Transactions.listing_id == listingid).order_by(models.Transactions.checkin_date.asc()).all()
    return reserved_dates


@router.post("/reserve/guest", status_code=status.HTTP_201_CREATED)
def create_reservation(request: reservationSchemas.CreateReservation, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if listing exists or not and also the guest cant be the host
    listing = db.query(models.Listings).filter(models.Listings.listing_id ==
                                               request.listing_id, models.Listings.host_id != current_user_id).first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"listing with id {request.listing_id} doesn't exist, or the host is trying to reserve their own listing")
    if request.checkout_date <= request.checkin_date:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f"checkout_date must be greater than checkin_date")
    nights = (request.checkout_date - request.checkin_date).days
    if nights > listing.max_nights or nights < listing.min_nights:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f"stay is greater than max_nights or lesser than min_nights")
    # Calculates the bill
    amountdue = nights * listing.nightly_price
    # Create the reservation object
    insert_reservation = models.Reservations(
        listing_id=request.listing_id,
        guest_id=current_user_id,
        checkin_date=request.checkin_date,
        checkout_date=request.checkout_date,
        amount_due=amountdue
    )
    db.add(insert_reservation)
    db.commit()
    return {"Status": "Success", "amount_due": amountdue}


@router.get("/reservations/guest", status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.Reservations])
def get_reservations_for_guest(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    reservations = db.query(models.Reservations.reservation_id, models.Reservations.checkin_date, models.Reservations.checkout_date, models.Reservations.amount_due, models.Listings.title, models.Listings.listing_id).filter(
        models.Listings.listing_id == models.Reservations.listing_id, models.Reservations.guest_id == current_user_id).order_by(models.Reservations.created_time.asc()).all()
    return reservations


@router.get("/reservations/host", status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.Reservations])
def get_reservations_for_host(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    reservations = db.query(models.Reservations.reservation_id, models.Reservations.checkin_date, models.Reservations.checkout_date, models.Reservations.amount_due, models.Listings.title, models.Listings.listing_id).filter(
        models.Listings.listing_id == models.Reservations.listing_id, models.Listings.host_id == current_user_id, models.Reservations.status == "Pending").order_by(models.Reservations.created_time.asc()).all()
    return reservations


@router.get("/transactions/guest", status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.TransactionsGuest])
def get_transactions_for_guest(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    transactions = db.query(models.Transactions.transaction_id, models.Transactions.checkin_date, models.Transactions.checkout_date, models.Transactions.amount_paid, models.Listings.title, models.Listings.listing_id).filter(
        models.Listings.listing_id == models.Transactions.listing_id, models.Transactions.guest_id == current_user_id).order_by(models.Transactions.created_time.asc()).all()
    return transactions


@router.get("/transactions/host", status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.TransactionsHost])
def get_transactions_for_host(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    transactions = db.query(models.Transactions.transaction_id, models.Transactions.checkin_date, models.Transactions.checkout_date, models.Transactions.amount_paid, models.Listings.title, models.Listings.listing_id).filter(
        models.Listings.listing_id == models.Transactions.listing_id, models.Listings.host_id == current_user_id).order_by(models.Transactions.created_time.asc()).all()
    return transactions

@router.get("/reservation-status/guest/{reservationid}", status_code=status.HTTP_200_OK)
def check_reservation_status(reservationid: int,db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    reservation_query = db.query(models.Reservations).filter(models.Reservations.reservation_id == reservationid, models.Reservations.guest_id == current_user_id)
    reservation = reservation_query.first()
    if not reservation:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"reservation with id {reservationid} doesn't exist or it wasn't made by the current user")
    reservation_status=reservation.status
    # Decide what to do with the reservation record while we tell the guest about its status
    if reservation_status=="Accepted":
        insert_transaction = models.Transactions(
            listing_id=reservation.listing_id,
            guest_id=reservation.guest_id,
            checkin_date=reservation.checkin_date,
            checkout_date=reservation.checkout_date,
            amount_paid=reservation.amount_due
        )
        reservation_query.delete(synchronize_session=False)
        db.add(insert_transaction)
        db.commit()
    elif reservation_status=="Rejected":
        reservation_query.delete(synchronize_session=False)
        db.commit()
    return {"status": reservation_status}

#Host checks the guest's details and decides to accept or decline in another API Call
@router.get("/guest-profile/host/{reservationid}", status_code=status.HTTP_200_OK, response_model=reservationSchemas.GuestProfile)
def get_guest_profile(reservationid: int,db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    reservation_query = db.query(models.Users).filter(models.Users.user_id == models.Reservations.guest_id, models.Reservations.listing_id == models.Listings.listing_id, models.Reservations.reservation_id == reservationid, models.Listings.host_id == current_user_id)
    reservation = reservation_query.first()
    if not reservation:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"reservation with id {reservationid} doesn't exist or it wasn't sent to the current user")
    return reservation

@router.put("/reservation-status/host/{reservationid}/{IsAccepted}", status_code=status.HTTP_200_OK)
def accept_or_reject_reservation(reservationid: int, IsAccepted: bool, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    reservation_query = db.query(models.Reservations).filter(models.Reservations.listing_id == models.Listings.listing_id, models.Reservations.reservation_id == reservationid, models.Reservations.status == "Pending", models.Listings.host_id == current_user_id)
    reservation = reservation_query.first()
    if not reservation:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"reservation with id {reservationid} doesn't exist or it wasn't sent to the current user")
    if IsAccepted:
        reservation_query.update({"status": "Accepted"},synchronize_session=False)
    else:
        reservation_query.update({"status": "Rejected"},synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "Reservation status updated"}