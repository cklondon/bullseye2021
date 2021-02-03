DROP database IF EXISTS bullseye2021;
CREATE DATABASE IF NOT EXISTS bullseye2021;
USE bullseye2021;

-- ISDP 2021 --


-- CHANGES --
/*
Version 1.0 - Jan 7, 2021
Initial Draft

*/

-------------------
-- Create tables --
-------------------

-------------------
-- Lookup Tables --
-------------------
CREATE TABLE province (
	provinceID VARCHAR(2) PRIMARY KEY,
	provinceName VARCHAR(50) NOT NULL
);

CREATE TABLE transactiontype(
	transactionType VARCHAR(50) PRIMARY KEY
);

CREATE TABLE role(
	roleID INT PRIMARY KEY,
	description VARCHAR(50)
);

CREATE TABLE locationtype (
	locationTypeID VARCHAR(50) PRIMARY KEY
);

CREATE TABLE itemCategory (
	itemCategory VARCHAR(50) PRIMARY KEY
);

CREATE TABLE vehicletype (
	vehicleTypeID VARCHAR(10) PRIMARY KEY,
	description VARCHAR(50) NOT NULL,
	weightLimit DOUBLE NOT NULL,
	costHourly DOUBLE(9,2) NOT NULL,
	costDistance DOUBLE(9,2) NOT NULL,
	note VARCHAR(2000),
	active TINYINT NOT NULL DEFAULT '1'  
);

-----------------
-- Main Tables --
-----------------
CREATE TABLE courier (
	courierID INT AUTO_INCREMENT PRIMARY KEY,
	courierName VARCHAR(50) NOT NULL,
	phone VARCHAR(20),
	email VARCHAR(50),
	contactPerson VARCHAR(80),
	address VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(2) DEFAULT 'NB',
	postalCode VARCHAR(10),
	country VARCHAR(50) DEFAULT 'Canada',
    note VARCHAR(2000),	
	active TINYINT NOT NULL DEFAULT '1',
	FOREIGN KEY (province) REFERENCES province(provinceid)
);

CREATE TABLE supplier(
	supplierID INT AUTO_INCREMENT PRIMARY KEY,
	supplierName VARCHAR(50) NOT NULL,
	phone VARCHAR(50),
	email VARCHAR(50),
	contactPerson VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(2),
	postalCode VARCHAR(10),
	country VARCHAR(50) DEFAULT 'Canada',
	note VARCHAR(2000),
	active TINYINT NOT NULL DEFAULT '1',
	FOREIGN KEY(province) REFERENCES province(provinceID)
);

CREATE TABLE location (
	locationID VARCHAR(4) PRIMARY KEY,
	locationName VARCHAR(50) NOT NULL,
	address VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(2) DEFAULT 'NB',
	postalCode VARCHAR(10),
	country VARCHAR(50) DEFAULT 'Canada',
	phone VARCHAR(50),
	locationType VARCHAR(50),
	note varchar(2000),
	active TINYINT NOT NULL DEFAULT '1',
	FOREIGN KEY (province) REFERENCES province(provinceID),
	FOREIGN KEY (locationType) REFERENCES locationtype (locationTypeID)
);

CREATE TABLE route (
	routeID VARCHAR(9) PRIMARY KEY,
	startLocationID VARCHAR(4),
	destinationLocationID VARCHAR(4),
	distance INT,
	routeTime DOUBLE,
	note VARCHAR(2000),  
	active TINYINT NOT NULL DEFAULT '1',  
	FOREIGN KEY (startLocationID) REFERENCES location (locationID),
	FOREIGN KEY (destinationLocationID) REFERENCES location (locationID)
);

CREATE TABLE user (
    userID INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(50),    
    locationID VARCHAR(4) NOT NULL,
    roleID int NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    note VARCHAR(2000),	
    active TINYINT NOT NULL DEFAULT '1',
	FOREIGN KEY (locationID) REFERENCES location(locationID),
    FOREIGN KEY (roleID) REFERENCES role(roleID)
);

CREATE TABLE item(
	itemid INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(2000),
    itemCategory VARCHAR(50) NOT NULL,
    caseSize INT NOT NULL,
    sku VARCHAR(20) NOT NULL,
    itemName VARCHAR(100) NOT NULL,
    supplierID INT NOT NULL,
    costPrice DOUBLE(9, 2) NOT NULL,
    retailPrice DOUBLE(9, 2) NOT NULL,
    weight DOUBLE(5, 2) NOT NULL,
    note VARCHAR(2000),
	active TINYINT NOT NULL DEFAULT '1',  
    FOREIGN KEY (supplierID) references supplier(supplierID),
    FOREIGN KEY (itemCategory) references itemcategory(itemCategory)
);

