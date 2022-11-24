from pydantic import BaseModel
from typing import List

class SearchListing(BaseModel):
    state             :str | None = None
    city              :str | None = None
    is_apartment      :bool | None = None    #T/F = apartment/house
    is_shared         :bool | None = None    #T/F shared space/whole space to yourself
    accommodates      :int | None = None
    bathrooms         :int | None = None
    bedrooms          :int | None = None
    wifi              :bool | None = None
    kitchen           :bool | None = None
    washing_machine   :bool | None = None
    air_conditioning  :bool | None = None
    tv                :bool | None = None
    hair_dryer        :bool | None = None
    iron              :bool | None = None
    pool              :bool | None = None
    gym               :bool | None = None
    smoking_allowed   :bool | None = None
    nights            :int | None = None     #We will check if its >=MIN_NIGHTS and <=MAX_NIGHTS
    min_nightly_price :int | None = None     #If given check for price greater or equal to it
    max_nightly_price :int | None = None     #If given check for price lesser or equal to it
    min_rating        :int | None = None
    max_rating        :int | None = None
    min_total_ratings :int | None = None
    max_total_ratings :int | None = None
    # EITHER BOTH OF THE FOLLOWING ARE NONE OR BOTH MUST HAVE VALID VALUES
    is_ascending      :bool| None = None    #T/F = ASC/DESC
    order_by          :str | None = None    #USER WILL PICK FROM CITY/STATE/RATING/NIGHTLY_PRICE

class SearchResult(BaseModel):
    listing_id        :int
    city              :str
    state             :str
    rating            :int
    nightly_price     :int
    # SEND THE PATH TO THE FIRST IMAGE OF THE LISTING
    image_path        :List[str]
    class Config:
        orm_mode = True

class PromoteListing(BaseModel):
    listing_id        :int
    days              :int