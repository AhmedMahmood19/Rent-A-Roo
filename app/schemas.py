# This file contains all the schemas which will be used for requests/responses in JSON form
# Do not confuse this with database schemas!
from pydantic import BaseModel, EmailStr

class User(BaseModel):
    userid: int
    password: str
    email: EmailStr
    fname: str 
    lname: str 
    Pnum: str
    AvgHRating: int
    AvgGRating: int
    aboutme: str | None = None
    class Config:
        orm_mode = True