CREATE TABLE inventory(
    inventoryid INT AUTO_INCREMENT PRIMARY KEY,
    itemID INT NOT NULL,
    locationID VARCHAR(4) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    reorderAmount INT NOT NULL,
    reorderLevel INT NOT NULL,
    locationInStore VARCHAR(50),
    note VARCHAR(2000),	
    FOREIGN KEY (itemID) REFERENCES item(itemID),
    FOREIGN KEY (locationID) REFERENCES location(locationID)
);

CREATE TABLE txn(
	txnID INT AUTO_INCREMENT PRIMARY KEY,
    txnType VARCHAR(50) NOT NULL,
    vehicleTypeID VARCHAR(10),
    note VARCHAR(2000),	
    FOREIGN KEY (txnType) references transactiontype(transactionType),
    FOREIGN KEY (vehicleTypeID) references vehicletype(vehicleTypeID)
);

CREATE TABLE message (
	messageID INT AUTO_INCREMENT PRIMARY KEY,
	senderID INT NOT NULL,
	receiverID INT,
	startDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	endDate DATETIME,
	details VARCHAR(2000),
	FOREIGN KEY (senderID) REFERENCES user(userID),
	FOREIGN KEY (receiverID) REFERENCES user(userID)
);

CREATE TABLE audit (
    auditid INT AUTO_INCREMENT PRIMARY KEY,
    auditDateTime DATETIME NOT NULL,
    action VARCHAR(50) NOT NULL,
    userID INT NOT NULL,
    transactionID INT NOT NULL,
    description VARCHAR(2000),
    FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (transactionID) REFERENCES txn(txnID)
);

--------------
-- INSERTS --
--------------

-- PROVINCE --
INSERT INTO province VALUES ('AB', 'Alberta');
INSERT INTO province VALUES ('BC', 'British Columbia');
INSERT INTO province VALUES ('MB', 'Manitoba');
INSERT INTO province VALUES ('NB', 'New Brunswick');
INSERT INTO province VALUES ('NL', 'Newfoundland and Labrador');
INSERT INTO province VALUES ('NS', 'Nova Scotia');
INSERT INTO province VALUES ('NT', 'Northwest Territories');
INSERT INTO province VALUES ('NU', 'Nunavut');
INSERT INTO province VALUES ('ON', 'Ontario');
INSERT INTO province VALUES ('PE', 'Prince Edward Island');
INSERT INTO province VALUES ('QC', 'Quebec');
INSERT INTO province VALUES ('SK', 'Saskatchewan');
INSERT INTO province VALUES ('YT', 'Yukon');

-- TRANSACTIONTYPE --
INSERT INTO transactiontype VALUES
('ORDER'),('DELIVERY'),('ONLINEORDER'),('RETURN'),('LOSS'),('BACKORDER'),('SUPPLIERORDER');

-- ITEMCATEGORY --
INSERT INTO itemCategory (itemCategory) VALUES
('Apparel'),('Camping'),('Fitness'),('Footwear'),('Sports Equipment'),('Electronics');

-- LOCATIONTYPE --
INSERT INTO locationtype VALUES
('Retail'),('Corporate'),('Warehouse'),('Vehicle');

-- ROLE --
INSERT INTO role (roleID, description) VALUES
(1, 'Regional Manager'),
(2, 'Financial Manager'),
(3, 'Store Manager'),
(4, 'Warehouse Manager'),
(5, 'Warehouse Employee'),
(6, 'Trucking / Delivery'),
(7, 'Asst Store Manager'),
(999, 'Administrator');

-- VEHICLETYPE --
INSERT INTO vehicletype (vehicleTypeID, description, weightLimit, costHourly, costDistance, note, active) VALUES
('Courier','Courier', '5000', '50.00', '0.00', '',1),
('Heavy','Transport Truck', '10000', '35.00', '3.50', '',1),
('Medium','Medium Truck', '50000', '25.00', '2.50', '',1),
('Small','Small Truck', '3000', '20.00', '1.25', '',1),
('Van','Cube Van', '1000', '10.00', '0.75', '',1);

