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

class SearchListing(BaseModel):
    STATE             :str | None = None
    CITY              :str | None = None
    IS_APARTMENT      :bool | None = None    #T/F = apartment/house
    IS_SHARED         :bool | None = None    #T/F shared space/whole space to yourself
    ACCOMMODATES      :int | None = None
    BATHROOMS         :int | None = None
    BEDROOMS          :int | None = None
    WIFI              :bool | None = None
    KITCHEN           :bool | None = None
    WASHING_MACHINE   :bool | None = None
    AIR_CONDITIONING  :bool | None = None
    TV                :bool | None = None
    HAIR_DRYER        :bool | None = None
    IRON              :bool | None = None
    POOL              :bool | None = None
    GYM               :bool | None = None
    SMOKING_ALLOWED   :bool | None = None
    NIGHTS            :int | None = None     #We will check if its >=MIN_NIGHTS and <=MAX_NIGHTS
    MIN_NIGHTLY_PRICE :int | None = None     #If given check for price greater or equal to it
    MAX_NIGHTLY_PRICE :int | None = None     #If given check for price lesser or equal to it
    MIN_RATING        :int | None = None
    MAX_RATING        :int | None = None
    MIN_TOTAL_RATINGS :int | None = None
    MAX_TOTAL_RATINGS :int | None = None
    # EITHER BOTH OF THE FOLLOWING ARE NONE OR BOTH MUST HAVE VALID VALUES
    IS_ASCENDING      :bool| None = None    #T/F = ASC/DESC
    ORDER_BY          :str | None = None    #USER WILL PICK FROM CITY/STATE/RATING/NIGHTLY_PRICE

class SearchResult(BaseModel):
    LISTING_ID        :int
    CITY              :str
    STATE             :str
    RATING            :int
    NIGHTLY_PRICE     :int
    # SEND THE PATH TO THE FIRST IMAGE OF THE LISTING
    IMAGE_PATH        :str
    class Config:
        orm_mode = True