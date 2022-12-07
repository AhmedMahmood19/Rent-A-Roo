# This file will be used to link the backend application to the database. DONT CHANGE ANYTHING HERE
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database import models

SQLALCHEMY_DATABASE_URL = "postgresql://postgres:12345678@localhost:5432/rentaroo-db"

# echo=True means it prints the SQL Queries in the terminal
engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True, connect_args={"options": "-c timezone=utc"})

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

########################################################################
### Adding Dummy data and committing after inserting into each table ###
########################################################################
####################
### Adding Users ###
####################
dummy = SessionLocal()
dummy.add(models.Users(email="pam@gmail.com", password="pamb", first_name="Pam", last_name="Beesly", phone_no="03348652936", image_path="/static/images/ae9f7e4b1.jpg",
          about_me="I love to keep my home nice and tidy, so you never have to worry when staying at my house."))
dummy.add(models.Users(email="jim@gmail.com", password="jim123", first_name="Jim", last_name="Halpert", image_path="/static/images/29eb25b52.webp",
          phone_no="03348652936", about_me="Me and my wife Pam love having people stay at our house and explore our city, I strive to make your stay comfortable and hope you have a good time.",avg_guest_rating=3,total_guest_rating=1))
dummy.add(models.Users(email="abc@gmail.com", password="abc", first_name="Michael", last_name="Scott", phone_no="03231932775", image_path="/static/images/e4f035533.png",
          about_me="I am new to all this tech stuff and keep forgetting my password."))
dummy.add(models.Users(email="abdullah@gmail.com", password="abd", first_name="Abdullah", last_name="Riaz", phone_no="03132334645", image_path="/static/images/fb0cfdbb4.webp",
          about_me="I am a photographer who mostly lives abroad and keep all my houses maintained to a high standard.",avg_host_rating=4,avg_guest_rating=5,total_host_rating=5,total_guest_rating=1))
dummy.add(models.Users(email="hina@gmail.com", password="hin", first_name="Hina", last_name="Qureshi", phone_no="03168333542", image_path="/static/images/226d7de75.jpg",
          about_me="An ecopreneur, marketing professional, and a travel junkie, I love reading and sleeping when I am not going places. I love traveling on Rent-A-Roo",avg_guest_rating=5,total_guest_rating=1))
dummy.add(models.Users(email="ali@gmail.com", password="aliak", first_name="Ali", last_name="Akbar", phone_no="03257448423", image_path="/static/images/146926d96.webp",
          about_me="I am Ali, a Software Professional, deeply interested in Art, Literature, and Culture. I have been travelling for the last 10 years and been using Rent-A-Roo and it continues to be a great experience. I have visited over 45 countries",avg_guest_rating=4,total_guest_rating=1))
dummy.add(models.Users(email="adeel@gmail.com", password="ade", first_name="Adeel", last_name="Ansari", phone_no="03334467893", image_path="/static/images/07ce1fb57.webp",
          about_me="Entrepreneur, Designer and a loving father, I am a British/Pakistani living in Karachi since 2008 I have been hosting since 2017 with my wife and absolutely love it. Looking forward to hosting you next.",avg_host_rating=5,total_host_rating=1,avg_guest_rating=5,total_guest_rating=1))
dummy.commit()
dummy.close()

