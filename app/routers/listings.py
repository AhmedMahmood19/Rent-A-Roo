from fastapi import APIRouter, Depends, status, HTTPException
from routers import Authentication
from database import models, connection
from schemas import listingSchemas
from sqlalchemy.orm import Session
from typing import List

router = APIRouter(prefix="/listing", tags=['Listing'])


# @router.post("/search", status_code=status.HTTP_200_OK)
# def search_listings(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     from sqlalchemy import text
#     results = db.execute(text("select * from listings")).fetchall()
#     return results

# @router.post("/search", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
# def search_listings(request: listingSchemas.SearchListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     filters=[]
#     for key, value in request:
#         if (value is None) or (key in ("order_by","is_ascending")):
#             continue
#         elif key.startswith("max_"):
#             key=key[4:]
#             filters.append(getattr(models.Listings, key) <= value)
#         elif key.startswith("min_"):
#             key=key[4:]
#             filters.append(getattr(models.Listings, key) >= value)
#         elif key=="nights":
#             filters.append(getattr(models.Listings, "min_nights") <= value)
#             filters.append(getattr(models.Listings, "max_nights") >= value)
#         else:
#             filters.append(getattr(models.Listings, key) == value)
#                         # ##################################################################################
#                         # TODO : EDIT THE QUERY TO RETURN THE PATH TO ONLY THE FIRST IMAGE FOR EACH LISTING and ALSO APPEND LOCALHOST:8000 to path 
#                         # ##################################################################################
#     # Create the query by using the filters and joins
#     query=db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, models.Listing_images.image_path).filter(*filters).join(models.Listing_images, models.Listing_images.listing_id == models.Listings.listing_id)
#     # ORDERING THE RESULTS IS ALSO OPTIONAL AND MUST BE DONE IN THE END
#     if (request.ORDER_BY is not None) and (request.IS_ASCENDING is not None):
#         if request.ORDER_BY not in ("city","state","rating","nightly_price"):
#             raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail=f"{request.ORDER_BY} is not a valid value for ORDER_BY. Valid Values are city, state, rating, nightly_price")
#         if request.IS_ASCENDING:
#             query = query.order_by(getattr(models.Listings, request.ORDER_BY).asc())
#         else:
#             query = query.order_by(getattr(models.Listings, request.ORDER_BY).desc())
#     # We already checked for both being "not none", now if one of these is "not none" then it means the other one must be "none" which is wrong 
#     elif (request.ORDER_BY is not None) or (request.IS_ASCENDING is not None):
#         raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="Only one of these (order_by, is_ascending) can't be null. To Sort, make them both not null. To Not Sort, make them both null.")
#     results=query.all()
#     return results

@router.post('/addlisting',status_code=status.HTTP_200_OK)
def addlisitng(request:listingSchemas.Listing, db: Session =Depends(connection.get_db),current_user_id: int = Depends(Authentication.get_current_user_id)):
    insertlisting = models.Listings(
        title = request.title,
        host_id = current_user_id,
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
        air_conditioning = request.air_conditioning,
        washing_machine = request.washing_machine,
        hair_dryer = request.hair_dryer,
        kitchen = request.kitchen,
        tv = request.tv,
        iron = request.iron,
        pool = request.pool,
        gym = request.gym,
        smoking_allowed = request.smoking_allowed
    )
    db.add(insertlisting)
    db.commit()
    return insertlisting

@router.get('/getlisting', status_code=200)
def show(db:Session=Depends(connection.get_db),current_user_id: int = Depends(Authentication.get_current_user_id)):
    listing = db.query(models.Listings).filter(models.Listings.host_id == current_user_id).all()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"listing with this hostid {current_user_id} is not available")
    return listing

@router.get('/getlisting/{id}', status_code=200)
def show(id:int,db:Session=Depends(connection.get_db),current_user_id: int = Depends(Authentication.get_current_user_id)):
    listing = db.query(models.Listings).filter(models.Listings.listing_id == id).first()
    if not listing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"listing with this id {id} is not available")
    return listing

@router.put('/listing/{id}',status_code=status.HTTP_202_ACCEPTED)
def updatelisiting(id:int,request:listingSchemas.Showlisiting,db:Session=Depends(connection.get_db),current_user_id: int = Depends(Authentication.get_current_user_id)):
    listing =db.query(models.Listings).filter(models.Listings.listing_id == id, models.Listings.host_id == current_user_id)
    if not listing.first():
        raise HTTPException(status_code = status.HTTP_404_NOT_FOUND, detail= f'listing with id {id} not found')
    listing.update(request.dict(),synchronize_session=False) 
    db.commit()
    return {"status":"Complete","Detail":"Listing Updated"}

@router.delete('/listing/{id}',status_code=status.HTTP_204_NO_CONTENT)
def deletelisiting(id:int,request:listingSchemas.removelisiting, db:Session=Depends(connection.get_db),current_user_id: int = Depends(Authentication.get_current_user_id)):
    listing = db.query(models.Listings).filter(models.Listings.listing_id == id, models.Listings.host_id == current_user_id)
    if not listing.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"Listing with id {id} not found")
    request.is_listed = False;
    listing.update(request.dict(),synchronize_session=False)
    db.commit()
    return {"status":"Complete","Detail":"listing Deleted"}
    
