CREATE TABLE sample_id_data (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	sample_id VARCHAR(255) NOT NULL UNIQUE, 
	project_name VARCHAR(255),
	species VARCHAR(255),
	storage_solution VARCHAR(255),
	CONSTRAINT fk_sample_id_temp FOREIGN KEY (sample_id)
		REFERENCES sample_metadata(sample_id)
		ON DELETE CASCADE	

);

DELIMITER $$
CREATE PROCEDURE inserting_data()

BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE v_sample_id INT;
	DECLARE v_project VARCHAR(255);
	DECLARE v_species VARCHAR(255);
	DECLARE v_storage VARCHAR(255);

	DECLARE sample_cursor CURSOR FOR
		SELECT sample_id FROM sample_metadata;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	OPEN sample_cursor;

	read_loop: LOOP
		FETCH sample_cursor INTO v_sample_id;
		IF done THEN
			LEAVE read_loop;
		END IF;

		SELECT project_name, species, storage_solution
		INTO v_project, v_species, v_storage
		FROM sample_metadata
		WHERE sample_id = v_sample_id;

	
	
		INSERT INTO sample_id_data (sample_id, project_name, species, storage_solution)
		VALUES (v_sample_id, v_project, v_species, v_storage);
	END LOOP;
	CLOSE sample_cursor;
END $$

DELIMITER ;