#######################
### Adding Listings ###
#######################
dummy = SessionLocal()
dummy.add(models.Listings(host_id=2,
        title="Beach house with a great view", description="You can view the beautiful sea from the terrace of the house, all rooms have brown marble flooring with wide windows that open up directly to the sea", 
        state="Sindh", city="Karachi", address="Plot D-28, 38th St, Phase 6 DHA",is_apartment=False, gps_location="tkrsvz3w66r7",
        is_shared=False, accommodates=5, bathrooms=3, bedrooms=4, nightly_price=7500, min_nights=2, max_nights=15, wifi=True, kitchen=True, washing_machine=True, air_conditioning=True, tv=True, hair_dryer=False, iron=False, pool=False, gym=False, smoking_allowed=False
))
dummy.add(models.Listings(host_id=1, 
        title="Luxurious apartment in the middle of the city", description="The apartment has a single master bedroom but it is big enough to fit around 4 people, but it only has a single bed", 
        state="Punjab", city="Lahore", address="Apartment 22E, Sector B Apartments, Askari 11",is_apartment=True, apartment_no="22E", gps_location="ttsfvxrdr8tp",
        is_shared=False, accommodates=4, bathrooms=1, bedrooms=1, nightly_price=2400, min_nights=5, max_nights=10, wifi=True, kitchen=True, washing_machine=False, air_conditioning=False, tv=False, hair_dryer=False, iron=False, pool=False, gym=False, smoking_allowed=True
))
dummy.add(models.Listings(host_id=4, 
        title="Regal Urban Minimalism",description="Gaze out across the city from high up in this 16th-floor retreat. The expansive residence features an open-plan layout, floor-to-ceiling windows, soothing greys, chic furnishings and decor, and breathtaking panoramic vistas.",
        state="Punjab",city="Islamabad",address="Apt 5A, legion towers, Sector G6, Islamabad",is_apartment=True, apartment_no="16K", gps_location="ttgzz19n1qfd",
        is_shared=False,accommodates=3,bathrooms=1,bedrooms=1,nightly_price=25000,min_nights=3,max_nights=7,wifi=True, kitchen=True, washing_machine=True, air_conditioning=True, tv=True, hair_dryer=True, iron=True, pool=False, gym=False, smoking_allowed=False,view_count=1000, total_ratings=3, rating=3
))
dummy.add(models.Listings(host_id=4, 
        title="Unique woody feel and panoramic views of the mountains",description="The spacious terrace has a sitting arrangement for 4 and has the most gorgeous views you can soak in from all of the region. We can arrange for a bonfire or barbecue in the terrace as well.",
        state="Punjab",city="Murree",address="G-14, Kuldana Road, Murree, Punjab",is_apartment=False, gps_location="twh0yjwxpb18",
        is_shared=False,accommodates=6,bathrooms=2,bedrooms=2,nightly_price=15000,min_nights=2,max_nights=5,wifi=True, kitchen=True, washing_machine=False, air_conditioning=True, tv=False, hair_dryer=False, iron=False, pool=False, gym=False, smoking_allowed=True,view_count=790, total_ratings=2, rating=3
))
dummy.add(models.Listings(host_id=7, 
        title="Modern living in the heart of Karachi",description="A modern 2 Bedroom Apartment on the 9th floor with amazing view in the heart of Karachi. It comes with all amenities, central air conditioning, 24/7 generator/power backup, security, lift with free underground parking. The apartments have a gym and a pool too", 
        state="Sindh",city="Karachi",address="Apartment H174, Phase 3, Navy Housing Scheme Karsaz, Karachi",is_apartment=True,apartment_no="H174",
        is_shared=False,accommodates=4,bathrooms=2,bedrooms=2,nightly_price=12000,min_nights=6,max_nights=12,wifi=True, kitchen=True, washing_machine=True, air_conditioning=True, tv=True, hair_dryer=True, iron=True, pool=True, gym=True, smoking_allowed=True,view_count=110, total_ratings=1, rating=5
))
dummy.add(models.Listings(host_id=7, 
        title="Magnificent apartments near the beautiful Arabian Sea",description="Inside layout combines modern living confluenced to our cultural ethos. A magnificent clubhouse offering a swimming pool, card room, snooker room, gym, community hall and other indoor games.", 
        state="Sindh",city="Karachi",address="Apartment P12, Creek Vista Apartments, Karachi",is_apartment=True,apartment_no="P12", 
        is_shared=False,accommodates=4,bathrooms=2,bedrooms=2,nightly_price=17000,min_nights=2,max_nights=10,wifi=True, kitchen=True, washing_machine=False, air_conditioning=True, tv=True, hair_dryer=False, iron=False, pool=True, gym=True, smoking_allowed=True,view_count=80
))
dummy.add(models.Listings(host_id=4, 
        title="Magnificent Villas ",description="Sea, sand, and sun merge in prism-like perfection at this modern villa", 
        state="Sindh",city="Karachi",address="Apartment P12, Creek Vista Apartments, Karachi",is_apartment=False, 
        is_shared=False,accommodates=4,bathrooms=2,bedrooms=2,nightly_price=17000,min_nights=2,max_nights=10,wifi=True, kitchen=True, washing_machine=False, air_conditioning=True, tv=True, hair_dryer=False, iron=False, pool=True, gym=True, smoking_allowed=True,view_count=80
))
dummy.add(models.Listings(host_id=4, 
        title="Magnificent Apartment ",description="Sea, sand, and sun merge in prism-like perfection at this modern apartment", 
        state="Sindh",city="Karachi",address="Apartment P12, Creek Vista Apartments, Karachi",is_apartment=True,apartment_no="C62",
        is_shared=False,accommodates=4,bathrooms=2,bedrooms=2,nightly_price=17000,min_nights=2,max_nights=10,wifi=True, kitchen=True, washing_machine=False, air_conditioning=True, tv=True, hair_dryer=False, iron=False, pool=True, gym=True, smoking_allowed=True,view_count=80
))
dummy.add(models.Listings(host_id=4, 
        title="Not Magnificent But Great Apartment ",description="Sea, sand, and sun merge in prism-like not perfect at this old apartment", 
        state="Sindh",city="Lahore",address="Apartment P12, Creek Vista Apartments, Karachi",is_apartment=True,apartment_no="C26",
        is_shared=False,accommodates=4,bathrooms=2,bedrooms=2,nightly_price=17000,min_nights=2,max_nights=10,wifi=True, kitchen=True, washing_machine=False, air_conditioning=True, tv=True, hair_dryer=False, iron=False, pool=True, gym=True, smoking_allowed=True,view_count=80
))
dummy.commit()
dummy.close()

