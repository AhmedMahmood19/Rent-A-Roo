from PIL import Image
from fastapi.staticfiles import StaticFiles
from fastapi import File, UploadFile
from fastapi import FastAPI, Depends, status, HTTPException, Response
from fastapi.security import OAuth2PasswordRequestForm
from . import Authentication, models, schemas
from .database import get_db
from sqlalchemy.orm import Session

app = FastAPI()

@app.post("/register", status_code=status.HTTP_201_CREATED,tags=['login & signup'])
def register_user(request: schemas.UserReg, db: Session = Depends(get_db)):
    #We dont need to specify all the attributes when making a model, 
    # but make sure that NOTNULL attributes have values or a default value when adding to a session
    insertuser = models.USER(
        EMAIL=request.email,
        PASSWORD=request.password,
        FIRST_NAME=request.firstName,
        LAST_NAME=request.lastName,
        PHONE_NO=request.phoneNo,
        ABOUT_ME=request.aboutMe
    )
    #Dont insert if email is already in use
    user = db.query(models.USER).filter(models.USER.EMAIL == insertuser.EMAIL).first()
    if user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail="This email is already in use")
    else:
        db.add(insertuser)
        db.commit()

@app.post("/login", status_code=status.HTTP_200_OK, response_model=schemas.Token,tags=['login & signup'])
def login_user(formdata: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    # Run a SELECT query on table USERS, where email and password must match,must use "username" since its fixed by OAuth2 Form
    user = db.query(models.USER).filter(models.USER.EMAIL == formdata.username, models.USER.PASSWORD == formdata.password).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail="Incorrect email or password")
    else:
        #Generate and return a JWT token
        access_token = Authentication.create_access_token(data={"sub": user.EMAIL})
        return {"access_token": access_token, "token_type": "bearer"}

@app.get('/user/{email}', status_code=200)
def show(email:str, db:Session=Depends(get_db)):
    user = db.query(models.USER).filter(models.USER.EMAIL == email).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"user with the email {email} is not available")
        #response.status_code = status.HTTP_404_NOT_FOUND
        #return  {'detail':f"Blog with the id {id} is not available"}
    return user

@app.delete('/user/{email}',status_code=status.HTTP_204_NO_CONTENT)
def deleteuser(email:str, db:Session=Depends(get_db)):
    user = db.query(models.USER).filter(models.USER.EMAIL == email)
    if not user.first():
        raise HTTPException(status_code= status.HTTP_404_NOT_FOUND, detail=f"User with email {email} not found")
    user.delete(synchronize_session=False)
    db.commit()
    return {"status":"Complete","Detail":"User Deleted"}

@app.put('/user/{email}',status_code=status.HTTP_202_ACCEPTED)
def updateuser(email:str,request:schemas.ShowUser ,db:Session=Depends(get_db)):
    user =db.query(models.USER).filter(models.USER.EMAIL == email)
    if not user.first():
        raise HTTPException(status_code = status.HTTP_404_NOT_FOUND, detail= f'user with email {email} not found')
    user.update(request.dict(),synchronize_session=False) #have to use dict function to update dictonary values of request which is body and title
    db.commit()
    return {"status":"Complete","Detail":"User Updated"}
############################################
#                                          #
#                 *TESTING*                #
#                                          #
############################################
# @app.get("/", status_code=status.HTTP_200_OK, response_model=schemas.User)
# def get_user(db: Session = Depends(get_db), current_user: schemas.User = Depends(Authentication.get_current_user)):
#     print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
#     print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
#     print(current_user.email)
#     print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
#     print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

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