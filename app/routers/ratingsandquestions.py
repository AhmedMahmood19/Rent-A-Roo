from fastapi import APIRouter, Depends, status, HTTPException
from routers import Authentication
from database import models, connection
from schemas import ratingandquestionSchemas
from sqlalchemy.orm import Session
from typing import List

router = APIRouter(tags=["Ratings and Reviews, Questions and Answers"])

# We wont check if its listed or not since we need to display this in transactions history even if the host unlists it
@router.get("/q-and-a-list/{listingid}", status_code=status.HTTP_200_OK, response_model=List[ratingandquestionSchemas.QandA])
def show_Q_and_A_list(listingid: int, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if listing exists or not
    listing = db.query(models.Listings).filter(models.Listings.listing_id == listingid).first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"listing with id {listingid} doesn't exist")
    # Get all Questions and Answers involving this listingid
    Q_and_A = db.query(models.Questions_and_answers.question_id, models.Questions_and_answers.question, models.Questions_and_answers.answer, models.Users.first_name, models.Users.last_name).filter(
        models.Questions_and_answers.listing_id == listingid).join(models.Users, models.Users.user_id == models.Questions_and_answers.guest_id,isouter=True).order_by(models.Questions_and_answers.created_time.desc()).all()
    return Q_and_A

@router.post("/ask-question/guest", status_code=status.HTTP_201_CREATED)
def ask_question(request: ratingandquestionSchemas.AskQ, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if listing exists or not and also the guest(asker) cant be the host
    listing = db.query(models.Listings).filter(models.Listings.listing_id == request.listing_id, models.Listings.is_listed == True, models.Listings.host_id != current_user_id).first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"listing with id {request.listing_id} doesn't exist, or the host is trying to ask a question on their own listing")
    # Create the Question object
    insert_question = models.Questions_and_answers(
        listing_id=request.listing_id,
        guest_id=current_user_id,
        question=request.question
    )
    db.add(insert_question)
    db.commit()
    return {"Status": "Success", "Detail": "Question Added"}

@router.post("/answer-question/host", status_code=status.HTTP_201_CREATED)
def answer_question(request: ratingandquestionSchemas.AnswerQ, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if question exists or not and also the answerer must be the host and the answer must be null
    question = db.query(models.Questions_and_answers).filter(models.Questions_and_answers.listing_id == models.Listings.listing_id, models.Listings.is_listed == True, models.Listings.host_id == current_user_id, models.Questions_and_answers.question_id == request.question_id, models.Questions_and_answers.answer == None)
    if not question.first():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"Question with id {request.question_id} doesn't exist, the question already has an answer, or the user trying to answer a question is not the host of the listing")
    question.update({"answer": request.answer},synchronize_session=False)
    db.commit()
    return {"Status": "Success", "Detail": "Answer Added"}

# # We allow it to use an unlisted listing, so we can show them that their reservation was rejected(due to it being unlisted)
# #DEPENDS on expire_reservations since we need to access reservations here
# @router.get("/reservations/guest", dependencies=[Depends(expire_reservations)], status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.Reservations])
# def get_reservations_for_guest(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     reservations = db.query(models.Reservations.reservation_id, models.Reservations.checkin_date, models.Reservations.checkout_date, models.Reservations.amount_due, models.Listings.title, models.Listings.listing_id).filter(
#         models.Listings.listing_id == models.Reservations.listing_id, models.Reservations.guest_id == current_user_id).order_by(models.Reservations.created_time.asc()).all()
#     return reservations

# #DEPENDS on expire_reservations since we need to access reservations here
# @router.get("/reservations/host", dependencies=[Depends(expire_reservations)], status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.Reservations])
# def get_reservations_for_host(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     reservations = db.query(models.Reservations.reservation_id, models.Reservations.checkin_date, models.Reservations.checkout_date, models.Reservations.amount_due, models.Listings.title, models.Listings.listing_id).filter(
#         models.Listings.listing_id == models.Reservations.listing_id, models.Listings.is_listed == True, models.Listings.host_id == current_user_id, models.Reservations.status == "Pending").order_by(models.Reservations.created_time.asc()).all()
#     return reservations

# # We allow it to view unlisted listings in transactions
# @router.get("/transactions/guest", dependencies=[Depends(checkout_transactions)], status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.TransactionsGuest])
# def get_transactions_for_guest(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     transactions = db.query(models.Transactions.transaction_id, models.Transactions.checkin_date, models.Transactions.checkout_date, models.Transactions.amount_paid, models.Listings.title, models.Listings.listing_id, models.Transactions.has_guest_rated).filter(
#         models.Listings.listing_id == models.Transactions.listing_id, models.Transactions.guest_id == current_user_id).order_by(models.Transactions.created_time.asc()).all()
#     return transactions

