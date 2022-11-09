# @app.post("/user", status_code=status.HTTP_201_CREATED)
# def create_user(request: schemas.User, db: Session = Depends(get_db)):
#     new_user = models.USER(
#         USER_ID=request.userid,
#         PASSWORD=request.password,
#         EMAIL=request.email,
#         FIRST_NAME=request.fname,
#         LAST_NAME=request.lname,
#     )
#     # inserts new user into table
#     db.add(new_user)
#     # must commit any changes to the database
#     db.commit()
#     # After a commit all Model objects are expired so to get their updated data they must be refreshed
#     db.refresh(new_user)
#     return new_user


# @app.get("/user", status_code=status.HTTP_200_OK)
# def get_all_users(db: Session = Depends(get_db)):
#     # Run a SELECT query on table USERS, for all
#     users = db.query(models.USER).all()
#     return users


# @app.get("/user/{id}", status_code=status.HTTP_200_OK)
# def get_user(id: int, db: Session = Depends(get_db)):
#     # Run a SELECT query on table USERS, where USER_ID==id AND limit=1
#     user = db.query(models.USER).filter(models.USER.USER_ID == id).first()
#     if not user:
#         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
#                             detail=f"User with id {id} is not available")
#     else:
#         return user


# @app.delete("/user/{id}", status_code=status.HTTP_204_NO_CONTENT)
# def delete_user(id: int, db: Session = Depends(get_db)):
#     user = db.query(models.USER).filter(models.USER.USER_ID == id)
#     if not user.first():
#         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
#                             detail=f"User with id {id} is not available")
#     else:
#         user.delete(synchronize_session=False)
#         # must commit any changes made to the database
#         db.commit()
#     # No content returned after a successful delete so no return statement


# @app.put("/user/{id}", status_code=status.HTTP_202_ACCEPTED)
# def update_user(id: int, request: schemas.User, db: Session = Depends(get_db)):
#     user = db.query(models.USER).filter(models.USER.USER_ID == id)
#     if not user.first():
#         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
#                             detail=f"User with id {id} is not available")
#     else:
#         user.update(request.dict(), synchronize_session=False)
#         # must commit any changes made to the database
#         db.commit()
#     return "user was updated"