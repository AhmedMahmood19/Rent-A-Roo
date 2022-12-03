from datetime import timedelta, datetime
from jose import jwt
from fastapi import HTTPException, status, Depends
from fastapi.security import OAuth2PasswordBearer

SECRET_KEY = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/user/login")

#takes USER_ID and generates a token using it 
def generate_token(sub: int):
    sub=str(sub)
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    payload = {"sub": sub, "exp": expire}
    # To encode into a JWT(generate a token) we need a couple things like encryption algo, secret(256bit key) and payload("sub"=UserID,"exp"=expiry time)
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

# As long as we have visited oauth2_scheme before using this function we will get the token
def get_current_user_id(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    except:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return int(payload["sub"])