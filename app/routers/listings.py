from fastapi import APIRouter, Depends, HTTPException, status
from routers import Authentication
from database import models, connection
from schemas import listingSchemas
from sqlalchemy.orm import Session

router = APIRouter(prefix="/listing", tags=['Listing'])

# @router.post("", status_code=status.HTTP_201_CREATED)
# def create_listing(request: schemas.UserReg, db: Session = Depends(connection.get_db)):
#     #We dont need to specify all the attributes when making a model, 
#     # but make sure that NOTNULL attributes have values or a default value when adding to a session
#     insertuser = models.USER(
#         EMAIL=request.EMAIL,
#         PASSWORD=request.PASSWORD,
#         FIRST_NAME=request.FIRST_NAME,
#         LAST_NAME=request.LAST_NAME,
#         PHONE_NO=request.PHONE_NO,
#         ABOUT_ME=request.ABOUT_ME
#     )
#     #Dont insert if email is already in use
#     user = db.query(models.USER).filter(models.USER.EMAIL == insertuser.EMAIL).first()
#     if user:
#         raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
#                             detail="This email is already in use")
#     else:
#         db.add(insertuser)
#         db.commit()
#         return {"status":"Success","Detail":"User Registered"}

# @router.get("", status_code=status.HTTP_200_OK,response_model=schemas.User)
# def read_listing(db:Session=Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     user=db.query(models.USER).filter(models.USER.USER_ID == current_user_id).first()
#     return user


# @router.put("",status_code=status.HTTP_200_OK)
# def update_listing(request:schemas.UserReg ,db:Session=Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id)
#     user.update(request.dict(),synchronize_session=False) #have to use dict function to update dictonary values of request
#     db.commit()
#     return {"status":"Success","Detail":"User Updated"}

# @router.delete("",status_code=status.HTTP_200_OK)
# def delete_listing(db:Session=Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
#     user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id)
#     user.delete(synchronize_session=False)
#     db.commit()
#     return {"status":"Success","Detail":"User Deleted"}