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

# We wont check if its listed or not since we need to display this in transactions history even if the host unlists it
@router.get("/r-and-r-list/{listingid}", status_code=status.HTTP_200_OK, response_model=List[ratingandquestionSchemas.RandR])
def show_R_and_R_list(listingid: int, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if listing exists or not
    listing = db.query(models.Listings).filter(models.Listings.listing_id == listingid).first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"listing with id {listingid} doesn't exist")
    # Get all Reviews and Ratings involving this listingid
    R_and_R = db.query(models.Ratings_and_reviews.rating, models.Ratings_and_reviews.review, models.Users.first_name, models.Users.last_name).filter(
        models.Ratings_and_reviews.listing_id == listingid).join(models.Users, models.Users.user_id == models.Ratings_and_reviews.guest_id,isouter=True).order_by(models.Ratings_and_reviews.created_time.desc()).all()
    return R_and_R

#We dont add a dependency for checkout transactions since this API is only called when the button for it becomes clickable which means checkout must have arrived 
@router.post("/rate-and-review/guest", status_code=status.HTTP_201_CREATED)
def guest_rates(request: ratingandquestionSchemas.GuestRandR, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if transaction exists or not for which a rating is being given and if the current user is the guest in it
    transaction_query = db.query(models.Transactions).filter(models.Transactions.transaction_id == request.transaction_id, models.Transactions.has_guest_rated == False, models.Transactions.guest_id == current_user_id)
    transaction = transaction_query.first()
    if not transaction:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"Transaction with id {request.transaction_id} doesn't exist, or the current user is not the guest in it, or its already rated, or checkout date hasn't arrived yet")
    # Transaction will be updated, since the guest has rated the host and listing
    transaction_query.update({"has_guest_rated": True},synchronize_session=False)

    # Get the host of the transaction
    host_query = db.query(models.Users).filter(models.Transactions.listing_id==models.Listings.listing_id, models.Listings.host_id==models.Users.user_id)
    host = host_query.first()
    # Calculate host's new rating avg and total, update the host
    new_total = host.total_host_rating + 1
    new_ratingsum = (host.avg_host_rating*host.total_host_rating) + request.rating_of_host
    new_avg = new_ratingsum // new_total
    host_query.update({"total_host_rating":new_total, "avg_host_rating":new_avg},synchronize_session=False)
    db.commit()
    
    # Get the listing of the transaction
    listing_query = db.query(models.Listings).filter(models.Transactions.listing_id==models.Listings.listing_id, models.Transactions.transaction_id==request.transaction_id)
    listing = listing_query.first()
    # Calculate listing's new rating avg and total, update the listing
    new_total = listing.total_ratings + 1
    new_ratingsum = (listing.rating*listing.total_ratings) + request.rating_of_listing
    new_avg = new_ratingsum // new_total
    listing_query.update({"total_ratings":new_total, "rating":new_avg},synchronize_session=False)
    db.commit()

    # Add a new rating and review object for the listing
    insert_R_and_R = models.Ratings_and_reviews(
        listing_id=listing.listing_id,
        guest_id=current_user_id,
        rating=request.rating_of_listing,
        review=request.review_of_listing
    )
    db.add(insert_R_and_R)
    db.commit()

    return {"Status": "Success", "Detail": "Host rated the Guest"}

#We dont add a dependency for checkout transactions since this API is only called when the button for it becomes clickable which means checkout must have arrived 
@router.post("/rate-and-review/host", status_code=status.HTTP_201_CREATED)
def host_rates(request: ratingandquestionSchemas.HostRandR, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # Check if transaction exists or not for which a rating is being given and if the current user is the host in it
    transaction_query = db.query(models.Transactions).filter(models.Transactions.listing_id == models.Listings.listing_id, models.Transactions.transaction_id == request.transaction_id, models.Listings.host_id == current_user_id, models.Transactions.has_host_rated == False)
    transaction = transaction_query.first()
    if not transaction:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"Transaction with id {request.transaction_id} doesn't exist, or the current user is not the host in it, or its already rated, or checkout date hasn't arrived yet")
    # Transaction will be updated, since the host has rated the guest
    transaction_query.update({"has_host_rated": True},synchronize_session=False)
    # New avg and New total rating calculated for the guest of the transaction
    guest_query = db.query(models.Users).filter(models.Users.user_id==transaction.guest_id)
    guest = guest_query.first()
    new_total = guest.total_guest_rating + 1
    new_ratingsum = (guest.avg_guest_rating*guest.total_guest_rating) + request.rating_of_guest
    new_avg = new_ratingsum // new_total
    guest_query.update({"total_guest_rating":new_total, "avg_guest_rating":new_avg},synchronize_session=False)
    db.commit()
    return {"Status": "Success", "Detail": "Host rated the Guest"}