#############################
### Adding Listing Images ###
#############################
dummy = SessionLocal()
dummy.add(models.Listing_images(listing_id=1, image_path="/static/images/4388ffc71.webp"))
dummy.add(models.Listing_images(listing_id=1, image_path="/static/images/567827721.webp"))
dummy.add(models.Listing_images(listing_id=1, image_path="/static/images/93adb9c61.webp"))
dummy.add(models.Listing_images(listing_id=2, image_path="/static/images/bc407f779221.jpg"))
dummy.add(models.Listing_images(listing_id=2, image_path="/static/images/bc407f779222.webp"))
dummy.add(models.Listing_images(listing_id=2, image_path="/static/images/bc407f779223.webp"))
dummy.add(models.Listing_images(listing_id=3, image_path="/static/images/8a1891893.webp"))
dummy.add(models.Listing_images(listing_id=3, image_path="/static/images/fe8094223.webp"))
dummy.add(models.Listing_images(listing_id=3, image_path="/static/images/b246b24c3.webp"))
dummy.add(models.Listing_images(listing_id=3, image_path="/static/images/399eaa423.webp"))
dummy.add(models.Listing_images(listing_id=4, image_path="/static/images/80faf7244.webp"))
dummy.add(models.Listing_images(listing_id=4, image_path="/static/images/d6c8faad4.webp"))
dummy.add(models.Listing_images(listing_id=4, image_path="/static/images/bd5eee234.webp"))
dummy.add(models.Listing_images(listing_id=4, image_path="/static/images/e15703164.webp"))
dummy.add(models.Listing_images(listing_id=5, image_path="/static/images/54fea97a5.webp"))
dummy.add(models.Listing_images(listing_id=5, image_path="/static/images/64c5fe885.webp"))
dummy.add(models.Listing_images(listing_id=5, image_path="/static/images/81dc754f5.webp"))
dummy.add(models.Listing_images(listing_id=5, image_path="/static/images/ac5735895.webp"))
dummy.add(models.Listing_images(listing_id=6, image_path="/static/images/3aec06b56.jpg"))
dummy.add(models.Listing_images(listing_id=6, image_path="/static/images/4416a2566.webp"))
dummy.add(models.Listing_images(listing_id=6, image_path="/static/images/704186ce6.jpg"))
dummy.add(models.Listing_images(listing_id=6, image_path="/static/images/e19050156.jpeg"))
dummy.add(models.Listing_images(listing_id=7, image_path="/static/images/6c6151f17.jpeg"))
dummy.add(models.Listing_images(listing_id=7, image_path="/static/images/6fe550c87.jpeg"))
dummy.add(models.Listing_images(listing_id=8, image_path="/static/images/8c8ca6ff8.jpeg"))
dummy.add(models.Listing_images(listing_id=8, image_path="/static/images/4cdeb41a8.jpeg"))
dummy.add(models.Listing_images(listing_id=9, image_path="/static/images/0b4e21a09.jpeg"))
dummy.add(models.Listing_images(listing_id=9, image_path="/static/images/727dae5a9.jpeg"))


