from fastapi import APIRouter, Depends, status, HTTPException
from routers import Authentication
from database import models, connection
from schemas import listingSchemas
from sqlalchemy.orm import Session
from typing import List

router = APIRouter(prefix="/listing", tags=['Listing'])


@router.post("/search", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def search_listings(request: listingSchemas.SearchListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    filters=[]
    for key, value in request:
        if (value is None) or (key in ("ORDER_BY","IS_ASCENDING")):
            continue
        elif key.startswith("MAX_"):
            key=key[4:]
            filters.append(getattr(models.LISTINGS, key) <= value)
        elif key.startswith("MIN_"):
            key=key[4:]
            filters.append(getattr(models.LISTINGS, key) >= value)
        elif key=="NIGHTS":
            filters.append(getattr(models.LISTINGS, "MIN_NIGHTS") <= value)
            filters.append(getattr(models.LISTINGS, "MAX_NIGHTS") >= value)
        else:
            filters.append(getattr(models.LISTINGS, key) == value)
                        # ##################################################################################
                        # TODO : EDIT THE QUERY TO RETURN THE PATH TO ONLY THE FIRST IMAGE FOR EACH LISTING and ALSO APPEND LOCALHOST:8000 to path 
                        # ##################################################################################
    # Create the query by using the filters and joins
    query=db.query(models.LISTINGS.LISTING_ID,models.LISTINGS.CITY,models.LISTINGS.STATE,models.LISTINGS.RATING,models.LISTINGS.NIGHTLY_PRICE, models.LISTING_IMAGES.IMAGE_PATH).filter(*filters).join(models.LISTING_IMAGES, models.LISTING_IMAGES.LISTING_ID == models.LISTINGS.LISTING_ID)
    # ORDERING THE RESULTS IS ALSO OPTIONAL AND MUST BE DONE IN THE END
    if (request.ORDER_BY is not None) and (request.IS_ASCENDING is not None):
        if request.ORDER_BY not in ("CITY","STATE","RATING","NIGHTLY_PRICE"):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail=f"{request.ORDER_BY} is not a valid value for ORDER_BY. Valid Values are CITY, STATE, RATING, NIGHTLY_PRICE")
        if request.IS_ASCENDING:
            query = query.order_by(getattr(models.LISTINGS, request.ORDER_BY).asc())
        else:
            query = query.order_by(getattr(models.LISTINGS, request.ORDER_BY).desc())
    # We already checked for both being "not none", now if one of these is "not none" then it means the other one must be "none" which is wrong 
    elif (request.ORDER_BY is not None) or (request.IS_ASCENDING is not None):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="Only one of these (ORDER_BY, IS_ASCENDING) can't be null. To Sort, make them both not null. To Not Sort, make them both null.")
    results=query.all()
    return results