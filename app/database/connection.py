# This file will be used to link the backend application to the database. DONT CHANGE ANYTHING HERE
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database import models

SQLALCHEMY_DATABASE_URL = "postgresql://postgres:12345678@localhost:5432/rentaroo-db"

# echo=True means it prints the SQL Queries in the terminal
engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

#This assigns a session to every endpoint that needs it and closes it afterwards
def get_db():
    # Creates a new connection/session to the database
    db = SessionLocal()
    try:
        # Allows a route to use the same session through a request
        yield db
    finally:
        # Closes it when the request is finished
        db.close()

# Whenever the server runs this will drop all the tables and create all the tables
models.Base.metadata.drop_all(bind=engine)
models.Base.metadata.create_all(bind=engine)
#Adding Dummy data
dummy=SessionLocal()
dummy.add(models.USER(EMAIL="pam@gmail.com", PASSWORD="pamb", FIRST_NAME="Pam", LAST_NAME="Beesly", PHONE_NO="03348652936", ABOUT_ME="I love to keep my home nice and tidy, so you never have to worry when staying at my house."))
dummy.add(models.USER(EMAIL="jim@gmail.com", PASSWORD="jim123", FIRST_NAME="Jim", LAST_NAME="Halpert", PHONE_NO="03348652936", ABOUT_ME="Me and my wife Pam love having people stay at our house and explore our city."))
dummy.add(models.USER(EMAIL="abc@gmail.com", PASSWORD="abc", FIRST_NAME="Michael", LAST_NAME="Scott", PHONE_NO="03231932775", ABOUT_ME="I am new to all this tech stuff and keep forgetting my password but I can rent out my home if anyone is willing to pay."))
dummy.commit()
dummy.close()