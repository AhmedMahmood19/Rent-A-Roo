from fastapi import APIRouter, Depends, status, HTTPException
from routers import Authentication
from database import models, connection
from schemas import listingSchemas
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from datetime import datetime,timedelta
from typing import List
from sqlalchemy import text

router = APIRouter(prefix="/listing", tags=['Listing'])


# @router.post("/search", status_code=status.HTTP_200_OK)
# def search_listings(request: listingSchemas.SearchListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     withpromo = db.execute("select L.listing_id,L.city,L.state,L.rating,L.nightly_price,array_agg(I.image_path) image_paths from listings L, listing_images I, promoted_listings P where L.listing_id=I.listing_id and L.listing_id=P.listing_id group by L.listing_id,L.city,L.state,L.rating,L.nightly_price").fetchall()
#     nopromo = db.execute("select L.listing_id,L.city,L.state,L.rating,L.nightly_price,array_agg (I.image_path) image_paths from listings L, listing_images I, promoted_listings P where L.listing_id=I.listing_id and L.listing_id!=P.listing_id group by L.listing_id,L.city,L.state,L.rating,L.nightly_price").fetchall()
#     results = withpromo+nopromo
#     print(results[0])
#     return results

@router.post("/search-promoted", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def search_promoted_listings(request: listingSchemas.SearchListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
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
    query=db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(*filters).join(models.Listing_images, models.Listing_images.listing_id == models.Listings.listing_id).join(models.Promoted_listings, models.Promoted_listings.listing_id == models.Listings.listing_id).group_by(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price)
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

@router.post("/search", status_code=status.HTTP_200_OK, response_model=List[listingSchemas.SearchResult])
def search_listings(request: listingSchemas.SearchListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
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
    query=db.query(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price, func.array_agg(models.Listing_images.image_path).label("image_path")).filter(*filters).join(models.Listing_images, models.Listing_images.listing_id == models.Listings.listing_id).join(models.Promoted_listings, models.Promoted_listings.listing_id != models.Listings.listing_id).group_by(models.Listings.listing_id,models.Listings.city,models.Listings.state,models.Listings.rating,models.Listings.nightly_price)
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


@router.post("/promote", status_code=status.HTTP_201_CREATED)
def promote_listing(request: listingSchemas.PromoteListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    start = datetime.utcnow()
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