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

class TransactionsHost(Transactions):
    has_host_rated:bool|None

    class Config:
        orm_mode = True

class TransactionsGuest(Transactions):
    has_guest_rated:bool|None
    
    class Config:
        orm_mode = True

class GuestProfile(BaseModel):
    first_name: str 
    last_name: str
    phone_no: str
    image_path : str
    avg_host_rating: int
    avg_guest_rating: int
    about_me: str | None = None
    class Config:
        orm_mode = True
