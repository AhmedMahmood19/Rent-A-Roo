from fastapi import APIRouter, Depends, HTTPException, status
from routers import Authentication
from database import models, connection
from schemas import listingSchemas
from sqlalchemy.orm import Session

router = APIRouter(prefix="/listing", tags=['Listing'])

# #FOR TESTING
# @router.post("/create", status_code=status.HTTP_201_CREATED)
# def create_listing(request: listingSchemas.CreateListing, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     insertlisting = models.LISTINGS(
#         HOST_ID=current_user_id,
#         TITLE=request.TITLE
#     )
#     db.add(insertlisting)
#     db.commit()
#     return {"status":"Success","Detail":"Listing Added"}