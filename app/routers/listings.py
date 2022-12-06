import os
import secrets
from fastapi import File, UploadFile
from fastapi import APIRouter, Depends, status, HTTPException
from routers import Authentication
from database import models, connection
from schemas import listingSchemas
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from datetime import datetime,timedelta,timezone
from typing import List

router = APIRouter(prefix="/listing", tags=["Listing"])

def expire_promotions(db: Session = Depends(connection.get_db)):
    db.execute("DELETE FROM promoted_listings WHERE now()>=end_time;")
    db.commit()

@router.post("/create",status_code=status.HTTP_201_CREATED)
def create_listing(request:listingSchemas.CreateListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    if ((request.is_apartment==True) and (request.apartment_no is None)) or ((request.is_apartment==False) and (request.apartment_no is not None)):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="If is_apartment==True then apartment no. can't be null, but if is_apartment==False then apartment no. must be null")
    insertlisting = models.Listings(
        host_id = current_user_id,
        title = request.title,
        description = request.description,
        state = request.state,
        city = request.city,
        address = request.address,
        is_apartment = request.is_apartment,
        apartment_no = request.apartment_no,
        gps_location = request.gps_location,
        is_shared = request.is_shared,
        accommodates = request.accommodates,
        bathrooms = request.bathrooms,
        bedrooms = request.bedrooms,
        nightly_price = request.nightly_price,
        min_nights = request.min_nights,
        max_nights = request.max_nights,
        wifi = request.wifi,
        kitchen = request.kitchen,
        washing_machine = request.washing_machine,
        air_conditioning = request.air_conditioning,
        tv = request.tv,
        hair_dryer = request.hair_dryer,
        iron = request.iron,
        pool = request.pool,
        gym = request.gym,
        smoking_allowed = request.smoking_allowed
    )
    db.add(insertlisting)
    db.commit()
    db.refresh(insertlisting)
    return {"Status":"Success","listing_id":insertlisting.listing_id}

# Allow user to upload listing images, needs to be an async function. This (...) means required
@router.post("/image/{listingid}", status_code=status.HTTP_201_CREATED)
async def set_listing_image(listingid:int, file: UploadFile = File(...), db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #Check if user owns the property
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == listingid, models.Listings.is_listed == True, models.Listings.host_id == current_user_id)
    if not listing_query.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"User with id {current_user_id} doesn't own a listing with id {listingid}")
    # gets the extension of the uploaded file
    extension = "." + file.filename.split(".")[-1]
    # if extension is invalid then return error
    if (extension not in [".png", ".jpg", ".jpeg", ".webp"]):
        return {"error": "File extension not allowed"}
    # give the image file a new name along with the path where it will be stored
    Storedfilename = "/static/images/" + secrets.token_hex(4) + str(listingid) + extension
    file_content = await file.read()
    # stores it in server files by writing it into a new file
    with open("."+Storedfilename, "wb") as inputfile:
        inputfile.write(file_content)
    file.close()
    # Store new file path in DB
    insert_image=models.Listing_images(
        listing_id = listingid,
        image_path = Storedfilename
    )
    db.add(insert_image)
    db.commit()
    return {"Success": "Image was uploaded and stored"}

@router.put("/image/delete", status_code=status.HTTP_200_OK)
def delete_listing_image(request: listingSchemas.DeleteImage, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #Check if user owns the property
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == request.listingid, models.Listings.is_listed == True, models.Listings.host_id == current_user_id)
    if not listing_query.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"User with id {current_user_id} doesn't own a listing with id {request.listingid}")
    deleted_image = db.query(models.Listing_images).filter(models.Listing_images.listing_id == request.listingid,models.Listing_images.image_path == request.imagepath)
    if not deleted_image.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"listing with id {request.listingid} doesn't have an image with path {request.imagepath}")   
    # remove the image file from server if it exists
    if os.path.isfile("."+request.imagepath):
        os.remove("."+request.imagepath)
    # remove its entry from DB too
    deleted_image.delete(synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "Listing Image Deleted"}

