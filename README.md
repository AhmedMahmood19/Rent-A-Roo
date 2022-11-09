## File Structure
```
App
├── __init__.py         #Needed in every directory for easy relative imports
├── main.py             #The whole application starts here
├── .gitignore
├── README.md
├── requirements.txt    #contains python packages that need to be installed
│
├── database            #contains all files needed to interact with a database
│   ├── __init__.py
│   ├── connection.py   #connects application to a database
│   └── models.py       #contains all the database schemas(called models in this project)
│
├── routers
│   ├── __init__.py
│   ├── Authentication.py
│   ├── listings.py
│   └── users.py
│
├── schemas             #Contains all pydantic models(called schemas)
│   ├── __init__.py
│   ├── listingSchemas.py
│   └── userSchemas.py
│
└── static              #Contains all static files that are transferred to and from frontend
    └── images
```
## Always import the whole file from a directory like:
```
from schemas import userSchemas
```
## So when you use a class from it you write it as 
```
userSchemas.UserReg
```
### Thus it will not be confusing where a class or function is from and it makes the code more readable