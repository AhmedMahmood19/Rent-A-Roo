# (ORM)models must be exactly like the schemas for our database tables, 1 model for each table in our database
from sqlalchemy import Boolean, Integer, String, Column, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

# We will inherit from the class "Base" to create each database model
Base = declarative_base()

# VARCHAR in databases don't occupy unneeded space. Thus, there is no reason to put length constraints on them. Unless for UI
# Naming Convention: Class name will be Initcap, attribute names will be lowercase

#users CAN BE DELETED
class Users(Base):
    __tablename__ = "users"
    user_id = Column(Integer, primary_key=True, index=True)
    email = Column(String, nullable=False, unique=True)
    password = Column(String, nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    phone_no = Column(String(11), nullable=False)
    image_path = Column(String, nullable=True, default="/static/images/defaultprofilepic.jpg")
    avg_host_rating = Column(Integer, nullable=True, default=0)
    avg_guest_rating = Column(Integer, nullable=True, default=0)
    total_host_rating = Column(Integer, nullable=True, default=0)
    total_guest_rating = Column(Integer, nullable=True, default=0)
    about_me = Column(String, nullable=True)

# listings CAN'T BE DELETED (CAN UNLIST AS LONG AS THERE ARE NO RESERVATIONS, CONFIRMED TRANSACTIONS STILL GO THROUGH EVEN IF UNLISTED)
class Listings(Base):
    __tablename__ = "listings"
    listing_id = Column(Integer, primary_key=True, index=True)
    host_id=Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    state = Column(String, nullable=False)
    city = Column(String, nullable=False)
    address = Column(String, nullable=False)
    is_apartment = Column(Boolean, nullable=False)
    apartment_no = Column(String, nullable=True)       #IF PREVIOUS ATTR. IS TRUE THEN THIS WILL BE INPUT, OTHERWISE IT'S NULL
    gps_location = Column(String, nullable = True)      #CHANGE LATER FOR PROPER GPS IMPLEMENTATION
    is_shared = Column(Boolean, nullable = False)       #WILL THE HOST BE LIVING IN THE SAME PROPERTY OR NOT
    accommodates = Column(Integer, nullable = False)    #HOW MANY PEOPLE CAN THIS PROPERTY ACCOMMODATE
    bathrooms = Column(Integer, nullable = False)
    bedrooms = Column(Integer, nullable = False)
    nightly_price = Column(Integer, nullable = False)   #SINCE APP IS FOR PAKISTAN, PKR WILL ALWAYS BE INTEGER
    min_nights = Column(Integer, nullable = False)
    max_nights = Column(Integer, nullable = False)
    wifi = Column(Boolean, nullable = False)
    kitchen = Column(Boolean, nullable = False)
    washing_machine = Column(Boolean, nullable = False)
    air_conditioning = Column(Boolean, nullable = False)
    tv =  Column(Boolean, nullable = False)
    hair_dryer = Column(Boolean, nullable = False)
    iron = Column(Boolean, nullable = False)
    pool = Column(Boolean, nullable = False)
    gym = Column(Boolean, nullable = False)
    smoking_allowed = Column(Boolean, nullable = False)
    total_ratings = Column(Integer, nullable = True, default=0)
    rating = Column(Integer, nullable = True, default=0)
    view_count = Column(Integer, nullable = True, default=0)
    is_listed = Column(Boolean, nullable = True, default=True)     #IF USER DELETED/LISTING IS UNLISTED THEN SET THIS TO FALSE, SINCE WE WON'T DELETE listings

#listing_images CAN'T BE DELETED
class Listing_images(Base):
    __tablename__ = "listing_images"
    listing_id = Column(Integer, ForeignKey("listings.listing_id"), primary_key=True)   #Didnt add index to composite primary keys yet!!!
    image_path = Column(String, primary_key=True)

#ratings_and_reviews CAN'T BE DELETED
class Ratings_and_reviews(Base):
    __tablename__ = "ratings_and_reviews"
    review_id = Column(Integer, primary_key=True, index=True)
    listing_id = Column(Integer, ForeignKey("listings.listing_id"))
    guest_id = Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL, SHOW AS (DELETED USER) ON LISTING PAGE
    rating = Column(Integer, nullable=False)
    review = Column(String, nullable=True)          #REVIEW TEXT IS OPTIONAL
    created_time = Column(DateTime(timezone=True), nullable=True, server_default=func.now())  #TO SHOW REVIEWS IN ORDER

#questions_and_answers CAN'T BE DELETED
class Questions_and_answers(Base):
    __tablename__ = "questions_and_answers"
    question_id = Column(Integer, primary_key=True, index=True)
    listing_id = Column(Integer, ForeignKey("listings.listing_id"))
    guest_id = Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL, SHOW AS (DELETED USER) ON LISTING PAGE
    question = Column(String, nullable=False)
    answer = Column(String, nullable=True)                       #NULL UNTIL HOST ANSWERS IT
    created_time = Column(DateTime(timezone=True), nullable=True, server_default=func.now())   #TO SHOW Q&A IN ORDER

#promoted_listings CAN BE DELETED(IF END_TIME IS REACHED, IF LISTING IS UNLISTED)
class Promoted_listings(Base):
    __tablename__ = "promoted_listings"
    listing_id = Column(Integer, ForeignKey("listings.listing_id"), primary_key=True, index=True)
    start_time = Column(DateTime(timezone=True), nullable=False)
    end_time = Column(DateTime(timezone=True), nullable=False)             #WILL BE A FIXED DURATION AFTER THE START_TIME

#favourites CAN BE DELETED(IF USER UNFAVOURITES OR USER IS DELETED)
class Favourites(Base):
    __tablename__ = "favourites"
    guest_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), primary_key=True) #IF USER IS DELETED THEN DELETE FAVOURITES TOO
    listing_id = Column(Integer, ForeignKey("listings.listing_id"), primary_key=True)

