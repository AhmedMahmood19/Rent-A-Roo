from fastapi import FastAPI
from routers import users,listings
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.include_router(users.router)
app.include_router(listings.router)

origins = [
    "http://localhost.tiangolo.com",
    "https://localhost.tiangolo.com",
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:44859",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
