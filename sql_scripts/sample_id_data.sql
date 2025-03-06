DELIMITER //

CREATE PROCEDURE GetSampleMetadata(IN sample_id_param INT)
BEGIN
    INSERT INTO sample_id_table
    SELECT * FROM sample_metadata_table WHERE sample_id = sample_id_param;
END //

DELIMITER ;

