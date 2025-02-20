CREATE TABLE lab_members (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(50) NOT NULL UNIQUE,
    user_name VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$'),
    primary_phone_number VARCHAR(20) NOT NULL UNIQUE,
    secondary_phone_number VARCHAR(20) UNIQUE,
    country VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL UNIQUE,
    is_active TINYINT NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);

DELIMITER //

CREATE TRIGGER check_primary_phone_number_format
BEFORE INSERT ON lab_members
FOR EACH ROW
BEGIN
    IF NEW.primary_phone_number NOT REGEXP '^\\+1 [0-9]{3} [0-9]{3}-[0-9]{4}$' -- US Number
       AND NEW.primary_phone_number NOT REGEXP '^\\+33 [0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2}$' -- French Number
       AND NEW.primary_phone_number NOT REGEXP '^\\+258 [0-9]{2} [0-9]{3} [0-9]{4}$' -- Mozambique Number
       -- AND NEW.primary_phone_number NOT REGEXP '^\\+593 [0-9]{2} [0-9]{3} [0-9]{4}$' -- Galapagos Number
       AND NEW.primary_phone_number NOT REGEXP '^\\+63 [0-9]{1,2} [0-9]{3} [0-9]{4}$' THEN -- Philippines Number
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid primary phone number format';
    END IF;
END//

CREATE TRIGGER check_secondary_phone_number_format
BEFORE INSERT ON lab_members
FOR EACH ROW
BEGIN
    IF NEW.secondary_phone_number NOT REGEXP '^\\+1 [0-9]{3} [0-9]{3}-[0-9]{4}$' -- US Number
       AND NEW.secondary_phone_number NOT REGEXP '^\\+33 [0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2}$' -- French Number
       AND NEW.secondary_phone_number NOT REGEXP '^\\+258 [0-9]{2} [0-9]{3} [0-9]{4}$' -- Mozambique Number
       -- AND NEW.secondary_phone_number NOT REGEXP '^\\+593 [0-9]{2} [0-9]{3} [0-9]{4}$' -- Galapagos Number
       AND NEW.secondary_phone_number NOT REGEXP '^\\+63 [0-9]{1,2} [0-9]{3} [0-9]{4}$' THEN -- Philippines Number
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid seconday phone number format';
    END IF;
END//

DELIMITER ;