from flask import Flask, request, jsonify, render_template, send_from_directory, url_for
from markupsafe import Markup
import mysql.connector
import markdown2
import csv
import os
from mysql.connector import errorcode
from config import Config

app = Flask(__name__)
app.config.from_object(Config)
app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['STATIC_FOLDER'] = 'static'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=app.config['MYSQL_HOST'],
            user=app.config['MYSQL_USER'],
            password=app.config['MYSQL_PASSWORD'],
            database=app.config['MYSQL_DB']
        )
        return connection
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)

@app.route('/output_test', methods=['GET'])
def output_test():
    console.log("TestTest")

@app.route('/test_db_connection', methods=['GET'])
def test_db_connection():
    connection = get_db_connection()
    if connection:
        connection.close()
        
        return jsonify({"status": "success", "message": "Database connection successful"})
    else:
        print("Not success")
        return jsonify({"status": "error", "message": "Database connection failed"})

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/log_tissue_box_81_samples.html")
def log_tissue_box_81_samples():
    return render_template('log_tissue_box_81_samples.html')

@app.route('/add_sample_archive_info', methods=['POST'])
def add_sample_archive_info():
    data = request.json

    sample_id = data['sample_id']
    inventory_date = data['inventory_date']
    inventory_location = data['inventory_location']
    inventoried_by_username = data['inventoried_by_username']
    box_name = data['box_name']
    box_cell = data['box_cell']

    connection = get_db_connection()
    if not connection:
        return jsonify({"status": "error", "message": "Failed to connect to the database"}), 500

    cursor = connection.cursor()

    try:
        cursor.callproc('archive_samples', [
            sample_id,
            inventory_date,
            inventory_location,
            inventoried_by_username,
            box_name,
            box_cell
        ])
        connection.commit()
        response = {"status": "success"}
    except FileNotFoundError:
        response = {"status": "error", "message": "CSV file not found"}
    except mysql.connector.Error as err:
        response = {"status": "error", "message": str(err)}
    finally:
        cursor.close()
        connection.close()

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)