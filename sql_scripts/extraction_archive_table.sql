CREATE TABLE extraction_archive_plate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    extraction_id VARCHAR(255) NOT NULL UNIQUE,
    sample_id VARCHAR(255) NOT NULL UNIQUE,
    inventory_date DATE,
    inventory_location VARCHAR(255),
    inventoried_by VARCHAR(255),
    container_type ENUM('Box', 'Plate') NOT NULL,
    container_id VARCHAR(255),
    container_row VARCHAR(5),
    container_column VARCHAR(5),
    notes TEXT,
    CONSTRAINT fk_extraction_id_extractions_archive_plate
        FOREIGN KEY (extraction_id)
		REFERENCES extraction_metadata(sample_id),
    CONSTRAINT fk_sample_id_extractions_archive_plate
        FOREIGN KEY (sample_id)
		REFERENCES sample_metadata(sample_id),
    CONSTRAINT fk_inventoried_by_extractions_archive_plate
        FOREIGN KEY (inventoried_by)
        REFERENCES lab_members(username)
);