@router.get("/my-favourites", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def get_favourites(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    favourites = db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(
        models.Favourites.listing_id == models.Listings.listing_id, models.Favourites.guest_id == models.Users.user_id, models.Listings.listing_id == models.Listing_images.listing_id, models.Listings.is_listed == True, models.Favourites.guest_id == current_user_id).group_by(
            models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price).all()
    return favourites

@router.get("/my-listings", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def get_my_listings(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    listings = db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(
        models.Listings.listing_id == models.Listing_images.listing_id, models.Listings.is_listed == True, models.Listings.host_id == current_user_id).group_by(
            models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price).all()
    return listings

@router.get("/popular-listings", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def get_popular_listings(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    listings = db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(
        models.Listings.listing_id == models.Listing_images.listing_id, models.Listings.is_listed == True, models.Listings.view_count>0).group_by(
            models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price).order_by(models.Listings.view_count.desc()).limit(3).all()
    return listings

#We allow get_listing to reach an unlisted listing for transactions history
@router.get("/{listingid}", status_code=status.HTTP_200_OK, response_model=listingSchemas.GetListing)
def get_listing(listingid:int, db:Session=Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    listing = db.query(*models.Listings.__table__.columns, (models.Listings.host_id==current_user_id).label("is_host"), func.array_agg(models.Listing_images.image_path).label("image_path"), models.Users.first_name, models.Users.last_name, models.Users.image_path.label("host_image_path")).\
        filter(models.Listings.listing_id == listingid).join(models.Listing_images, models.Listing_images.listing_id == models.Listings.listing_id).join(models.Users, models.Listings.host_id == models.Users.user_id).\
            group_by(*models.Listings.__table__.columns,models.Users.first_name,models.Users.last_name,"host_image_path").first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"listing with id {listingid} does not exist")
    
    #If the listing is listed and the user viewing it isnt the host then we increment viewcount 
    if listing.is_host==False and listing.is_listed==True:
        db.query(models.Listings).filter(models.Listings.listing_id==listingid).update({models.Listings.view_count : models.Listings.view_count + 1}, synchronize_session=False)
        db.commit()
    return listing

@router.put("/{listingid}", status_code=status.HTTP_200_OK)
def update_listing(listingid: int, request: listingSchemas.CreateListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == listingid, models.Listings.host_id == current_user_id, models.Listings.is_listed == True)
    if not listing_query.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"User with id {current_user_id} doesn't own a listing with id {listingid}")
    # dict turns the request into a dictionary
    listing_query.update(request.dict(), synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "Listing Updated"}

#DEPENDS on expire_promotions since we need to access promoted_listings here
@router.delete("/{listingid}", dependencies=[Depends(expire_promotions)], status_code=status.HTTP_200_OK)
def delete_lisiting(listingid:int, db:Session=Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #This creates a query but doesnt run it
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == listingid, models.Listings.host_id == current_user_id, models.Listings.is_listed == True)
    #This actually runs the query and gets only the first row or none if it doesnt exist
    current_listing = listing_query.first()
    if not current_listing:
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"User with id {current_user_id} doesn't own a listing with id {listingid}")
    #This appends the update to the existing filter query and actually runs it
    listing_query.update({"is_listed": False},synchronize_session=False)
    promo_query = db.query(models.Promoted_listings).filter(models.Promoted_listings.listing_id == models.Listings.listing_id, models.Listings.is_listed == False)
    promo_query.delete(synchronize_session=False)
    db.commit()
    return {"Status":"Success","Detail":"Listing Deleted(Unlisted)"}

#DEPENDS on expire_promotions since we need to access promoted_listings here
@router.post("/search/{isPromoted}", dependencies=[Depends(expire_promotions)],status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def search_listings(isPromoted:bool ,request: listingSchemas.SearchListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    filters=[]
    for key, value in request:
        if (value is None) or (key in ("order_by","is_ascending")):
            continue
        elif key.startswith("max_"):
            key=key[4:]
            filters.append(getattr(models.Listings, key) <= value)
        elif key.startswith("min_"):
            key=key[4:]
            filters.append(getattr(models.Listings, key) >= value)
        elif key=="nights":
            filters.append(getattr(models.Listings, "min_nights") <= value)
            filters.append(getattr(models.Listings, "max_nights") >= value)
        else:
            filters.append(getattr(models.Listings, key) == value)
    # Create the query by using the filters and joins
    filters.append(models.Listings.is_listed == True)
    if isPromoted:
        query=db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(*filters).join(models.Listing_images, models.Listing_images.listing_id == models.Listings.listing_id).join(models.Promoted_listings, models.Promoted_listings.listing_id == models.Listings.listing_id).group_by(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price)
    else:
        #We create a subquery and use it in the where clause
        filters.append(models.Listings.listing_id.not_in(db.query(models.Promoted_listings.listing_id)))
        query=db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(*filters).join(models.Listing_images, models.Listing_images.listing_id == models.Listings.listing_id).group_by(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price)
    # ORDERING THE RESULTS IS ALSO OPTIONAL AND MUST BE DONE IN THE END
    if (request.order_by is not None) and (request.is_ascending is not None):
        if request.order_by not in ("city","state","rating","nightly_price"):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail=f"{request.order_by} is not a valid value for order_by. Valid Values are city, state, rating, nightly_price")
        if request.is_ascending:
            query = query.order_by(getattr(models.Listings, request.order_by).asc())
        else:
            query = query.order_by(getattr(models.Listings, request.order_by).desc())
    # We already checked for both being "not none", now if one of these is "not none" then it means the other one must be "none" which is wrong 
    elif (request.order_by is not None) or (request.is_ascending is not None):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="Only one of these (order_by, is_ascending) can't be null. To Sort, make them both not null. To Not Sort, make them both null.")
    results=query.all()
    return results


#DEPENDS on expire_promotions since we need to access promoted_listings here 
@router.post("/promote", dependencies=[Depends(expire_promotions)], status_code=status.HTTP_201_CREATED)
def promote_listing(request: listingSchemas.PromoteListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #Check if user owns the property it wants to promote
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == request.listing_id, models.Listings.is_listed == True, models.Listings.host_id == current_user_id)
    if not listing_query.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"User with id {current_user_id} doesn't own a listing with id {request.listing_id}")
    #Check that the days to promote are more than 0
    if request.days<=0:
        raise HTTPException(status_code= status.HTTP_400_BAD_REQUEST, detail=f"No. of days to promote must be atleast 1")
    #Time calculations    
    start = datetime.now(tz=timezone.utc)
    end = start + timedelta(days=request.days)
    # Dont insert if already promoted
    isPromoted = db.query(models.Promoted_listings).filter(models.Promoted_listings.listing_id == request.listing_id).first()
    if isPromoted:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="This listing is already promoted")
    else:
        insertpromo = models.Promoted_listings(
            listing_id = request.listing_id,
            start_time = start,
            end_time = end
        )
        db.add(insertpromo)
        db.commit()
        return {"status": "Success", "Detail": "Listing Promoted"}

@router.post("/favourite/{listingid}", status_code=status.HTTP_201_CREATED)
def favourite_listing(listingid: int, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #Check if listing exists or not
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == listingid, models.Listings.is_listed == True)
    if not listing_query.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"listing with id {listingid} doesn't exist")
    # Check if user is trying to favourite their own listing
    if listing_query.first().host_id == current_user_id:
        raise HTTPException(status_code= status.HTTP_400_BAD_REQUEST, detail=f"Current user is the host so they can't favourite their own listing")
    # Dont insert if already favourited
    isFavourited = db.query(models.Favourites).filter(models.Favourites.listing_id == listingid, models.Favourites.guest_id == current_user_id).first()
    if isFavourited:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="This listing is already favourited")
    insertfav = models.Favourites(
        guest_id = current_user_id,
        listing_id = listingid
    )
    db.add(insertfav)
    db.commit()
    return {"status": "Success", "Detail": "Listing Favourited"}

@router.delete("/unfavourite/{listingid}", status_code=status.HTTP_200_OK)
def unfavourite_listing(listingid: int, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #Check if listing exists or not
    listing_query = db.query(models.Listings).filter(models.Listings.listing_id == listingid, models.Listings.is_listed == True)
    if not listing_query.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"listing with id {listingid} doesn't exist")
    # Check if listing is even favourited or not
    isFavourited = db.query(models.Favourites).filter(models.Favourites.listing_id == listingid, models.Favourites.guest_id == current_user_id)
    if not isFavourited.first():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="This listing isn't favourited")
    isFavourited.delete(synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "Listing Unfavourited"}