dummy.commit()
dummy.close()

###############################################
### Adding Promoted Listings and Favourites ###
###############################################
from datetime import datetime, timedelta, timezone
start = datetime.now(tz=timezone.utc)
start2daysbefore = start-timedelta(days=2)+timedelta(minutes=5) #2 days before today and 5 minutes after the time from now 
dummy = SessionLocal()
dummy.add(models.Promoted_listings(listing_id=2, start_time=start ,end_time=start + timedelta(days=2)))
dummy.add(models.Promoted_listings(listing_id=7, start_time=start ,end_time=start + timedelta(days=2)))
dummy.add(models.Promoted_listings(listing_id=8, start_time=start ,end_time=start + timedelta(days=2)))
# (promotion expires 5min after program starts)
dummy.add(models.Promoted_listings(listing_id=3, start_time=start2daysbefore ,end_time=start2daysbefore + timedelta(days=2)))
dummy.add(models.Promoted_listings(listing_id=4, start_time=start2daysbefore ,end_time=start2daysbefore + timedelta(days=2)))
dummy.add(models.Favourites(guest_id=5,listing_id=4))
dummy.add(models.Favourites(guest_id=5,listing_id=2))
dummy.add(models.Favourites(guest_id=5,listing_id=3))
dummy.add(models.Favourites(guest_id=4,listing_id=5))
dummy.add(models.Favourites(guest_id=4,listing_id=6))
dummy.commit()
dummy.close()

