# Do not confuse this with database schemas(called models in this Project)! 
# Schemas can be thought of as structs which make sending and recieving requests/responses in JSON format easier 
# 1.Make schemas according to the data we need from the current endpoint's request eg: Register doesnt need avgGuestRating, Login doesn't need PhoneNo etc
# 2.Make schemas according to the data we need to send as the current endpoint's response eg: We can return a whole ORM Model but the response_model only has few attrs from it
# We need orm_mode in 2 but not in 1. Read ORM Mode here: https://pydantic-docs.helpmanual.io/usage/models/ also check (bitfumes 2:10:00)

# Naming Convention: Class name will be Initcap, attribute names will be same as in models.py
from pydantic import BaseModel, EmailStr, Field
from pydantic.typing import Optional 

#used for logging in
class UserLogin(BaseModel):
    email: EmailStr
    password: str

# Read about model inheritance https://fastapi.tiangolo.com/tutorial/extra-models/
# used for registering
class UserReg(UserLogin):
    first_name: str
    last_name: str
    phone_no: str
    about_me: str | None = None
    class Config:
        orm_mode = True

class UserProfile(BaseModel):
    first_name: str 
    last_name: str
    phone_no: str
    image_path : str
    avg_host_rating: int
    avg_guest_rating: int
    about_me: str | None = None
    class Config:
        orm_mode = True

class CurrentUserProfile(UserProfile):
    email: EmailStr
    password: str
    class Config:
        orm_mode = True