-- SUPPLIER --
INSERT INTO supplier (supplierID, supplierName, address, city, province, postalCode, country, email, phone, contactPerson, note, active) VALUES
(10000,"Reebok","65 Bluebird Dr","Charlotte","PE","A2V1L6","Canada","jcuster@Reebok.com","5412365874","Jesse Custer","Footwear",1),
(11000,"Spalding","88 Quality St","St George","NB","E5C3N2","Canada","tOhare@Spalding.ca","25655896","Tulip Ohare","",1),
(11111,"Burton","20 Troque St","Montreal","QC","H3B5L1","Canada","jsmith@Burton","5149872222","John Smith","",1),
(22222,"Taylor Made","1841 Argyle St","Halifax","NS","B3J3AS","Canada","sjohnson@TaylorMade.com","6561587896","Smithers Johnson","Golf Snobs use our products!",1),
(33333,"New Balance","44 Acacia Ave","Toronto","ON","M5H2N2","Canada","cdeely@newbalance.com","4547892645","Cat Deely","",1),
(42069,"The Business Factory","65 bizStreet Dr","Saint John","NB","E2L1K8","Canada","itsyaboi@businessFactory.ca","5412365874","Ya Boi","Test Supplier",1),
(44444,"Nike","1701 Knotta Ave","London","ON","N6A4L9","Canada","gennis@Nike.com","2358964785","Garth Ennis","largest shoe dealer",1),
(55555,"Northface","87 Blue st","Saint John","NB","E2L1P1","Canada","wellis@northface","2548963287","Warren Ellis","",1),
(66666,"CCM","9001 Power Lane","Edmonton","AB","T5K2R7","Canada","wgretzsky@ccm","8745875896","Wayne Gretzsky","",1),
(77777,"Bauer","909 Poplar Cove","Fredericton","NB","E8T6P0","Canada","AShearer@Bauer.ca","3579511478","Alan Shearer","",1),
(88888,"Coleman","454 George St","Bordon","NB","E7L4PN","Canada","fdrebbin@Coleman.com","9632147896","Frank Drebbin","",1),
(99999,"Under Armor","189 Frank st","Sussex","NB","E3R5Q0","Canada","jdredd@underarmour.com","3217418965","Joseph Dredd","",1),
(11100,"Apple","252 Technology Drive","Saint John","NB","E4M7Y2","Canada","jrFra@Apple.com","5067831555","John Ralph","Mmmmm, Apples...",1),
(11110,"Garmin","2112 Millenium drive","Vaughan","ON","M4G8Y2","Canada","ChelsDaye@Garmin.com","5064058676","Chelsea Daye","",1),
(11112,"Fitbit","413 Mountain Road","Moncton","NB","E3K4T4","Canada","JeffR@Fitbit.com","5068483092","Jeff Rolof","",1),
(11113,"JBL","122 Industrial Ave","Saint John","NB","E3H4T4","Canada","AnneGladdes@JBL.ca","5067214474","Anne Glades","",1),
(11114,"Go Pro","13 Golem Road","Halifax","NS","B3E1W1","Canada","GladysF@GoPro.com","5067809333","Gladys Finkle","",1);

-- COURIER --
INSERT INTO courier (courierID, courierName, address, city, province, postalCode, country, email, phone, contactPerson, note, active) VALUES
(1, 'ACME', '123 Fourth Street', 'Saint John', 'NB', 'E2E3E3', 'Canada', 'courier@acmecourier.com', '5065551234', 'Fred Flintstone','',1);

-- LOCATION --
INSERT INTO location (locationID, locationName, province, address, city, postalCode, phone, locationType, active) VALUES
('VHCL', 'Truck', 'NB', '1063 Bayside Drive', 'Saint John', 'E2J4Y2', '5066965555', 'Vehicle', 1),
('WARE', 'Warehouse', 'NB', '438 Grandview Avenue', 'Saint John', 'E2J4M9', '5066935555','Warehouse',1),
('CORP', 'Corporate Headquarters', 'NB', '950 Grandview Avenue', 'Saint John', 'E2L3V1', '5066575555','Corporate',1),
('STJN', 'Saint John', 'NB', '519 Westmorland Road', 'Saint John', 'E2J3W9', '5066525555','Retail',1),
('SUSX', 'Sussex', 'NB', '565 Main Street', 'Sussex', 'E4E7H4', '5064335555','Retail',1),
('MCTN', 'Moncton', 'NB', '1380 Mountain Road', 'Moncton', 'E1C2T8', '5063865555','Retail',1),
('DIEP', 'Dieppe', 'NB', '477 Paul Street', 'Dieppe', 'E1A4X5', '5068555555','Retail' ,1),
('OROM', 'Oromocto', 'NB', '273 Restigouche Road', 'Oromocto', 'E2V2H1', '5063575555', 'Retail',1),
('FRED', 'Fredericton', 'NB', '1381 Regent Street', 'Fredericton', 'E3C1A2', '5064555555','Retail' ,1),
('MIRA', 'Miramichi', 'NB', '2441 King George Highway', 'Miramichi', 'E1V6W2', '5066235555', 'Retail',1);