###########################
### Adding Reservations ###
###########################
# 9AM UTC is 2PM PKT the same day, and all checkins and checkouts are at 2PM PKT
dummy = SessionLocal()
#This reservation is about to expire in 8 minutes
dummy.add(models.Reservations(listing_id=4,guest_id=5,
        checkin_date=datetime(2022, 11, 20, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 1, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_due=82500,
        created_time=start-timedelta(hours=23, minutes=52)))
dummy.add(models.Reservations(listing_id=3,guest_id=5,
        checkin_date=datetime(2022, 12, 6, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 13, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_due=52500))
dummy.add(models.Reservations(listing_id=7,guest_id=5,
        checkin_date=datetime(2022, 12, 6, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 13, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_due=52500))
dummy.add(models.Reservations(listing_id=8,guest_id=3,
        checkin_date=datetime(2022, 12, 6, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 13, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_due=52500))
dummy.add(models.Reservations(listing_id=9,guest_id=6,
        checkin_date=datetime(2022, 12, 6, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 13, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_due=52500))
dummy.commit()
dummy.close()

###########################
### Adding Transactions ###
###########################
dummy = SessionLocal()
# hina stayed for 3 nights at this place and checkout will be in 3min 
dummy.add(models.Transactions(listing_id=4,guest_id=5,
        checkin_date=start-timedelta(days=3)+timedelta(minutes=3),
        checkout_date=start+timedelta(minutes=3),
        amount_paid=82500))
dummy.add(models.Transactions(listing_id=3,guest_id=5,
        checkin_date=datetime(2022, 12, 14, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 12, 21, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=52500))
dummy.add(models.Transactions(listing_id=5,guest_id=4,
        checkin_date=datetime(2022, 11, 8, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 11, 19, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=82500,has_guest_rated=True, has_host_rated=True))
dummy.add(models.Transactions(listing_id=4,guest_id=7,
        checkin_date=datetime(2022, 9, 14, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 9, 17, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=45000,has_guest_rated=True, has_host_rated=True))
dummy.add(models.Transactions(listing_id=4,guest_id=6,
        checkin_date=datetime(2022, 4, 10, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 4, 14, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=60000,has_guest_rated=True, has_host_rated=True))
dummy.add(models.Transactions(listing_id=3,guest_id=2,
        checkin_date=datetime(2022, 10, 11, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 10, 14, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=75000,has_guest_rated=True, has_host_rated=True))
dummy.add(models.Transactions(listing_id=3,guest_id=5,
        checkin_date=datetime(2022, 9, 3, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 9, 7, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=100000,has_guest_rated=True, has_host_rated=True))
dummy.add(models.Transactions(listing_id=3,
        checkin_date=datetime(2022, 9, 10, 9, 00, 00, 000000,tzinfo=timezone.utc),
        checkout_date=datetime(2022, 9, 13, 9, 00, 00, 000000,tzinfo=timezone.utc),
        amount_paid=75000,has_guest_rated=True, has_host_rated=True))
dummy.commit()
dummy.close()

##################
### Adding Q&A ###
##################
dummy = SessionLocal()
dummy.add(models.Questions_and_answers(listing_id=3,guest_id=5,question="Are there any good malls nearby?",answer="Yes, legion mall is a 5 min walk away and has all the international brands you could think of."))
dummy.add(models.Questions_and_answers(listing_id=3,guest_id=5,question="Do these apartments offer free parking?"))
#Question from a deleted user so it will make guest_id null
dummy.add(models.Questions_and_answers(listing_id=3,question="Can you lower the price a bit? This is too expensive!!!"))
dummy.add(models.Questions_and_answers(listing_id=3,question="Are pets allowed?", answer="Ofcourse, I look forward to meeting them too when you check in :)"))
dummy.add(models.Questions_and_answers(listing_id=4,guest_id=1,question="How cold does it get there during december?"))
dummy.add(models.Questions_and_answers(listing_id=4,guest_id=7,question="Is there public transport available in this area?",answer="Yes there is a public bus that has a stop right outside the street from here"))
dummy.commit()
dummy.close()

##################
### Adding R&R ###
##################
#There is a rating for each complete stay(transaction that reached checkout)
dummy = SessionLocal()
dummy.add(models.Ratings_and_reviews(listing_id=5,guest_id=4,rating=5,review="This was a beautiful place to stay at and I will 100 percent be visiting again!"))
dummy.add(models.Ratings_and_reviews(listing_id=4,guest_id=7,rating=4))
dummy.add(models.Ratings_and_reviews(listing_id=4,guest_id=6,rating=2,review="This was too expensive and not worth it"))
dummy.add(models.Ratings_and_reviews(listing_id=3,guest_id=2,rating=5,review="The view was amazing and the host was very helpful with any problems I had"))
dummy.add(models.Ratings_and_reviews(listing_id=3,guest_id=5,rating=5,review="Wonderful experience, I could never buy this place but thanks to rent-a-roo I can atleast rent it lol"))
dummy.add(models.Ratings_and_reviews(listing_id=3,rating=1,review="I had the worst experience, the place was fine but the neigbourhood is so dangerous I got robbed at gunpoint coming home at night"))
dummy.commit()
dummy.close()
