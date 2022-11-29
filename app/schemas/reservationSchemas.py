from pydantic import BaseModel
from datetime import datetime


class CreateReservation(BaseModel):
    listing_id: int
    checkin_date: datetime
    checkout_date: datetime


class ReservedDates(BaseModel):
    checkin_date: datetime
    checkout_date: datetime

    class Config:
        orm_mode = True


class Reservations(BaseModel):
    reservation_id: int
    listing_id: int
    title: str
    checkin_date: datetime
    checkout_date: datetime
    amount_due:int

    class Config:
        orm_mode = True


class Transactions(BaseModel):
    transaction_id: int
    listing_id: int
    title: str
    checkin_date: datetime
    checkout_date: datetime
    amount_paid:int

    class Config:
        orm_mode = True
