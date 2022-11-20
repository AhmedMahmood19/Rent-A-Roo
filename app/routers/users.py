from fastapi import APIRouter, Depends, HTTPException, status
from PIL import Image
import secrets
from fastapi import File, UploadFile
from fastapi.security import OAuth2PasswordRequestForm
from routers import Authentication
from database import models, connection
from schemas import userSchemas
from sqlalchemy.orm import Session

router = APIRouter(prefix="/user", tags=['User'])

@router.post("/register", status_code=status.HTTP_201_CREATED)
def create_user(request: userSchemas.UserReg, db: Session = Depends(connection.get_db)):
    # We dont need to specify all the attributes when making a model,
    # but make sure that NOTNULL attributes have values or a default value when adding to a session
    insertuser = models.USER(
        EMAIL=request.EMAIL,
        PASSWORD=request.PASSWORD,
        FIRST_NAME=request.FIRST_NAME,
        LAST_NAME=request.LAST_NAME,
        PHONE_NO=request.PHONE_NO,
        ABOUT_ME=request.ABOUT_ME
    )
    # Dont insert if email is already in use
    user = db.query(models.USER).filter(
        models.USER.EMAIL == insertuser.EMAIL).first()
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
    user = db.query(models.USER).filter(models.USER.EMAIL == formdata.username, models.USER.PASSWORD == formdata.password).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Invalid Email or Password")
    else:
        # Generate a token, store it in a Token schema, then return it as the response
        generatedToken = Authentication.generate_token(sub=user.USER_ID)
        return {"access_token": generatedToken, "token_type": "bearer"}


@router.get("/profile", status_code=status.HTTP_200_OK, response_model=userSchemas.User)
def read_user(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id).first()
    return user


@router.put("/profile", status_code=status.HTTP_200_OK)
def update_user(request: userSchemas.UserReg, db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id)
    # have to use dict function to update dictonary values of request
    user.update(request.dict(), synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "User Updated"}


@router.delete("/profile", status_code=status.HTTP_200_OK)
def delete_user(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id)
    user.delete(synchronize_session=False)
    db.commit()
    return {"status": "Success", "Detail": "User Deleted"}

# Allow user to upload images, needs to be an async function. This (...) means required
@router.post("/profile/image", status_code=status.HTTP_201_CREATED)
async def set_profile_image(file: UploadFile = File(...), db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    # gets the extension of the uploaded file
    extension = "." + file.filename.split(".")[-1]
    # if extension is invalid then return error
    if (extension not in [".png", ".jpg", ".jpeg"]):
        return {"error": "File extension not allowed"}
    # give the image file a new name along with the path where it will be stored
    Storedfilename = "/static/images/" + secrets.token_hex(4) + str(current_user_id) + extension
    file_content = await file.read()
    # stores it in server files by writing it into a new file
    with open("."+Storedfilename, "wb") as inputfile:
        inputfile.write(file_content)
    # Reduce image size to save space
    img = Image.open("."+Storedfilename)
    img = img.resize(size=(200, 200))
    img.save("."+Storedfilename)
    file.close()
    # Store new file path in DB
    db.query(models.USER).filter(models.USER.USER_ID == current_user_id).update({"PROFILE_IMAGE_PATH": Storedfilename}, synchronize_session="fetch")
    db.commit()
    return {"Success": "Image was uploaded and stored"}

@router.get("/profile/image", status_code=status.HTTP_200_OK)
async def get_profile_image(db: Session = Depends(connection.get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id).first()
    imageURL = "localhost:8000" + user.PROFILE_IMAGE_PATH
    return {"Image URL": imageURL}

##########################################
# UPLOADING MULTIPLE FILES
##########################################

# from fastapi import UploadFile, File
# import shutil
# from typing import List

# @router.post("/images")
# async def upload_images(files: List[UploadFile] = File(...)):
#     for i,img in enumerate(files):
#         with open("static/images/" + str(i) + img.filename, "wb") as buffer:
#             shutil.copyfileobj(img.file, buffer)
        
#     return {"No. of images uploaded": len(files)}
