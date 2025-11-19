CREATE TABLE extraction_metadata (
    extraction_metadata_id INT AUTO_INCREMENT PRIMARY KEY,
    extraction_id VARCHAR(255) NOT NULL UNIQUE,
    sample_id VARCHAR(255) NOT NULL,
    extraction_date DATE NOT NULL,
    extraction_method VARCHAR(255) NOT NULL,
    amount_of_sample_used DECIMAL(10, 2),
    extractor_name VARCHAR(255) NOT NULL,
    contact INT NOT NULL, 
    notes TEXT,
    CONSTRAINT fk_sample_id_temp_extractions
        FOREIGN KEY (sample_id)
		REFERENCES sample_metadata(sample_id),
    CONSTRAINT fk_sample_owner_extractions
        FOREIGN KEY (contact)
        REFERENCES lab_members(id)
);