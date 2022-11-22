# (ORM)models must be exactly like the schemas for our database tables, 1 model for each table in our database
from sqlalchemy import Boolean, Integer, String, Column, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

# We will inherit from the class "Base" to create each database model
Base = declarative_base()

# VARCHAR in databases don't occupy unneeded space. Thus, there is no reason to put length constraints on them. Unless for UI
# naming conventions: Class and Table name and attrs are ALLCAPS

#USERS CAN BE DELETED
class USERS(Base):
    __tablename__ = "USERS"
    USER_ID = Column(Integer, primary_key=True, index=True)
    EMAIL = Column(String, nullable=False, unique=True)
    PASSWORD = Column(String, nullable=False)
    FIRST_NAME = Column(String, nullable=False)
    LAST_NAME = Column(String, nullable=False)
    PHONE_NO = Column(String(11), nullable=False)
    USER_IMAGE_PATH = Column(String, nullable=True, default="/static/images/defaultUSERpic.jpg")
    AVG_HOST_RATING = Column(Integer, nullable=True, default=0)
    AVG_GUEST_RATING = Column(Integer, nullable=True, default=0)
    TOTAl_HOST_RATING = Column(Integer, nullable=True, default=0)
    TOTAL_GUEST_RATING = Column(Integer, nullable=True, default=0)
    ABOUT_ME = Column(String, nullable=True)

