# This file will be used to link the backend application to the database. DONT CHANGE ANYTHING HERE
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = "postgresql://postgres:12345678@localhost:5432/rentaroo-db"

# echo=True means it prints the SQL Queries in the terminal
engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# We will inherit from the class "Base" to create each of the database models/classes (the ORM models)
Base = declarative_base()
