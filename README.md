# Flask Web App Set Up For MySQL Database Interfacing

This project is a Flask web application designed to interact with a MySQL database. It provides various routes for managing sample data, querying information, and displaying documentation.

## Prerequisites

Before you begin, ensure that you have the following installed on your system:

- **Python 3.x**
- **MySQL Server** (or access to a remote MySQL database)

## Setup Instructions

## 1. Clone the Repository

Start by cloning this repository to your local machine:

```bash
# Choose either http or ssh
# http
git clone https://github.com/pinskylab/db_web_framework.git
# ssh
git clone git@github.com:pinskylab/db_web_framework.git
cd db_web_framework
```

## 2. Create Environment
```bash
python3 -m venv env
# Source Environment
source env/bin/activate
```
If venv is not installed:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install python3.12-venv
```

## 3. Install Dependencies
```bash
pip install -r requirements.txt
# Create your config which will be used to connect the app to the database
```

## 4. Configure the Environment

Ensure that you have the correct database credentials by modifying the config.py file. The Config class in config.py should look like this:
```python
class Config:
    MYSQL_HOST = 'your_mysql_host'
    MYSQL_USER = 'your_mysql_user'
    MYSQL_PASSWORD = 'your_mysql_password'
    MYSQL_DB = 'your_mysql_database'
```
## 5. Set Up the Database

Ensure that your MySQL server is running and the database specified in the configuration (MYSQL_DB) exists.

You may need to set up the necessary tables and stored procedures for your application. If these are not already created, you can create them manually or consult your project documentation for instructions.

## 6. Run the Flask Application

Once the environment is set up, you can run the Flask application using the following command:
```bash
python3 app.py
```
By default, the Flask app will be available at http://127.0.0.1:5000