# LISTINGS CAN'T BE DELETED (CAN UNLIST AS LONG AS THERE ARE NO RESERVATIONS, CONFIRMED TRANSACTIONS STILL GO THROUGH EVEN IF UNLISTED)
class LISTINGS(Base):
    __tablename__ = "LISTINGS"
    LISTING_ID = Column(Integer, primary_key=True, index=True)
    HOST_ID=Column(Integer, ForeignKey("USERS.USER_ID", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL
    host = relationship("USERS",backref="listings")
    TITLE = Column(String, nullable=False)
    DESCRIPTION = Column(String, nullable=False)
    STATE = Column(String, nullable=False)
    CITY = Column(String, nullable=False)
    ADDRESS = Column(String, nullable=False)
    IS_APARTMENT = Column(Boolean, nullable=False)
    APARTMENT_NO = Column(Integer, nullable=True)       #IF PREVIOUS ATTR. IS TRUE THEN THIS WILL BE INPUT, OTHERWISE IT'S NULL
    GPS_LOCATION = Column(String, nullable = True)      #CHANGE LATER FOR PROPER GPS IMPLEMENTATION
    IS_SHARED = Column(Boolean, nullable = False)       #WILL THE HOST BE LIVING IN THE SAME PROPERTY OR NOT
    ACCOMMODATES = Column(Integer, nullable = False)    #HOW MANY PEOPLE CAN THIS PROPERTY ACCOMMODATE
    BATHROOMS = Column(Integer, nullable = False)
    BEDROOMS = Column(Integer, nullable = False)
    NIGHTLY_PRICE = Column(Integer, nullable = False)   #SINCE APP IS FOR PAKISTAN, PKR WILL ALWAYS BE INTEGER
    MIN_NIGHTS = Column(Integer, nullable = False)
    MAX_NIGHTS = Column(Integer, nullable = False)
    WIFI = Column(Boolean, nullable = False)
    KITCHEN = Column(Boolean, nullable = False)
    WASHING_MACHINE = Column(Boolean, nullable = False)
    AIR_CONDITIONING = Column(Boolean, nullable = False)
    TV =  Column(Boolean, nullable = False)
    HAIR_DRYER = Column(Boolean, nullable = False)
    IRON = Column(Boolean, nullable = False)
    POOL = Column(Boolean, nullable = False)
    GYM = Column(Boolean, nullable = False)
    SMOKING_ALLOWED = Column(Boolean, nullable = False)
    TOTAL_RATINGS = Column(Integer, nullable = True, default=0)
    RATING = Column(Integer, nullable = True, default=0)
    VIEW_COUNT = Column(Integer, nullable = True, default=0)
    IS_LISTED = Column(Boolean, nullable = True, default=True)     #IF USER DELETED/LISTING IS UNLISTED THEN SET THIS TO FALSE, SINCE WE WON'T DELETE LISTINGS

#LISTING_IMAGES CAN'T BE DELETED
class LISTING_IMAGES(Base):
    __tablename__ = "LISTING_IMAGES"
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"), primary_key=True)   #Didnt add index to composite primary keys yet!!!
    listings = relationship("LISTINGS",backref="listingimages")
    IMAGE_PATH = Column(String, primary_key=True)

#RATINGS_AND_REVIEWS CAN'T BE DELETED
class RATINGS_AND_REVIEWS(Base):
    __tablename__ = "RATINGS_AND_REVIEWS"
    REVIEW_ID = Column(Integer, primary_key=True, index=True)
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"))
    listings = relationship("LISTINGS",backref="ratingsandreviews")
    GUEST_ID = Column(Integer, ForeignKey("USERS.USER_ID", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL, SHOW AS (DELETED USER) ON LISTING PAGE
    guest = relationship("USERS",backref="ratingsandreviews")
    RATING = Column(Integer, nullable=False)
    REVIEW = Column(String, nullable=True)          #REVIEW TEXT IS OPTIONAL
    CREATED_TIME = Column(DateTime, server_default=func.now())  #TO SHOW REVIEWS IN ORDER

#QUESTIONS_AND_ANSWERS CAN'T BE DELETED
class QUESTIONS_AND_ANSWERS(Base):
    __tablename__ = "QUESTIONS_AND_ANSWERS"
    QUESTION_ID = Column(Integer, primary_key=True, index=True)
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"))
    listings = relationship("LISTINGS",backref="questionsandanswers")
    GUEST_ID = Column(Integer, ForeignKey("USERS.USER_ID", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL, SHOW AS (DELETED USER) ON LISTING PAGE
    guest = relationship("USERS",backref="questionsandanswers")
    QUESTION = Column(String, nullable=False)
    ANSWER = Column(String, nullable=True)                       #NULL UNTIL HOST ANSWERS IT
    CREATED_TIME = Column(DateTime, server_default=func.now())   #TO SHOW Q&A IN ORDER

#PROMOTED_LISTINGS CAN BE DELETED(IF END_TIME IS REACHED, IF LISTING IS UNLISTED)
class PROMOTED_LISTINGS(Base):
    __tablename__ = "PROMOTED_LISTINGS"
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"), primary_key=True, index=True)
    listings = relationship("LISTINGS",backref="promotedlistings")
    START_TIME = Column(DateTime, server_default=func.now())
    END_TIME = Column(DateTime, nullable=False)             #WILL BE A FIXED DURATION AFTER THE START_TIME

#FAVOURITES CAN BE DELETED(IF USER UNFAVOURITES OR USER IS DELETED)
class FAVOURITES(Base):
    __tablename__ = "FAVOURITES"
    GUEST_ID = Column(Integer, ForeignKey("USERS.USER_ID", ondelete="CASCADE"), primary_key=True) #IF USER IS DELETED THEN DELETE FAVOURITES TOO
    guest = relationship("USERS",backref="favourites")
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"), primary_key=True)
    listings = relationship("LISTINGS",backref="favourites")

#RESERVATIONS CAN BE DELETED(THROUGH NORMAL FLOW OR IF USER IS DELETED)
class RESERVATIONS(Base):
    __tablename__ = "RESERVATIONS"
    RESERVATION_ID = Column(Integer, primary_key=True, index=True)
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"))
    listings = relationship("LISTINGS",backref="reservations")
    GUEST_ID = Column(Integer, ForeignKey("USERS.USER_ID", ondelete="CASCADE")) #IF USER IS DELETED THEN DELETE RESERVATIONS TOO
    guest = relationship("USERS",backref="reservations")    
    CHECKIN_DATE = Column(DateTime, nullable=False)         #WE WILL GIVE THE SAME TIME FOR CHECKIN AND CHECKOUT(12PM?) TO EVERYONE, ONLY DATE WILL BE SET BY GUEST
    CHECKOUT_DATE = Column(DateTime, nullable=False)
    CREATED_TIME = Column(DateTime, server_default=func.now())  #TO CHECK IF IT HAS BEEN 24Hrs SO WE CAN SET STATUS TO REJECTED
    AMOUNT_DUE  = Column(Integer, nullable = False)         #CALCULATED USING NIGHTLYPRICE AND NUMBER OF NIGHTS
    STATUS = Column(String, nullable=False)

#TRANSACTIONS CAN'T BE DELETED
class TRANSACTIONS(Base):
    __tablename__ = "TRANSACTIONS"
    TRANSACTION_ID = Column(Integer, primary_key=True, index=True)
    LISTING_ID = Column(Integer, ForeignKey("LISTINGS.LISTING_ID"))
    listings = relationship("LISTINGS",backref="transactions")
    GUEST_ID = Column(Integer, ForeignKey("USERS.USER_ID", ondelete="SET NULL")) #IF USER IS DELETED THEN SET IT TO NULL, SHOW AS (DELETED USER) ON LISTING PAGE
    guest = relationship("USERS",backref="transactions")
    CHECKIN_DATE = Column(DateTime, nullable=False)
    CHECKOUT_DATE = Column(DateTime, nullable=False)
    CREATED_TIME = Column(DateTime, server_default=func.now())  #TO SHOW TRANSACTIONS IN ORDER
    AMOUNT_PAID  = Column(Integer, nullable = False)


#########################################
### TO EXPLAIN HOW RELATIONSHIP WORKS ###
#########################################
# class Parent(Base):
#    __tablename__="Parent"
#    id=Column(Integer,primary_key=True,index=True,autoincrement=True)


# class Child(Base):
#     __tablename__= "Child"
#     id=Column(Integer, primary_key= True)
#     #foreign key: Child.Parent_id -> Parent.id 
#     parent_id=Column(Integer, ForeignKey('Parent.id', ondelete='SET NULL'))
#     parents = relationship("Parent",backref="children")
#########################################