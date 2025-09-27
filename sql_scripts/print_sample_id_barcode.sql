CREATE TABLE print_sample_id_barcode (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	sample_id VARCHAR(255) NOT NULL UNIQUE, 
	project_name VARCHAR(255),
	species VARCHAR(255),
	storage_solution VARCHAR(255),
	CONSTRAINT fk_sample_id_temp FOREIGN KEY (sample_id)
		REFERENCES sample_metadata(sample_id)	
);
