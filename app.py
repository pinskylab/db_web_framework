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

# ==== SECTION: Route HTML Files ====

@app.route("/")
def index():
    return render_template('index.html')

@app.route('/readme')
def readme():
    readme_path = os.path.join(app.config['STATIC_FOLDER'], 'README.md')
    with open(readme_path, 'r') as file:
        content = file.read()
        html_content = markdown2.markdown(content, extras=["fenced-code-blocks"])
    return render_template('README.html', content=Markup(html_content))

@app.route("/log_tissue_box_81_samples.html")
def log_tissue_box_81_samples():
    return render_template('log_tissue_box_81_samples.html')

@app.route("/log_tissue_box_49_samples.html")
def log_tissue_box_49_samples():
    return render_template('log_tissue_box_49_samples.html')

@app.route("/upload_csv_sample_metadata.html")
def upload_csv_sample_metadata():
    return render_template('upload_csv_sample_metadata.html')

#added function for downloading csv templates
@app.route('/download_csv_template')
def download_csv_template():
	template_path = os.path.join(app.config['STATIC_FOLDER'], 'templates', 'csv_template.csv')
	return send_from_directory(directory=os.path.dirname(template_path), filename=os.path.basename(template_path))


@app.route("/query_sample_id.html")
def query_sample_id():
    return render_template('query_sample_id.html')

# ==== SECTION: Database Connection Functions ====

@app.route('/get_db_connection', methods=['GET'])
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

@app.route('/test_db_connection', methods=['GET'])
def test_db_connection():
    connection = get_db_connection()
    if connection:
        connection.close()
        
        return jsonify({"status": "success", "message": "Database connection successful"})
    else:
        print("Not success")
        return jsonify({"status": "error", "message": "Database connection failed"})

# ==== SECTION: Database Data Transfer Functions ====

@app.route('/add_sample_archive_info', methods=['POST'])
def add_sample_archive_info():
    sample_data = []  # Initialize it here or use a global/session variable
    data = request.json
    print("Received data:", data)

    sample_id = data['sample_id']
    inventory_date = data['inventory_date']
    inventory_location = data['inventory_location']
    inventoried_by_username = data['inventoried_by_username']
    box_name = data['box_name']
    box_cell = data['box_cell']

    # Store data in the in-memory list
    sample_entry = {
        'sample_id': sample_id,
        'inventory_date': inventory_date,
        'inventory_location': inventory_location,
        'inventoried_by_username': inventoried_by_username,
        'box_name': box_name,
        'box_cell': box_cell
    }
    sample_data.append(sample_entry) # type: ignore
    print("Sample data stored locally:", sample_entry)

    # Connect to the MySQL database and insert data
    try:
        connection = get_db_connection()
        if not connection:
            print("Failed to connect to the database")
            return jsonify({"status": "error", "message": "Failed to connect to the database"}), 500

        cursor = connection.cursor()

        print("Database connection established")

        # Call the stored procedure and pass parameters
        cursor.callproc('archive_samples', [
            sample_entry['sample_id'],
            sample_entry['inventory_date'],
            sample_entry['inventory_location'],
            sample_entry['inventoried_by_username'],
            sample_entry['box_name'],
            sample_entry['box_cell']
        ])

        connection.commit()
        print("Data appended to the database")

        response = {"status": "success", "message": "Sample data logged locally and appended to the database"}
    except mysql.connector.Error as err:
        response = {"status": "error", "message": str(err)}
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'connection' in locals():
            connection.close()

    return jsonify(response)

@app.route('/query_lab_member_info', methods=['GET'])
def query_lab_member_info():
    try:
        connection = get_db_connection()
        if not connection:
            print("Failed to connect to the database")
            return jsonify({"status": "error", "message": "Failed to connect to the database"}), 500

        cursor = connection.cursor(dictionary=True)
        print("Database connection established")

        query = "SELECT * FROM  lab_members LIMIT 3;"

        cursor.execute(query)
        
        rows = cursor.fetchall()

        response = {"status": "success", "data": rows}

    except mysql.connector.Error as err:
        response = {"status": "error", "message": str(err)}
    finally:
        cursor.close()
        connection.close()

    return jsonify(response)

@app.route("/uploadCSV_os", methods=['POST'])
def uploadCSV_os():
    if 'file' not in request.files:
        return jsonify({"status": "error", "message": "No file part"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"status": "error", "message": "No file selected"}), 400

    # Save the uploaded file
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
    file.save(file_path)

    # Generate CSV preview
    preview = get_csv_preview(file_path)

    return jsonify({"status": "success", "preview": preview})

def get_csv_preview(file_path):
    preview = []
    try:
        with open(file_path, mode='r') as csvfile:
            reader = csv.reader(csvfile)
            for i, row in enumerate(reader):
                if i == 11:  # Limit to header and first 10 rows
                    break
                preview.append(row)
    except Exception as e:
        preview = {"error": str(e)}

    return preview

@app.route("/process_uploadCSV_sample_metadata", methods=['POST'])
def process_uploadCSV_sample_metadata():
    if 'file' not in request.files:
        return jsonify({"status": "error", "message": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"status": "error", "message": "No file selected"}), 400

    file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
    file.save(file_path)

    connection = get_db_connection()
    if not connection:
        return jsonify({"status": "error", "message": "Failed to connect to the database"}), 500
    else:
        print("Connection Successful")
    
    cursor = connection.cursor()

    try:
        with open(file_path, mode='r') as csvfile:
            reader = csv.reader(csvfile)
            next(reader)  # Skip the header row
            for row in reader:
                processed_row = [None if field == '' else field for field in row]		
                cursor.execute(
                    "INSERT INTO sample_metadata (sample_id, project_name, species, site, latitude, longitude, collection_date, collector_name, storage_solution, storage_volume, tissue_left, tissue_left_date, sample_owner, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", 
                    processed_row
                )
                connection.commit()
        response = {"status": "success"}
    except mysql.connector.Error as err:
        response = {"status": "error", "message": str(err)}
    finally:
        cursor.close()
        connection.close()
        os.remove(file_path)  # Remove the uploaded file after processing

    return jsonify(response)




if __name__ == '__main__':
    app.run(debug=True)
