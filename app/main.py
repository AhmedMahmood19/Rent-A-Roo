from fastapi import FastAPI
from routers import users,listings,reservations,ratingsandquestions
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# static file setup configuration
app.mount("/static", StaticFiles(directory="static"), name="static")

app.include_router(users.router)
app.include_router(listings.router)
app.include_router(reservations.router)
app.include_router(ratingsandquestions.router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
