CREATE TABLE sample_metadata (
    sample_metadata_id INT AUTO_INCREMENT PRIMARY KEY,
    sample_id VARCHAR(255) NOT NULL UNIQUE,
    project_name VARCHAR(255) NOT NULL,
    species VARCHAR(255) NOT NULL,
    site VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    collection_date DATE NOT NULL,
    collector_name VARCHAR(255) NOT NULL,
    storage_solution VARCHAR(255),
    storage_volume DECIMAL(10, 2),
    tissue_left VARCHAR(255),
    tissue_left_date DATE,
    sample_owner INT NOT NULL, 
    notes TEXT,
    CONSTRAINT fk_sample_owner
        FOREIGN KEY (sample_owner)
        REFERENCES lab_members(id)
);