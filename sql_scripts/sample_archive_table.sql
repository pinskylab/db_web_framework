CREATE TABLE sample_archive (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sample_id VARCHAR(255) NOT NULL UNIQUE,
    inventory_date DATE,
    inventory_location VARCHAR(255),
    inventoried_by VARCHAR(255),
    inventory_box VARCHAR(255),
    inventory_box_cell VARCHAR(10),
    CONSTRAINT fk_sample_id
        FOREIGN KEY (sample_id)
        REFERENCES sample_metadata(sample_id),
    CONSTRAINT fk_inventoried_by
        FOREIGN KEY (inventoried_by)
        REFERENCES lab_members(username)
);

DELIMITER //

CREATE PROCEDURE archive_samples (
    IN p_sample_id VARCHAR(255),
    IN p_inventory_date DATE,
    IN p_inventory_location VARCHAR(255),
    IN p_inventoried_by_username VARCHAR(255),
    IN p_inventory_box VARCHAR(255),
    IN p_inventory_box_cell VARCHAR(10)
)
BEGIN
    -- DECLARE v_member_id INT;
    -- DECLARE v_sample_id VARCHAR(255);

    -- Retrieve member ID based on username
    -- SELECT id INTO v_member_id
    -- FROM lab_members
    -- WHERE username = p_inventoried_by_username;
    
    -- Retrieve sample ID based on sample ID name
    -- SELECT sample_metadata_id INTO v_sample_id
    -- FROM sample_metadata
    -- WHERE sample_id = p_sample_id;

    -- Insert new record into the 'sample_archive' table
    INSERT INTO sample_archive (
        sample_id,
        inventory_date,
        inventory_location,
        inventoried_by,
        inventory_box,
        inventory_box_cell
    ) VALUES (
        p_sample_id,
        p_inventory_date,
        p_inventory_location,
        p_inventoried_by_username,
        p_inventory_box,
        p_inventory_box_cell
    )
    
    ON DUPLICATE KEY UPDATE
        inventory_date = p_inventory_date,
        inventory_location = p_inventory_location,
        inventoried_by = p_inventoried_by_username,
        inventory_box = p_inventory_box,
        inventory_box_cell = p_inventory_box_cell;
    
END //

DELIMITER ;