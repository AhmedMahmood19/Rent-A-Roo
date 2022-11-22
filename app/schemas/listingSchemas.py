from pydantic import BaseModel, EmailStr, Field
from pydantic.typing import Optional 

# class CreateListing(BaseModel):
#     TITLE: str

# class Listing(BaseModel):
#     LISTING_ID: Optional[int] = Field(default=None, primary_key=True) #Never assign a value to an Auto-increment PK
#     HOST_ID: Optional[int] = Field(default=None)
#     TITLE: str
#     class Config:
#         orm_mode = True