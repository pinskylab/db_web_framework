CREATE TABLE print_plate_barcode (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    plate_id VARCHAR(255) NOT NULL UNIQUE
);