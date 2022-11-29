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
# Adding Dummy data and committing after inserting into each table
dummy = SessionLocal()
dummy.add(models.Users(email="pam@gmail.com", password="pamb", first_name="Pam", last_name="Beesly", phone_no="03348652936", image_path="/static/images/ae9f7e4b1.jpg",
          about_me="I love to keep my home nice and tidy, so you never have to worry when staying at my house."))
dummy.add(models.Users(email="jim@gmail.com", password="jim123", first_name="Jim", last_name="Halpert", image_path="/static/images/29eb25b52.webp",
          phone_no="03348652936", about_me="Me and my wife Pam love having people stay at our house and explore our city."))
dummy.add(models.Users(email="abc@gmail.com", password="abc", first_name="Michael", last_name="Scott", phone_no="03231932775", image_path="/static/images/e4f035533.png",
          about_me="I am new to all this tech stuff and keep forgetting my password but I can rent out my home if anyone is willing to pay."))
dummy.commit()
dummy.close()

dummy = SessionLocal()
dummy.add(models.Listings(host_id=2, title="Beach house with a great view", description="You can view the beautiful sea from the terrace of the house, all rooms have brown marble flooring with wide windows that open up directly to the sea", state="Sindh", city="Karachi", address="Plot D-28, 38th St, Phase 6 DHA",
          is_apartment=False, is_shared=False, accommodates=5, bathrooms=3, bedrooms=4, nightly_price=7500, min_nights=2, max_nights=15, wifi=True, kitchen=True, washing_machine=True, air_conditioning=True, tv=True, hair_dryer=False, iron=False, pool=False, gym=False, smoking_allowed=False))
dummy.add(models.Listings(host_id=1, title="Luxurious apartment in the middle of the city", description="The apartment has a single master bedroom but it is big enough to fit around 4 people, but it only has a single bed", state="Punjab", city="Lahore", address="Apartment 22E, Sector B Apartments, Askari 11",
          is_apartment=True, apartment_no="22E", is_shared=False, accommodates=4, bathrooms=1, bedrooms=1, nightly_price=2400, min_nights=5, max_nights=10, wifi=True, kitchen=True, washing_machine=False, air_conditioning=False, tv=False, hair_dryer=False, iron=False, pool=False, gym=False, smoking_allowed=True))
dummy.commit()
dummy.close()

dummy = SessionLocal()
dummy.add(models.Listing_images(listing_id=1, image_path="/static/images/4388ffc71.webp"))
dummy.add(models.Listing_images(listing_id=1, image_path="/static/images/567827721.webp"))
dummy.add(models.Listing_images(listing_id=1, image_path="/static/images/93adb9c61.webp"))
dummy.add(models.Listing_images(listing_id=2, image_path="/static/images/bc407f779221.jpg"))
dummy.add(models.Listing_images(listing_id=2, image_path="/static/images/bc407f779222.jpg"))
dummy.add(models.Listing_images(listing_id=2, image_path="/static/images/bc407f779223.jpg"))
dummy.commit()
dummy.close()

from datetime import datetime, timedelta, timezone
start = datetime.utcnow()
dummy = SessionLocal()
dummy.add(models.Promoted_listings(listing_id=2, start_time=start ,end_time=start + timedelta(days=2)))
dummy.add(models.Favourites(guest_id=3,listing_id=1))
dummy.add(models.Reservations(listing_id=1,guest_id=1,checkin_date=datetime(2022, 11, 20, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 1, 9, 00, 00, 000000,tzinfo=timezone.utc),amount_due=82500))
dummy.add(models.Transactions(listing_id=1,guest_id=1,checkin_date=datetime(2022, 11, 8, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 11, 19, 9, 00, 00, 000000,tzinfo=timezone.utc),amount_paid=82500))
dummy.commit()
dummy.close()

dummy = SessionLocal()
dummy.add(models.Reservations(listing_id=1,guest_id=1,checkin_date=datetime(2022, 12, 6, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 13, 9, 00, 00, 000000,tzinfo=timezone.utc),amount_due=52500))
dummy.add(models.Transactions(listing_id=1,guest_id=1,checkin_date=datetime(2022, 12, 14, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 21, 9, 00, 00, 000000,tzinfo=timezone.utc),amount_paid=52500))
dummy.commit()
dummy.close()