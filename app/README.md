## Steps
### 1. Clone this repo to your system and cd into /App

### 2. Create a virtual environment:
````
python3 -m venv 1_venv
````
### 3. Activate the virtual environment:
````
source 1_venv/bin/activate
````
### 4. Install required packages:
````
pip3 install -r requirements.txt
````
### 5. Run the server when you are in the App directory with:
````
uvicorn main:app --reload
````
### 6. For testing go to the following link on your browser 
```
localhost:8000/docs
```
## Tips:
* To shutdown server press ctrl+C in the terminal where you ran uvicorn.
* You can edit your code while the server is running and it will update any changes to the server as soon as you save your code file.
