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

BEGIN

    DECLARE v_sample_id VARCHAR(255);
    DECLARE v_project VARCHAR(255);
    DECLARE v_species VARCHAR(255);
    DECLARE v_storage VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    
    DECLARE sample_cursor CURSOR FOR
        SELECT s.sample_id, m.project_name, m.species, m.storage_solution
        FROM sample_id_data s
        JOIN sample_metadata m ON s.sample_id = m.sample_id;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN sample_cursor;

    read_loop: LOOP
        FETCH sample_cursor INTO v_sample_id, v_project, v_species, v_storage;
        
		IF done = 1 THEN 
            LEAVE read_loop;
        END IF;
        
		
        UPDATE sample_id_data
        SET project_name = v_project, 
            species = v_species, 
            storage_solution = v_storage
        WHERE sample_id = v_sample_id;
    END LOOP;

    CLOSE sample_cursor;
END




BEGIN
	CREATE TEMPORARY TABLE temp_sample_ids (sample_id VARCHAR(255));

    INSERT INTO temp_sample_ids (sample_id)
    SELECT sample_id FROM sample_id_data WHERE sample_id IS NOT NULL;

    DELETE FROM sample_id_data
    WHERE sample_id IN (SELECT sample_id FROM temp_sample_ids);

    DROP TEMPORARY TABLE temp_sample_ids;
END




