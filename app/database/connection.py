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
# Adding Dummy data
dummy = SessionLocal()
dummy.add(models.USERS(EMAIL="pam@gmail.com", PASSWORD="pamb", FIRST_NAME="Pam", LAST_NAME="Beesly", PHONE_NO="03348652936",
          ABOUT_ME="I love to keep my home nice and tidy, so you never have to worry when staying at my house."))
dummy.add(models.USERS(EMAIL="jim@gmail.com", PASSWORD="jim123", FIRST_NAME="Jim", LAST_NAME="Halpert",
          PHONE_NO="03348652936", ABOUT_ME="Me and my wife Pam love having people stay at our house and explore our city."))
dummy.add(models.USERS(EMAIL="abc@gmail.com", PASSWORD="abc", FIRST_NAME="Michael", LAST_NAME="Scott", PHONE_NO="03231932775",
          ABOUT_ME="I am new to all this tech stuff and keep forgetting my password but I can rent out my home if anyone is willing to pay."))
dummy.add(models.LISTINGS(HOST_ID=2, TITLE="Beach house with a great view", DESCRIPTION="You can view the beautiful sea from the terrace of the house, all rooms have brown marble flooring with wide windows that open up directly to the sea", STATE="Sindh", CITY="Karachi", ADDRESS="Plot D-28, 38th St, Phase 6 DHA",
          IS_APARTMENT=False, IS_SHARED=False, ACCOMMODATES=5, BATHROOMS=3, BEDROOMS=4, NIGHTLY_PRICE=7781, MIN_NIGHTS=2, MAX_NIGHTS=15, WIFI=True, KITCHEN=True, WASHING_MACHINE=True, AIR_CONDITIONING=True, TV=True, HAIR_DRYER=False, IRON=False, POOL=False, GYM=False, SMOKING_ALLOWED=False))
dummy.add(models.LISTINGS(HOST_ID=1, TITLE="Luxurious apartment in the middle of the city", DESCRIPTION="The apartment has a single master bedroom but it is big enough to fit around 4 people, but it only has a single bed", STATE="Punjab", CITY="Lahore", ADDRESS="Apartment 22E, Sector B Apartments, Askari 11",
          IS_APARTMENT=True, IS_SHARED=False, ACCOMMODATES=4, BATHROOMS=1, BEDROOMS=1, NIGHTLY_PRICE=2400, MIN_NIGHTS=5, MAX_NIGHTS=10, WIFI=True, KITCHEN=True, WASHING_MACHINE=False, AIR_CONDITIONING=False, TV=False, HAIR_DRYER=False, IRON=False, POOL=False, GYM=False, SMOKING_ALLOWED=True))
dummy.add(models.LISTING_IMAGES(LISTING_ID=1, IMAGE_PATH="/static/images/dd2dc76a4d11.jpg"))
dummy.add(models.LISTING_IMAGES(LISTING_ID=2, IMAGE_PATH="/static/images/bc407f779221.jpg"))
dummy.commit()
dummy.close()
