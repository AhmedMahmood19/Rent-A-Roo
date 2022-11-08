# (ORM)models must be exactly like the schemas for our database tables, 1 model for each table in our database
from sqlalchemy import Boolean, Integer, String, Text, Column
from sqlalchemy.ext.declarative import declarative_base

# We will inherit from the class "Base" to create each database model
Base = declarative_base()

# VARCHAR in databases don't occupy unneeded space. Thus, there is no reason to put length constraints on them. Unless for UI
# naming conventions: Class and Table name and attrs are ALLCAPS
class USER(Base):
    __tablename__ = "USERS"
    USER_ID = Column(Integer, primary_key=True, index=True)
    EMAIL = Column(String, nullable=False, unique=True)
    PASSWORD = Column(String, nullable=False)
    FIRST_NAME = Column(String, nullable=False)
    LAST_NAME = Column(String, nullable=False)
    PHONE_NO = Column(String(11), nullable=False)
    #Look into default images later
    PROFILE_IMAGE_PATH = Column(String, nullable=True)
    AVG_HOST_RATING = Column(Integer, nullable=True, default=0)
    AVG_GUEST_RATING = Column(Integer, nullable=True, default=0)
    TOTAl_HOST_RATING = Column(Integer, nullable=True, default=0)
    TOTAL_GUEST_RATING = Column(Integer, nullable=True, default=0)
    ABOUT_ME = Column(String, nullable=True)