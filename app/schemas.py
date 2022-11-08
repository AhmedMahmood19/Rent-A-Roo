# Do not confuse this with database schemas(called models in this Project)! 
# Schemas can be thought of as structs which make sending and recieving requests/responses in JSON format easier 
# 1.Make schemas according to the data we need from the current endpoint's request eg: Register doesnt need avgGuestRating, Login doesn't need PhoneNo etc
# 2.Make schemas according to the data we need to send as the current endpoint's response eg: We can return a whole ORM Model but the response_model only has few attrs from it
# We need orm_mode in 2 but not in 1. Read ORM Mode here: https://pydantic-docs.helpmanual.io/usage/models/ also check (bitfumes 2:10:00)
# naming conventions: Class name will be Initcap, attrs will be camelCase
from pydantic import BaseModel, EmailStr, Field
from pydantic.typing import Optional 

#This class is not being used yet but dont remove!!!
class User(BaseModel):
    userId: Optional[int] = Field(default=None, primary_key=True) #Never assign a value to an Auto-increment PK
    email: EmailStr
    password: str
    firstName: str 
    lastName: str
    phoneNo: str
    profileImagePath : str | None = None #str|None means optional, =None means default value is NULL
    avgHostRating: int
    avgGuestRating: int
    totalHostRating: int
    totalGuestRating: int
    aboutMe: str | None = None
    class Config:
        orm_mode = True

#used for logging in
class UserLogin(BaseModel):
    email: EmailStr
    password: str

# Read about model inheritance https://fastapi.tiangolo.com/tutorial/extra-models/
# used for registering
class UserReg(UserLogin):
    firstName: str
    lastName: str
    phoneNo: str
    aboutMe: str | None = None
    class Config:
        orm_mode = True

#####################################
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: str | None = None