from PIL import Image
from fastapi.staticfiles import StaticFiles
from fastapi import File, UploadFile
from fastapi import FastAPI, Depends, status, HTTPException, Response
from fastapi.security import OAuth2PasswordRequestForm
from . import Authentication, models, schemas
from .database import get_db
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    "http://localhost.tiangolo.com",
    "https://localhost.tiangolo.com",
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:44859",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/register", status_code=status.HTTP_201_CREATED,tags=['Signup & Login'])
def register_user(request: schemas.UserReg, db: Session = Depends(get_db)):
    #We dont need to specify all the attributes when making a model, 
    # but make sure that NOTNULL attributes have values or a default value when adding to a session
    insertuser = models.USER(
        EMAIL=request.EMAIL,
        PASSWORD=request.PASSWORD,
        FIRST_NAME=request.FIRST_NAME,
        LAST_NAME=request.LAST_NAME,
        PHONE_NO=request.PHONE_NO,
        ABOUT_ME=request.ABOUT_ME
    )
    #Dont insert if email is already in use
    user = db.query(models.USER).filter(models.USER.EMAIL == insertuser.EMAIL).first()
    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="This email is already in use")
    else:
        db.add(insertuser)
        db.commit()
        return {"status":"Success","Detail":"User Registered"}

@app.post("/login", status_code=status.HTTP_200_OK, response_model=schemas.Token,tags=['Signup & Login'])
def login_user(formdata: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    # Run a SELECT query on table USERS, where email and password must match,must use "username" since its fixed by OAuth2 Form
    user = db.query(models.USER).filter(models.USER.EMAIL == formdata.username, models.USER.PASSWORD == formdata.password).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail="Invalid Email or Password")
    else:
        #Generate a token, store it in a Token schema, then return it as the response
        generatedToken = schemas.Token(access_token= Authentication.generate_token(sub=user.USER_ID) ,token_type="bearer")
        return generatedToken


############################################
#                                          #
#                 *TESTING*                #
#                                          #
############################################
# # Uploading Images
# # static file setup configuration
# app.mount("/static", StaticFiles(directory="static"), name="static")
# # Allow user to upload images, needs to be an async function. (...) means required
# @app.post("/userandimage", status_code=status.HTTP_201_CREATED)
# async def create_userandimage(request: schemas.UserReg, file: UploadFile = File(...), db: Session = Depends(get_db)):
#     new_user = models.USER(
#         USER_ID=request.userId,
#         EMAIL=request.email,
#         PASSWORD=request.password,
#         FIRST_NAME=request.firstName,
#         LAST_NAME=request.lastName,
#         PHONE_NO=request.phoneNo,
#         ABOUT_ME=request.aboutMe
#     )
#     # splits filename by . and gets the last string to get the extension
#     extension = file.filename.split(".")[-1]
#     # These are the only allowed file extensions if not one these then return error
#     if (extension not in ["png", "jpg"]):
#         return {"status": "error", "detail": "File extension not allowed"}
#     # Image is stored on server with the following name
#     Storedfilename = "./static/images/" + request.userId + extension
#     file_content = await file.read()
#     # stored it in server files
#     with open(Storedfilename, "wb") as inputfile:
#         inputfile.write(file_content)
#     # We need to reduce image size to save space
#     img = Image.open(Storedfilename)
#     img = img.resize(size=(200, 200))
#     img.save(Storedfilename)
#     file.close()
#     new_user.PROFILE_IMAGE_PATH = Storedfilename
#     db.add(new_user)
#     # must commit any changes to the database
#     db.commit()
#     # After a commit all Model objects are expired so to get their updated data they must be refreshed
#     db.refresh(new_user)
#     return {"Success": "Everything is fine"}
###########################################

@app.get('/user/profile', status_code=status.HTTP_200_OK,response_model=schemas.User,tags=['User'])
def read_user(db:Session=Depends(get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user=db.query(models.USER).filter(models.USER.USER_ID == current_user_id).first()
    return user

@app.delete('/user/profile',status_code=status.HTTP_200_OK,tags=['User'])
def deleteuser(db:Session=Depends(get_db), current_user_id: int = Depends(Authentication.get_current_user_id)):
    user = db.query(models.USER).filter(models.USER.USER_ID == current_user_id)
    user.delete(synchronize_session=False)
    db.commit()
    return {"status":"Success","Detail":"User Deleted"}

@app.put('/user/profile',status_code=status.HTTP_200_OK,tags=['User'])
def update_user(request:schemas.UserReg ,db:Session=Depends(get_db), current_user: str = Depends(Authentication.get_current_user)):
    user =db.query(models.USER).filter(models.USER.EMAIL == current_user).first()
    user.update(request.dict(),synchronize_session=False) #have to use dict function to update dictonary values of request
    db.commit()
    return {"status":"Success","Detail":"User Updated"}