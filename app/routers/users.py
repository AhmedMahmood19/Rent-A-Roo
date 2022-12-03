import secrets
import os
from datetime import datetime,timezone
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi import File, UploadFile
from fastapi.security import OAuth2PasswordRequestForm
from routers import Authentication
from database import models, connection
from schemas import userSchemas
from sqlalchemy.orm import Session
from sqlalchemy import or_
from reservations import checkout_transactions

router = APIRouter(prefix="/user", tags=['User'])

@router.post("/register", status_code=status.HTTP_201_CREATED)
def create_user(request: userSchemas.UserReg, db: Session = Depends(connection.get_db)):
    # We dont need to specify all the attributes when making a model,
    # but make sure that NOTNULL attributes have values or a default value when adding to a session
    insertuser = models.Users(
        email=request.email,
        password=request.password,
        first_name=request.first_name,
        last_name=request.last_name,
        phone_no=request.phone_no,
        about_me=request.about_me
    )
    # Dont insert if email is already in use
    user = db.query(models.Users).filter(models.Users.email == insertuser.email).first()
    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="This email is already in use")
    else:
        db.add(insertuser)
        db.commit()
        return {"status": "Success", "Detail": "User Registered"}


@router.post("/login", status_code=status.HTTP_200_OK)
def login_user(formdata: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(connection.get_db)):
    # Run a SELECT query on table USERS, where email and password must match,must use "username" since its fixed by OAuth2 Form
    user = db.query(models.Users).filter(models.Users.email == formdata.username, models.Users.password == formdata.password).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Invalid Email or Password")
    else:
        # Generate a token, store it in a Token schema, then return it as the response
        generatedToken = Authentication.generate_token(sub=user.user_id)
        return {"access_token": generatedToken, "token_type": "bearer"}


@router.get("/profile", status_code=status.HTTP_200_OK, response_model=userSchemas.CurrentUserProfile)
def get_current_profile(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.Users).filter(models.Users.user_id == current_user_id).first()
    return user

@router.get("/profile/{id}", status_code=status.HTTP_200_OK, response_model=userSchemas.UserProfile)
def get_profile(id:int, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.Users).filter(models.Users.user_id == id).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"User with id {id} doesn't exist")
    return user

@router.put("/profile", status_code=status.HTTP_200_OK)
def update_user(request: userSchemas.UserReg, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.Users).filter(models.Users.user_id == current_user_id)
    # have to use dict function to update dictonary values of request
    user.update(request.dict(), synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "User Updated"}

# A deleted user wont be able to call this again so we dont check if the user exists here
@router.delete("/profile", dependencies=[Depends(checkout_transactions)],status_code=status.HTTP_200_OK)
def delete_user(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    #If a guest has paid the user to stay at their residence and the guest has not completed their stay then the host can't delete their profile
    has_transactions = db.query(models.Transactions).filter(models.Transactions.listing_id==models.Listings.listing_id, models.Listings.host_id==current_user_id, models.Transactions.checkout_date>datetime.now(tz=timezone.utc)).first()
    if has_transactions:
        raise HTTPException(status_code= status.HTTP_403_FORBIDDEN, detail=f"User with id {current_user_id} can't delete their profile until their guest completes the stay that they have already paid for")
    #Unlist all listings belonging to this user
    db.query(models.Listings).filter(models.Listings.host_id == current_user_id).update({"is_listed": False},synchronize_session=False)
    #For all transactions related to this user, assume the guest/host rated them and they rated the guest/host(since no point in actually rating or being rated by a deleted user)
    db.query(models.Transactions).filter(models.Transactions.listing_id==models.Listings.listing_id, or_(models.Listings.host_id==current_user_id, models.Transactions.guest_id==current_user_id)).update({"has_host_rated": True, "has_guest_rated": True},synchronize_session=False)
    #Delete the user
    user = db.query(models.Users).filter(models.Users.user_id == current_user_id)
    user.delete(synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "User Deleted"}

# Allow user to upload images, needs to be an async function. This (...) means required
@router.post("/profile/image", status_code=status.HTTP_201_CREATED)
async def set_profile_image(file: UploadFile = File(...), db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # gets the extension of the uploaded file
    extension = "." + file.filename.split(".")[-1]
    # if extension is invalid then return error
    if (extension not in [".png", ".jpg", ".jpeg", ".webp"]):
        return {"error": "File extension not allowed"}
    # If user already has a profile pic then remove it first
    old_image_user=db.query(models.Users).filter(models.Users.user_id == current_user_id).first()
    if old_image_user.image_path!="/static/images/defaultprofilepic.jpg":
        # If file exists then delete it
        if os.path.isfile("."+old_image_user.image_path):
            os.remove("."+old_image_user.image_path)
    # give the image file a new name along with the path where it will be stored
    Storedfilename = "/static/images/" + secrets.token_hex(4) + str(current_user_id) + extension
    file_content = await file.read()
    # stores it in server files by writing it into a new file
    with open("."+Storedfilename, "wb") as inputfile:
        inputfile.write(file_content)
    await file.close()
    # Store new file path in DB
    db.query(models.Users).filter(models.Users.user_id == current_user_id).update({"image_path": Storedfilename}, synchronize_session="fetch")
    db.commit()
    return {"Success": "Image was uploaded and stored"}