# # We allow it to view unlisted listings in transactions
# @router.get("/transactions/host", dependencies=[Depends(checkout_transactions)], status_code=status.HTTP_200_OK, response_model=List[reservationSchemas.TransactionsHost])
# def get_transactions_for_host(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     transactions = db.query(models.Transactions.transaction_id, models.Transactions.checkin_date, models.Transactions.checkout_date, models.Transactions.amount_paid, models.Listings.title, models.Listings.listing_id, models.Transactions.has_host_rated).filter(
#         models.Listings.listing_id == models.Transactions.listing_id, models.Listings.host_id == current_user_id).order_by(models.Transactions.created_time.asc()).all()
#     return transactions

# #DEPENDS on expire_reservations since we need to access reservations here
# @router.get("/reservation-status/guest/{reservationid}", dependencies=[Depends(expire_reservations)], status_code=status.HTTP_200_OK)
# def check_reservation_status(reservationid: int,db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     reservation_query = db.query(models.Reservations).filter(models.Reservations.reservation_id == reservationid, models.Reservations.guest_id == current_user_id)
#     reservation = reservation_query.first()
#     if not reservation:
#         raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"reservation with id {reservationid} doesn't exist or it wasn't made by the current user")
#     reservation_status=reservation.status
#     # Decide what to do with the reservation record while we tell the guest about its status
#     if reservation_status=="Accepted":
#         # THIS IS THE ONLY PLACE WHERE A TUPLE CAN BE INSERTED INTO TRANSACTIONS
#         insert_transaction = models.Transactions(
#             listing_id=reservation.listing_id,
#             guest_id=reservation.guest_id,
#             checkin_date=reservation.checkin_date,
#             checkout_date=reservation.checkout_date,
#             amount_paid=reservation.amount_due
#         )
#         reservation_query.delete(synchronize_session=False)
#         db.add(insert_transaction)
#         db.commit()
#     elif reservation_status=="Rejected":
#         reservation_query.delete(synchronize_session=False)
#         db.commit()
#     return {"status": reservation_status}

# #Host checks the guest's details and decides to accept or decline in another API Call
# #DEPENDS on expire_reservations since we need to access reservations here
# @router.get("/guest-profile/host/{reservationid}", dependencies=[Depends(expire_reservations)], status_code=status.HTTP_200_OK, response_model=reservationSchemas.GuestProfile)
# def get_guest_profile(reservationid: int,db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     reservation_query = db.query(models.Users).filter(models.Users.user_id == models.Reservations.guest_id, models.Reservations.listing_id == models.Listings.listing_id, models.Listings.is_listed == True, models.Reservations.status == "Pending", models.Reservations.reservation_id == reservationid, models.Listings.host_id == current_user_id)
#     reservation = reservation_query.first()
#     if not reservation:
#         raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"reservation with id {reservationid} doesn't exist or it wasn't sent to the current user.[Rare:It expired(>=24hrs) by the time you pressed to view guest's profile]")
#     return reservation

# #DEPENDS on expire_reservations since we need to access reservations here
# @router.put("/reservation-status/host/{reservationid}/{IsAccepted}", dependencies=[Depends(expire_reservations)], status_code=status.HTTP_200_OK)
# def accept_or_reject_reservation(reservationid: int, IsAccepted: bool, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     reservation_query = db.query(models.Reservations).filter(models.Reservations.listing_id == models.Listings.listing_id, models.Listings.is_listed == True, models.Reservations.reservation_id == reservationid, models.Reservations.status == "Pending", models.Listings.host_id == current_user_id)
#     reservation = reservation_query.first()
#     if not reservation:
#         raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"reservation with id {reservationid} doesn't exist or it wasn't sent to the current user.[Rare:It expired(>=24hrs) by the time you pressed accept/reject]")
#     if IsAccepted:
#         begin=reservation.checkin_date;
#         end=reservation.checkout_date;
#         acceptedlistingid=reservation.listing_id;
#         reservation_query.update({"status": "Accepted"},synchronize_session=False)
#         # For any pending reservations with the same listing_id as the one just accepted, if the stay overlaps with the accepted one then reject these reservations 
#         reservation_query = db.query(models.Reservations).filter(models.Reservations.listing_id == acceptedlistingid, models.Reservations.status == "Pending", (models.Reservations.checkin_date.between(begin,end) | models.Reservations.checkout_date.between(begin,end)))
#         reservation_query.update({"status": "Rejected"},synchronize_session=False)
#     else:
#         reservation_query.update({"status": "Rejected"},synchronize_session=False)
#     db.commit()
#     return {"status": "Success", "Detail": "Reservation status updated"}