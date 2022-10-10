# This file will contain the ORM models(schemas for database tables)
from sqlalchemy import Boolean, Integer, String, Text, Column
from .database import Base


# Write down the schemas for all the tables in our database like below
class USER(Base):
    __tablename__ = "USERS"
    USER_ID = Column(Integer, primary_key=True, index=True)
    PASSWORD = Column(String(255), nullable=False)
    EMAIL = Column(String(255), nullable=False, unique=True)
    FIRST_NAME = Column(String(255), nullable=True)
    LAST_NAME = Column(String(255), nullable=True)
