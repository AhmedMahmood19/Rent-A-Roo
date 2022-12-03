from pydantic import BaseModel


class QandA(BaseModel):
    question_id: int
    first_name: str | None
    last_name: str | None
    question: str
    answer: str | None

    class Config:
        orm_mode = True

class AskQ(BaseModel):
    listing_id: int
    question: str

class AnswerQ(BaseModel):
    question_id: int
    answer: str

class RandR(BaseModel):
    first_name: str | None  #Names will be NULL if they were deleted, so app shows as "Deleted User"
    last_name: str | None
    rating: int
    review: str | None  #Reviews are optional so they may or may not exist but rating always exists

    class Config:
        orm_mode = True

class GuestRandR(BaseModel):
    transaction_id: int
    rating_of_host : int
    rating_of_listing : int
    review_of_listing: str | None

class HostRandR(BaseModel):
    transaction_id: int
    rating_of_guest: int