#reservations CAN BE DELETED(THROUGH NORMAL FLOW OR IF USER IS DELETED)
class Reservations(Base):
    __tablename__ = "reservations"
    reservation_id = Column(Integer, primary_key=True, index=True)
    listing_id = Column(Integer, ForeignKey("listings.listing_id"))
    guest_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE")) #IF USER IS DELETED THEN DELETE RESERVATIONS TOO
    checkin_date = Column(DateTime(timezone=True), nullable=False)         #WE WILL GIVE THE SAME TIME FOR CHECKIN AND CHECKOUT(12PM?) TO EVERYONE, ONLY DATE WILL BE SET BY GUEST
    checkout_date = Column(DateTime(timezone=True), nullable=False)
    created_time = Column(DateTime(timezone=True), nullable=True, server_default=func.now())  #TO CHECK IF IT HAS BEEN 24Hrs SO WE CAN SET STATUS TO REJECTED
    amount_due  = Column(Integer, nullable = False)         #CALCULATED USING NIGHTLYPRICE AND NUMBER OF NIGHTS
    status = Column(String, nullable=True, default="Pending")

#transactions CAN'T BE DELETED
class Transactions(Base):
    __tablename__ = "transactions"
    transaction_id = Column(Integer, primary_key=True, index=True)
    listing_id = Column(Integer, ForeignKey("listings.listing_id"))
    guest_id = Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL, SHOW AS (DELETED USER) ON LISTING PAGE
    checkin_date = Column(DateTime(timezone=True), nullable=False)
    checkout_date = Column(DateTime(timezone=True), nullable=False)
    created_time = Column(DateTime(timezone=True), nullable=True, server_default=func.now())  #TO SHOW TRANSACTIONS IN ORDER
    amount_paid  = Column(Integer, nullable = False)
    #Initially Null, set to False if now()>=checkout_date, set to True if either user rates
    has_guest_rated  = Column(Boolean, nullable = True)                     #Has guest rated host and rated&reviewed listing yet?
    has_host_rated  = Column(Boolean, nullable = True)                      #Has host rated guest yet?