-- USER --
INSERT INTO user 
(userID, firstName, lastName, email, locationID, roleID, userName, password, active) VALUES
(1, 'admin', 'admin', 'noreply@bullseye.com', 'CORP', 999, 'admin', 'admin', 1),
(1001, 'Eduardo', 'Concepcion', 'econcepcion@bullseye.ca', 'CORP', 1, 'econcepcion', 'econcepcion', 1),
(1002, 'Monica', 'Munoz', 'mmunoz@bullseye.ca', 'CORP', 2, 'mmunoz', 'mmunoz', 1),
(1003, 'Chris', 'Patstone', 'cpatstone@bullseye.ca', 'WARE', 2, 'cpatstone', 'cpatstone', 1),
(1004, 'Jose', 'Perez', 'jperez@bullseye.ca', 'STJN', 3, 'jperez', 'jperez', 1),
(1005, 'Kevin', 'Smith', 'ksmith@bullseye.ca', 'STJN', 7, 'ksmith', 'ksmith', 1),
(1006, 'Willow', 'Bray', 'wbray@bullseye.ca', 'DIEP', 3, 'wbray', 'wbray', 1),
(1007, 'Stefani', 'Germanotta', 'sgermanotta@bullseye.ca', 'DIEP', 7, 'sgermanotta', 'sgermanotta', 1),
(1008, 'Thomas', 'Hanks', 'thanks@bullseye.ca', 'FRED', 3, 'thanks', 'thanks', 1),
(1009, 'Louise', 'Ciccone', 'lciccone@bullseye.ca', 'FRED', 7, 'lciccone', 'lciccone', 1),
(1010, 'Arabella', 'Bean', 'abean@bullseye.ca', 'MCTN', 3, '', '', 1),
(1012, 'Declan', 'MacManus', 'dmacmanus@bullseye.ca', 'MCTN', 7, 'dmacmanus', 'dmacmanus', 1),
(1013, 'Bill', 'Clinton', 'bclinton@bullseye.ca', 'MIRA', 3, 'bclinton', 'bclinton', 1),
(1014, 'Erika', 'Atherton', 'eatherton@bullseye.ca', 'MIRA', 7, 'eatherton', 'eatherton', 1),	
(1015, 'John', 'Laurens', 'jlaurens@bullseye.ca', 'OROM', 3, 'jlaurens', 'jlaurens', 1),	
(1016, 'Cathy', 'Jones', 'cjones@bullseye.ca', 'OROM', 7, 'cjones', 'cjones', 1),
(1017, 'Steve', 'Borden', 'sborden@bullseye.ca', 'SUSX', 3, 'sborden', 'sborden', 1),	
(1018, 'Alecia', 'Moore', 'amoore@bullseye.ca', 'SUSX', 7, 'amoore', 'amoore', 1),
(1019, 'Hercules', 'Mulligan', 'hmulligan@bullseye.ca', 'WARE', 5,'hmulligan', 'hmulligan', 1),	
(1020, 'Angelica', 'Schuyler', 'aschuyler@bullseye.ca', 'WARE', 5, 'aschuyler', 'aschuyler', 1),
(1021, 'Aaron', 'Burr', 'aburr@bullseye.ca', 'WARE', 5, 'aburr', 'aburr', 1),	
(1022, 'Eliza', 'Hamilton', 'ehamilton@bullseye.ca', 'WARE', 5, 'ehamilton', 'ehamilton', 1);

-- MESSAGE --
INSERT INTO message (senderID, details) VALUES 
('1001', 'This is a message from Chris. Be careful out there, kids! You are now working with the real thing!!!');

-- ITEM --
-- PUT ITEM INSERTS HERE ---



-- INVENTORY --
-- PUT INVENTORY INSERTS HERE ---

