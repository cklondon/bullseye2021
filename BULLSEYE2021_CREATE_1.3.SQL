DROP database IF EXISTS bullseye2021;
CREATE DATABASE IF NOT EXISTS bullseye2021;
USE bullseye2021;

-- ISDP 2021 --


-- CHANGES --
/*
Version 1.3 - Jan 11, 2021
Added permissions
Added user_permissions

Version 1.2 - Jan 8, 2021
Added items

Version 1.1 - Jan 8, 2021
Added new suppliers
Added routes

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

CREATE TABLE permission (
	permissionID VARCHAR(50) PRIMARY KEY,
	description VARCHAR(1000)
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
	FOREIGN KEY (province) REFERENCES province(provinceID)
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

CREATE TABLE user_permission (
	userID int,
	permissionID VARCHAR(50),
	PRIMARY KEY(userID, permissionID),
	FOREIGN KEY (userID) REFERENCES user(userID),
    FOREIGN KEY (permissionID) REFERENCES permission(permissionID)	
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

-- PERMISSION --
INSERT INTO permission (permissionID, description) VALUES 
('ADDUSER','Add a new user to the system'),
('EDITUSER','Modify an existing user information in the system'),
('DELETEUSER','Delete an existing user from the system'),
('READUSER','View existing user information'),
('SETPERMISSION','Set or remove an existing user permissions');

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
(11114,"Go Pro","13 Golem Road","Halifax","NS","B3E1W1","Canada","GladysF@GoPro.com","5067809333","Gladys Finkle","",1),
(13333,"Cap","180 Susan St","Sussex","NB","E3R5Q5","Canada","cksmith@cap.com","3217418261","Christina Smith","",1),
(13334,"NordicTrack","129 Fitness St","Fredericton","NB","E3B3H5","Canada","fsthomas@NordicTrack.com","3215411165","Fred Thomas","",1),
(13335,"GoodLife","134 Grand rd","Fredericton","NB","E3B2R7","Canada","labenett@GoodLife.com","3215422265","Lindsay Benett","",1),
(21111,"Clif","14 Green St","Moncton","NB","E2J9B0","Canada","clif@clif.com","8002655099","Richard Lawn","",1),
(21112,"C4","1 Adelaide Street East Suite 2200","Toronto","ON","M5C2V9","Canada","consumeraffairs@jamiesonlabs.com","8002655088","Martin Leth","",1),
(21113,"Jamieson","1658 Bedford Hwy","Bedford","NS","B4A2X9","Canada","jamieson@jamieson.com","8002655088","Tisha Nust","",1),
(21114,"Ener","23 Befferst St", "Toronto","ON","M5C2V1","Canada","consumer@enner.com","8001355088","Mark Usher","",1),
(21115,"Biosteel","567 Mefferon St","Moncton","NB","E2J2L4","Canada","coustomers@biosteel.ca","8004563421","Rodrigez Monco","",1),
(21116,"Vega","3001 Wayburne", "Burnaby","BC","V5G4W3","Canada","customer@vega.ca","8005553133","Lera Moroz","",1),
(21117,"Outcast","42 Milky St","Moncton","NB","E2J7L8","Canada","outcast@outcast.com","8005563421","Chris Nave Jr","",1),
(21118,"Renew","55 Consumers St","Toronto","ON","M5C6J9","Canada","customer@renew.ca","8005563421","Linda Bright","",1),
(21119,"Webber","2000 Brigantine Dr.","Coquitlam","BC","V3K7B5","Canada","customer@webber.ca","8005563421","Margo White","",1),
(21120,"Salus","53 Main St S,","Seaforth","ON","N0K1W0","Canada","service@salus.ca","8005563421","Jackson Hubber","",1),
(21121,"Natural","90 Main St","Fredricton","NB","E3B6T1","Canada","service@natural.com","3215418884","Antony Jornzo","",1),
(21122,"Yeti","400 Westmorland Rd",  "Saint John","NB","E2J2G4","Canada","yetiservice@yeti.ca","8005563421","Martin Droml","",1),
(21123,"Flask","519 Westmorland Rd","Saint John","NB","E2J3W9","Canada","flaskservice@hydroflask.ca","8005563421","Anastasiia Zhukova","",1),
(40104,"Adidas","5 Westmorland Rd","Toronto","ON","M5C4H8","Canada","gswinston@adidas.ca","8005563421","Gary Winston","",1);
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

-- USER_PERMISSION --
INSERT INTO user_permission (userID, permissionID) VALUES 
(1,'ADDUSER'),
(1,'EDITUSER'),
(1,'DELETEUSER'),
(1,'READUSER'),
(1,'SETPERMISSION');

-- MESSAGE --
INSERT INTO message (senderID, details) VALUES 
('1001', 'This is a message from Chris. Be careful out there, kids! You are now working with the real thing!!!');


-- ROUTE --
INSERT INTO route (routeID, startLocationID,destinationLocationID, distance,routeTime, note, active) VALUES 
('MCTN-DIEP', 'MCTN', 'DIEP', 3, 0.50, '',1),
('OROM-FRED', 'OROM', 'FRED', 21, 0.50, '',1),
('WARE-DIEP', 'WARE', 'DIEP', 156, 1.75, '',1),
('WARE-FRED', 'WARE', 'FRED', 118, 1.50, '',1),
('WARE-MCTN', 'WARE', 'MCTN', 149, 1.50, '',1),
('WARE-MIRA', 'WARE', 'MIRA', 296, 3.25, '',1),
('WARE-OROM', 'WARE', 'OROM', 99, 1.25, '',1),
('WARE-STJN', 'WARE', 'STJN', 4, 0.25, '',1),
('WARE-SUSX', 'WARE', 'SUSX', 71, 1.00, '',1);


-- ITEM --
INSERT INTO item (itemName, sku, description, itemCategory, weight, costPrice, retailPrice, supplierID, caseSize, note, active)
VALUES
("Jordan Flight Fleece Black", "CV2366-687", "Black pull over hoodie",'Apparel',  0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Fleece Dark Gray", "CV2366-688", "Dark Gray pull over hoodie", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Fleece Light Gray", "CV2366-689", "Light Gray pull over hoodie", 'Apparel', 0.54, 80.45, 105.99, 44444, 5,NULL, 1),
("Jordan Flight Fleece White", "CV2366-690", "White pull over hoodie", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Fleece Red", "CV2366-691", "Red pull over hoodie", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Hoodie Black", "CV2355-091", "Black zip up hoodie", 'Apparel', 0.53, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Hoodie Dark Gray", "CV2355-092", "Dark Gray zip up hoodie", 'Apparel', 0.53, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Hoodie Light Gray", "CV2355-093", "Light Gray zip up hoodie", 'Apparel', 0.53, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Hoodie White", "CV2355-094", "White zip up hoodie", 'Apparel', 0.53, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Hoodie Red", "CV2355-095", "Red zip up hoodie", 'Apparel', 0.53, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Hoodie Blue", "CV2355-096", "Blue zip up hoodie", 'Apparel', 0.53, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Hoodie Black", "CZ8260-010", "Black fleece pull over hoodie", 'Apparel', 0.55, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Hoodie Dark Grey", "CZ8260-011", "Dark Gray fleece pull over hoodie", 'Apparel', 0.55, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Hoodie Light Gray", "CZ8260-012", "Light Gray fleece pull over hoodie", 'Apparel', 0.55, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Hoodie White", "CZ8260-013", "White fleece pull over hoodie", 'Apparel', 0.55, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Flight Hoodie Red", "CZ8260-014", "Red fleece pull over hoodie", 'Apparel', 0.55, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Fleece Crew Black","CV2370-091", "Black pull over crew sweatshirt.", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Fleece Crew Dark Gray","CV2370-092", "Dark Gray pull over crew sweatshirt.", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Fleece Crew Light Gray","CV2370-093", "Light Gray pull over crew sweatshirt.", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Fleece Crew White","CV2370-094", "White pull over crew sweatshirt.", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Classic Fleece Crew Red","CV2370-095", "Red pull over crew sweatshirt.", 'Apparel', 0.54, 80.45, 105.99, 44444, 5, NULL, 1),
("Jordan Jumpman Air Fleece Trousers Black", "CK6694-091", "Black sweatpants", 'Apparel', 0.34, 44.65, 69.99, 44444, 5, NULL, 1),
("Jordan Jumpman Air Fleece Trousers Gray", "CK6694-092", "Gray sweatpants", 'Apparel', 0.34, 44.65, 69.99, 44444, 5, NULL, 1),
("Jordan Jumpman Air Fleece Trousers Red", "CK6694-093", "Red sweatpants", 'Apparel', 0.34, 44.65, 69.99, 44444, 5, NULL, 1),
("Jordan Jumpman Air Fleece Trousers Dark Gray", "CK6694-094", "Dark Gray sweatpants", 'Apparel', 0.34, 44.65, 69.99, 44444, 5, NULL, 1),
('ASICS Women`s GEL Cumulus 21','12491','Designed to cushion and support your feet over long distances, this shoe boasts FLYTEFOAM Propel technology for excellent bounce and energy.','Footwear',0.24,59.988,99.98,42069,5,'female',1),
('ASICS Women`s Dynablast','12538','The DYNABLAST™ running shoe comfortably wraps the shoe around the foot like a gentle hug.','Footwear',0.205,89.994,149.99,42069,5,'female',1),
('ASICS Women`s Gel Kayano 26','12561','For your all-day comfort - even when running on hard surfaces, the GEL-KAYANO™ 26shoe features rearfoot GEL™ technology redesigned for improved shock absorption.','Footwear',0.195,149.994,249.99,42069,5,'female',1),
('ASICS Women`s Cumulus 20','12318','Designed to accommodate every foot strike with its increased landing surface, the ASICS GEL-Cumulus 20 running shoe for women offers a gentler and more comfortable ride on medium to high-mileage runs.','Footwear',0.255,95.994,159.99,42069,5,'female',1),
('ASICS Women`s GT','12375','Specifically designed to help you go further than you ever thought possible, this ASICS shoe is equipped for big mile runs, providing guidance and comfort each step of the way','Footwear',0.232,101.994,169.99,42069,5,'female',1),
('ASICS Women`s GEL-Kayano 25','12286','the next evolution of ASICS’ ultra-lightweight FlyteFoam® cushioning: FlyteFoam® Propel and FlyteFoam® Lyte.','Footwear',0.207,95.964,159.94,42069,5,'female',0),
('ASICS Women`s GEL Excite 7','12205','The ASICS Women’s GEL Excite 7 Running Shoe is a lightweight offering that introduces an improved fit in the forefoot to generate prolonged comfort no matter the distance.','Footwear',0.245,41.988,69.98,42069,5,'female',1),
('ASICS Women`s GT 1000 7 Mid','12335','Exceptional performance meets incredible value. With its balanced support and guided stability','Footwear',0.269,83.994,139.99,42069,5,'female',1),
('ASICS Women`s GEL - Excite 6 D','12924','The ASICS Women’s GEL - Excite 6 D Running Shoes features a durable midsole material that provides cushion for all day comfort.','Footwear',0.279,47.994,79.99,42069,5,'female',1),
('ASICS Women`s GT-1000 9 D','12939','The GT-1000™ 9 running shoe is the epitome of lightweight comfort that’s also a functional style for runners seeking a stable and supportive ride.','Footwear',0.2821,89.994,149.99,42069,5,'female',1),
('ASICS Women`s GEL Flux 5 Mid','12555','Completely redesigned from the ground up, the new ASICS Women`s GEL Flux 5 Mid Running Shoes steps onto the scene with a secure and breathable seamless upper and more cushioning than ever before.','Footwear',0.2852,62.994,104.99,42069,5,'female',1),
('ASICS Women`s GEL Ziruss 3','12990','Go the distance with the comfort, fit, and technology of the ASICS Women’s GEL Ziruss 3 Running Shoes.','Footwear',0.2883,85.182,141.97,42069,5,'female',1),
('ASICS Men`s Gel Superion 2','12569','Experience an efficient stride and smooth, comfortable ride in the ASICS Men`s Gel Superion 2 Running Shoes.','Footwear',0.2914,89.994,149.99,42069,5,'male',1),
('ASICS Men`s Gel Ziruss 3','12616','The men’s GEL-ZIRUSS™ 3 performance running shoe by ASICS offers a performance boost for any runner who likes to get out on the road.','Footwear',0.2945,113.994,189.99,42069,5,'male',1),
('ASICS Men`s GT 1000 6 Running Shoes','12625','Runners of all levels rely on the GT-1000 6 for its balanced support, enhanced durability and cushioned ride at an incredible value. ','Footwear',0.2916,41.94,69.9,42069,5,'male',1),
('ASICS Men`s Gel Fujitrabuco Lyte Trail','12928','Trail runners who want a lightweight shoe with excellent grip will appreciate the FUJITRABUCO™ Lyte shoe from ASICS. ','Footwear',0.2887,89.994,149.99,42069,5,'male',1),
('ASICS Men`s Gel Infinity Jin','12619','Heritage driven and performance-inspired, the GEL-QUANTUM INFINITY™ JIN sneaker references the evolving lineage of the GEL-KINSEI™ series.','Footwear',0.2858,71.982,119.97,42069,5,'male',1),
('ASICS Men`s Gel Kayano 25','12229','Designed for a lightweight ride, the ASICS Men`s Gel Kayano 25 Running Shoes guarantees high level comfort and stability.','Footwear',0.2829,131.994,219.99,42069,5,'male',1),
('ASICS Men`s Gel Quantum 180 4','12694','The ASICS Men’s Gel Quantum 180 4 Running Shoe is designed for fashion and comfort.','Footwear',0.28,95.994,159.99,42069,5,'male',1),
('ASICS Men`s Gel-Kayano 27 Extra Wide','12263','Enjoy excellent comfort and advanced support with the GEL-KAYANO® 27 (Extra Wide) running shoe.','Footwear',0.2771,131.994,219.99,42069,5,'male',1),
('ASICS Men`s Gel Resolution 8','12442','The GEL-RESOLUTION™ 8 tennis shoe promotes a responsive stride with a close-to-the-court feel. ','Footwear',0.2742,107.994,179.99,42069,5,'male',1),
('ASICS Men`s GT-2000 9 Wide','12353','If you’re looking for a lightweight, cushioned running shoe to help support your foot, the GT-2000® 9 (Wide) model is an excellent choice.','Footwear',0.2713,101.994,169.99,42069,5,'male',1),
('ASICS Men`s GEL-Cumulus 20','12972','A favorite for 20 years and counting. GEL-Cumulus® celebrates its 20th anniversary with premium technology and a refined design that offers optimal support and comfort for runners of all levels.','Footwear',0.2684,95.994,159.99,42069,5,'male',1),
('ASICS Men`s GT 2000 8 2E Wide Width','12509','Promoting a lightweight ride, the ASICS Men’s GT 2000 8 2E Wide Width Running Shoes are designed to provide appropriate comfort and protection for runners in seeking a performance stability shoe.','Footwear',0.2655,101.994,169.99,42069,5,'male',1),
('ASICS Men`s Novablast','12589','The NOVABLAST™ shoe by ASICS is for neutral runners seeking a responsive running experience.','Footwear',0.2626,119.994,199.99,42069,5,'male',1),
('Adidas Men\'s Kaptir Shoes', '751074', 'Explore urban environments in modern style. These shoes have a premium knit upper with sleek details riding on a speedy-looking sculpted midsole. With the comfort of pillow-soft cushioning and a sock-like fit, these running-inspired shoes will help you keep up the pace on city streets.', 'Footwear', 0.45, 35.98, 109.99, 40104, 1, "", 1),
('Adidas Men\'s Duramo SL Running Shoes', '751075', 'Variety keeps you motivated. For running, lifting or playing pickup games, these running shoes are all about versatile comfort. They have a lightweight build with pillow-like cushioning. No-sew overlays support the foot through quick bursts and lateral movements.', 'Footwear', 0.37, 30.98, 94.99, 40104, 1, "", 1),
('Adidas Men\'s X_PLR Shoes', '751076', 'Plan on getting lost in your own city. Bring only the basics for spontaneous exploration. Lightweight adidas X_PLR trainers won’t weigh you down. Take on the urban streets you’ve always been too busy to turn down. Check out your local street art and share your discoveries with friends. Kick off your shoes in a snap at the end of your day with easy elastic laces.', 'Footwear', 0.39, 35.98, 109.99, 40104, 1, "", 1),
('Adidas Men\'s Game Day Running Shoes', '751078', 'Every run leads right up to game day. Keeping that in mind, these versatile adidas shoes feature energised cushioning and a locked-down fit for nimble agility. Underfoot, a turf-inspired outsole delivers great grip no matter where you’re prepping to play.', 'Footwear', 0.39, 35.98, 109.99, 40104, 1, "", 1),
('Adidas Men\'s Lite Racer 3.0 Shoes', '751079', 'From heading to the gym early to hitting the streets for daily activities, these adidas shoes deliver. The slip-on construction gives them a snug and lightweight fit, and the midsole cushioning cradles your foot in cloud-like comfort.', 'Footwear', 0.29, 28.98, 84.99, 40104, 1, "", 1),
('Adidas Men\'s Strutter 2E Training Shoes', '751080', 'The chunky silhouette of these shoes borrows inspiration from celebrated sport styles and delivers the dadliest of street shoes. Ready for wherever the day takes you, they have a smooth leather upper that rides on iconic sculpted tooling and a comfortable rubber outsole. Signature 3-Stripes detailing finishes the look.', 'Footwear', 0.48, 28.98, 84.99, 40104, 1, "", 1),
('Adidas Men\'s X_PLR 2 Shoes', '751081', 'See the city by foot in the X_PLR S. These adidas shoes take the original X_PLR a step further with fresh overlays and a sculpted midsole. Soft EVA cushioning keeps your feet feeling fantastic, even when you’re pounding the toughest pavement.', 'Footwear', 0.39, 35.98, 109.99, 40104, 1, "", 1),
('Adidas Men\'s Fluid Flow Core Running Shoes', '751082', 'Trail, track or treadmill. Get your miles in wherever you can. The venue may change, but the outcome stays the same. Sanity, with a side of sore glutes. The innovative upper of these adidas Fluidflow Shoes moulds to your natural movement, so you can push farther, faster.', 'Footwear', 0.32, 38.98, 119.99, 40104, 1, "", 1),
('Adidas Men\'s Grand Court Shoes - White/Black', '751083', 'A ’70s style reborn. These adidas shoes take inspiration from iconic sport styles of the past and move them into the future. The shoes craft an everyday look with a smooth leather upper. Signature 3-Stripes flash along the sides. Plush midsole cushioning gives comfort to every step.', 'Footwear', 0.48, 28.98, 84.99, 40104, 1, "", 1),
('Adidas Men\'s Cosmic 2 Core Running Shoes - Black/White/Grey', '751084', '_description_', 'Footwear', 0.39, 32.98, 94.99, 40104, 1, "", 1),
('Adidas Men\'s Haiwee Shoes', '751085', 'Stand out. Inspired by adidas’ archive of retro runners, these shoes have a fresh look that still feels adidas. The mesh and synthetic suede upper shows off wavy stitching on the side. Sculpted EVA feels light and comfortable.', 'Footwear', 0.43, 30.98, 89.99, 40104, 1, "", 1),
('Adidas Men\'s Roguera Shoes', '751086', 'Feel the power of the fitness trends of the ’80s. These shoes modernise a classic trainer with all-day style and comfort. They feature a coated leather upper and an iconic twin-cup midsole to give you more spring in your step.', 'Footwear', 0.39, 32.98, 99.99, 40104, 1, "", 1),
('Adidas Men\'s Energy Falcon Dark Training Shoes', '751087', 'Dig deep. These running shoes have a supportive, free-motion design that offers the stability and comfort you need to reach your goals. From the first step, the cushioning feels pillow-soft. The moulded heel allows your Achilles to move freely while a midfoot support panel provides a natural fit. The durable outsole is made to log many miles.', 'Footwear', 0.39, 35.98, 109.99, 40104, 1, "", 1),
('Marvel\'s Spider-Man: Miles Morales Superstar Shoes', '751088', 'Pay homage to a hero in Marvel\'s Spider-Man: Miles Morales Superstar shoes. In collaboration with Marvel, PlayStation, and Insomniac Games, these adidas Superstars take inspiration from the game itself. Miles wears them in the game, and now you can, too. Featuring a black and red design that gives a nod to the iconic suit of Spider-Man and Miles Morales himself. Spider web graphics and PlayStation details bring the story to life.', 'Footwear', 0.39, 39.98, 119.99, 40104, 1, "", 1),
('Adidas Women\'s Response SR Running Shoes', '751089', 'You could go a block. A mile. Maybe three. You’re getting out there, and that’s what counts. Extra points, though, if you’re doing it in these adidas running shoes. They’re breathable and cushioned to help you keep working toward your goals.', 'Footwear', 0.34, 35.98, 109.99, 40104, 1, "", 1),
('Adidas Women\'s Pure Motion Shoes', '751090', 'Your to-do list is long. Match your get-it-done attitude with sleek, comfort-driven style. These adidas trainers take their inspiration from running shoes so you can power through your day with cushioned, foot-hugging comfort.', 'Footwear', 0.27, 29.98, 89.99, 40104, 1, "", 1),
('Adidas Women\'s Solar LT Training Shoes - Grey/White', '751091', 'Whether you’re lifting weights or circuit training, the adidas Women’s Solar LT Training Shoes are lightweight and comfortable. The flexible Bounce midsole provides energised cushioning with every stride to help you stay in the zone. The textile upper has a clean, classic style.', 'Footwear', 0.29, 30.98, 81.99, 40104, 1, "", 1),
('Adidas Women\'s Duramo SL Training Shoes', '751092', 'Take your workout in any direction. These versatile adidas running shoes are ready for the treadmill, the track or extended outdoor workouts. Lightweight mesh and soft cushioning keep you cool and comfortable in warm weather.', 'Footwear', 0.32, 30.98, 94.99, 40104, 1, "", 1),
('Adidas Women\'s Terrex Agravic Light Trail Running Shoes', '751093', 'Control and comfort. Leave the pavement behind in these cushioned adidas Terrex Agravic Trail Running Shoes. They let you move swiftly between smooth ground and rough, rocky terrain. Give your runs endless possibility.', 'Footwear', 0.35, 32.98, 99.99, 40104, 1, "", 1),
('Adidas Women\'s Asweego Training Shoes - Grey/Blue', '751094', 'Shoes with flexibility and responsiveness for multisport training. These shoes have a knit textile upper that hugs the foot for a sock-like fit. Pillow-like midsole cushioning provides long-lasting comfort. Durable rubber inserts at the forefoot and heel provide added grip so you’re ready for unexpected terrain.', 'Footwear', 0.35, 29.98, 85.99, 40104, 1, "", 1),
('Adidas Women\'s Kaptir Shoes', '751095', 'Soften every step in ultra-cushioned comfort. Showcase a sleek, futuristic look as you turn heads while navigating the pavement or the trail in these adidas shoes. A snug fit hugs your foot with every stride.', 'Footwear', 0.33, 33.98, 109.99, 40104, 1, "", 1),
('Adidas Women\'s QT Racer Shoes', '751096', 'Relax with a long walk. These lightweight running-inspired shoes are ready for paved streets or gravel roads. A flexible upper and soft cushioning keep you comfortable on any adventure. Classic adidas details finish the modern look.', 'Footwear', 0.33, 27.98, 65.99, 40104, 1, "", 1),
('Adidas Women\'s Advantage Shoes', '751097', 'Get ready to rally. These tennis-inspired shoes ace modern style and comfort. The smooth leather upper has perforated 3-Stripes. Every step feels ultra-soft, thanks to plush Cloudfoam cushioning.', 'Footwear', 0.38, 30.98, 89.99, 40104, 1, "", 1),
('Adidas Women\'s Nova Flow Training Shoes', '751098', 'Step one. Get outside. Step two. Go. The rest will follow. Work towards increasing your best time in the adidas Nova Flow Shoes. They grip uneven and unpredictable surfaces so you can push forward with confidence. And when the ride is this smooth? Maybe the last mile will feel like the first. Maybe.', 'Footwear', 0.32, 29.98, 99.99, 40104, 1, "", 1),
('Adidas Women\'s Asweego Climacool Running Shoes - White/Grey', '751099', 'Shoes with flexibility and responsiveness for multisport training. These adidas Women’s Asweego Climacool Running Shoe have a mesh upper that hugs the foot for a sock-like fit. Pillow-like midsole cushioning provides long-lasting comfort. Durable rubber inserts at the forefoot and heel provide added grip so you’re ready for unexpected terrain.', 'Footwear', 0.30, 29.98, 89.99, 40104, 1, "", 1),
('Reebok All Sport Athletic Over the Calf Socks', '70047', 'Red Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Red Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70048', 'Black Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Black Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70049', 'Forest Green Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Forest Green Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70050', 'Yellow Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Yellow Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70051', 'Grey Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Black Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70052', 'Lime Green Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Grey Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70053', 'Green Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Green Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70054', 'Navy Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Navy Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70055', 'Orange Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Orange Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70056', 'Purple Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Purple Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70057', 'Dark Red Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Dark Red Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70058', 'Blue Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'Blue Socks', 1 ),
('Reebok All Sport Athletic Over the Calf Socks', '70059', 'White Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'White Socks', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70023', 'Black T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Black T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70024', 'Grey T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Grey T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70025', 'Red T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Red T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70026', 'Brown T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Brown T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70027', 'Yellow T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Yellow T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70028', 'Green T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Green T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70029', 'Blue T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Blue T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70030', 'Teal T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Teal T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70031', 'Purple T-Shirt', 'Apparel', 0.13, 2.99, 14.99, 10000, 6, 'Purple T-Shirt', 1 ),
('Reebok Boys Solid Performance Graphic T-Shirt', '70032', 'White Socks', 'Apparel', 0.06, 1, 9.99, 10000, 6, 'White Socks', 1 ),
('Rain Control Gloves', '30008', 'Black / Dark Gray', 'Apparel', 1, 20, 39.99, 22222, 12, '', 1 ),
('Pro Mens Fitted Sleeveless Shirt', '32535', 'Featuring no sleeves', 'Apparel', 0.2, 14, 28, 44444, 12, '', 1 ),
('Pro Boys Dri-FIT Core Compression Shorts', '34746', 'Boys shorts', 'Apparel', 0.2, 17, 26, 44444, 12, '', 1 );

INSERT INTO item(description, itemcategory, casesize, sku, itemname, supplierid, note, costprice, retailprice, active, weight)
VALUES 
("Hex shape will stop dumbbell from rolling.","Fitness", 4, "E6833","Cap 10 lb Dumbbell Weights", 13333,null, 10.99, 17.99, 1, 4.54),
("Hex shape will stop dumbbell from rolling.","Fitness", 8, "E6834","Cap 5 lb Dumbbell Weights",13333 ,null, 5.99, 8.99, 1, 2.27),
("Hex shape will stop dumbbell from rolling.","Fitness", 8, "E6835","Cap 4 lb Dumbbell Weights",13333 ,null,4.99, 6.99, 1, 1.81),
("Hex shape will stop dumbbell from rolling.","Fitness", 8, "E6836","Cap 3 lb Dumbbell Weights",13333 ,null ,3.99, 4.99, 1, 1.36),
("Hex shape will stop dumbbell from rolling.","Fitness", 12, "E6837","Cap 2 lb Dumbbell Weights",13333, null, 1.99, 2.99,1,  0.90),
("Can be easily adjusted for flat incline and decline bench positions.","Fitness", 1, "E6838","Cap Strength Bench", 13333,null, 69.99, 129.99,1,12.25),
("Comes with 100 lbs weight set.","Fitness", 1, "E6839","Cap Barbell Bench", 13333,null, 69.99, 129.99,1,67.13),
(" Organize your dumbbells effeciently.","Fitness", 2, "E6840","Cap Barbell Dumbbell Rack", 13333, null, 39.99, 74.99, 1 ,5.5),
("Made from steel with plastic grips.","Fitness", 6, "E6841","Cap Spring-lock Collars", 13333 ,null, 5.99, 11.99, 1, 0.13),
("Holds 1\" standard weight plates","Fitness", 4, "E6842","Cap Standard 3 piece Bar 5ft", 13333 ,null, 35.99, 69.99, 1, 5.5),
("Made of solid cast iron with an enamel finish","Fitness", 4, "E6843","Cap Cast 10 lb Kettlebell weight", 13333 ,null, 18.99, 29.99, 1, 4.54),
("Made of solid cast iron with an enamel finish","Fitness", 2, "E6844","Cap Cast 20 lb Kettlebell weight", 13333 ,null, 18.99, 58.99, 1, 2.27),
("Made of solid cast iron with an enamel finish","Fitness", 1, "E6845","Cap Cast 50 lb Kettlebell weight", 13333 ,null, 99.99, 145.99, 1, 22.68),
("Features iFit Personal Training","Fitness", 1, "E6846","NordicTrack C1000 Treadmill",13334, null, 1399.99, 3299.99, 1, 90.72),
("Features iFit Personal Training","Fitness", 1, "E6847","NordicTrack C960i Treadmill",13334, null, 999.99, 2999.99, 1, 101.60),
("Features a Multi-window LED display ","Fitness", 1, "E6848","NordicTrack C700 Treadmill",13334, null, 899.99, 2699.99, 1 ,88.90),
("Features a Multi-window LED display ","Fitness", 1, "E6849","NordicTrack C1750 Treadmill",13334, null, 1999.99, 4699.99, 1 ,133.81),
("Durable, provides light resistance","Fitness", 10, "E6850","Cap Elastic Bands",13333, null, 3.99, 8.99, 1 ,0.38),
("55 cm in diameter","Fitness", 6, "E6851","GoodLife Exercise Ball",13335, null, 14.99, 22.99, 1 ,1.48),
("non-slip surface","Fitness", 4, "E6852","GoodLife Stepper",13335, null, 17.99, 44.99, 1 ,3.1),
("Easy grip non-slip handles","Fitness", 6, "E6853","GoodLife Ab Wheel",13335, null, 6.99, 15.99, 1 ,0.7),
("Length:9ft","Fitness", 8, "E6854","GoodLife Speed Rope",13335, null, 3.99, 9.99, 1 ,0.10),
("Easy grip non-slip handles","Fitness", 4, "E6855","GoodLife Push Up Handle",13335, null, 20.99, 35.99, 1 ,0.85),
("Easy to assemble.","Fitness", 8, "E6856","GoodLife Mini Trampoline",13335, null, 35.99, 59.99, 1 ,5),
("Adustable handles for comfort","Fitness", 4, "E6857","GoodLife 3-in-1 Resistance Bands",13335, null, 8.99, 19.99, 1 ,0.64),
('Electronic wristwatch', 'Electronics', 10, '60000', 'Fitbit Inspire 2 Fitness Tracker', 11112, '', 99.99, 129.99, 1, 1.0),
('Electronic wristwatch', 'Electronics', 10, '60001', 'Fitbit Versa 3', 11112, '', 199.99, 299.99, 1, 1.5),
('Electronic wristwatch', 'Electronics', 10, '60002', 'Fitbit Sense', 11112, '', 349.99, 429.99, 1, 1.0),
('Electronic wristwatch', 'Electronics', 10, '60003', 'Fitbit Ace 2 for Kids', 11100, '', 69.99, 99.99, 1, 0.8),
('Electronic wristwatch', 'Electronics', 10, '60004', 'Apple Watch Series 6', 11100, '', 29.99, 699.00, 1, 1.0),
('Electronic wristwatch', 'Electronics', 10, '60005', 'Apple Watch Nike SE', 11100, '', 249.99, 369.00, 1, 1.0),
('Electronic wristwatch', 'Electronics', 10, '60006', 'Apple Watch SE GPS', 11100, '', 369.99, 409.00, 1, 1.0),
('Wrist strap for electronic wristwatch', 'Electronics', 10, '60007', 'Apple Watch 44mm Wrist Strap', 11100, '', 69.99, 119.99, 1, 0.8),
('Charging cable for electronic wristwatch', 'Electronics', 10, '60008', 'Apple Watch Magnetic Charging Cable', 11100, '', 24.99, 39.99, 1, 0.5),
('Power adapter wall plugin for charging electronic devices', 'Electronics', 10, '60009', 'Apple 12W USB Power Adapter', 11100, '', 12.99, 25.99, 1, 2.0),
('Power adapter wall plugin for charging electronic devices', 'Electronics', 10, '60010', 'Apple 5W USB Power Adapter', 11100, '', 12.99, 25.99, 1, 1.0),
('Wrist strap for electronic wristwatch', 'Electronics', 10, '60011', 'Apple Watch 44mm Nike Edition Wrist Strap', 11100, '', 29.99, 59.99, 1, 0.5),
('Wireless headphones that are needlessly expensive', 'Electronics', 10, '60012', 'Apple Airpods with Charging Case', 11100, '', 99.99, 219.99, 1, 1.0),
('Wireless headphones', 'Electronics', 10, '60013', 'Apple Airpods Pro with Charging Case', 11100, '', 100.00, 329.99, 1, 1.0),
('Wireless headset', 'Electronics', 10, '60014', 'Apple Airpods Max Headphones', 11100, '', 199.99, 779.99, 1, 4.0),
('Electronic wristwatch', 'Electronics', 10, '60015', 'Apple Watch Series 3 GPS', 11100, '', 199.99, 299.99, 1, 1.0),
('A portable, miniature camera for on the go', 'Electronics', 10, '60016', 'GoPro Hero9 Black Action Camera', 11114, '', 499.99, 599.99, 1, 2.0),
('A portable, miniature camera with 360 degree view', 'Electronics', 10, '60017', 'GoPro MAX Action Camera', 11114, '', 599.99, 669.99, 1, 2.0),
('A portable speaker', 'Electronics', 10, '60018', 'Beats Pill Portable Speaker', 11100, '', 129.99, 189.99, 1, 5.0),
('Wired headphones', 'Electronics', 10, '60019', 'urBeats3 Earphones with 3.5mm Plug', 11100, '', 29.99, 59.99, 1, 1.0),
('Wireless noise cancelling headset', 'Electronics', 10, '60020', 'Beats Solo Pro Wireless Noise Cancelling Headphones', 11100, '', 229.99, 284.99, 1, 3.0),
('Wireless headset', 'Electronics', 10, '60021', 'Beats Solo3 Wireless On-Ear Headphones', 11100, '', 129.99, 187.99, 1, 3.0),
('Wireless behind the head headphones', 'Electronics', 10, '60022', 'Powerbeats Wireless Earphones', 11100, '', 99.99, 149.99, 1, 2.0),
('Wireless headphones', 'Electronics', 10, '60023', 'Powerbeats Pro Totally Wireless Earphones', 11100, '', 199.99, 249.99, 1, 1.0),
('GoPro accessory for holding with swivel', 'Electronics', 10, '60024', 'GoPro Magnetic Swivel Clip', 11114, '', 24.99, 34.99, 1, 1.0),
('Pairable with any apple device, these headphones are completely wireless and come with a charging case.','Electronics',50,'60025','Apple Airpods 2nd Gen',11100,'Comes With Charging Case',95.00,179.95,1,0.25),
('Beats Solo 3 provides excellent sound quality at a very reasonable price! with 40 hours of battery life, one charge can last you days at a time','Electronics',30,'60026','Beats Solo 3 Wireless',11100,'',75.00,185.00,1,0.5),
('JBL is known for superior sound equipment and the Wireless headphones are no exception.','Electronics',30,'60027','JBL Wireless On Ear Headphones',11113,'',50.00,95.00,1,0.5),
('Waterproof Bluetooth speaker with exceptional quality sound','Electronics',15,'60028','JBL Bluetooth Speaker',11113,'',75.00,150.00,1,1),
('The JBL Charge 4 comes with a built in powerbank and powerful sound','Electronics',10,'60029','JBL Charge 4',11113,'',125.00,250.00,1,2),
('High performance bluetooth headphones','Electronics',5,'60030','Powerbeats Pro',11100,'',125.00,250.00,1,0.25),
('Rugged Satellite Communicator for anywhere exploring','Electronics',1,'60031','Garmin inReach Explorer+',11110,'High price item',250.00,495.00,1,3),
('Durable, and easy to use','Electronics',15,'60032','Garmin etrex',11110,'',125.00,250.00,1,3),
('Easy to use, accurate mapping','Electronics',15,'60033','Garmin GPS Map',11110,'',200.00,395.00,1,3),
('Built for tough treks','Electronics',1,'60034','Garmin 66I',11110,'high price item',410.00,820.00,1,3),
('Classy and durable','Electronics',5,'60035','Garmin Instinct',11110,'',150.00,295.00,1,0.25),
('Sleek and Subtle Fitness Tracker','Electronics',10,'60036','Garmin Forerunner',11110,'',100,195.00,1,0.25),
('Excellent fitness tracker option','Electronics',10,'60037','Garmin vivoactive 4',11110,'',200.00,400.00,1,0.25),
('Capture all of your sporting activity','Electronics',1,'60038','Go Pro Hero 8 bundle',11114,'High price Item',260.00,520.00,1,5),
('Stunning HD Quality Camera','Electronics',1,'60039','GoPro MAX',11114,'High Price Item',330.00,660.00,1,2),
('Charge at a rapid pace!','Electronics',50,'60040','Go Pro Super Charger',11114,'',2.50,10.00,1,0.5),
('Charge multiple batteries at once!','Electronics',25,'60041','GoPro Dual Battery Charger Battery',11114,'',35.00,70.00,1,4),
('Take your videos from any angle','Electronics',50,'60042','GoPro Shorty Extension Pole',11114,'',25.00,50.00,1,1),
('Sleek and subtle carrying sleeve with a strap','Electronics',30,'60043','GoPro Sleeve+ Lanyard',11114,'',12.00,25.00,1,1),
('Mount your GoPro Anywhere!','Electronics',40,'60044','GoPro Jaws Flex Clamp',11114,'',10.00,19.95,1,1),
('Slim and barely noticable on your wrist fitness tracker','Electronics',20,'60045','Garmin VivoSmart',11110,'',95.00,195.00,1,0.25),
('Professional Sound Quality, wireless Capability.','Electronics',20,'60046','Apple Airpods Pro',11110,'',150.00,300.00,1,0.5),
('Portable and powerful.','Electronics',40,'60047','JBL Clip 3',11113,'',45.00,95.00,1,2),
('Wireless headphones with LEDS','Electronics',30,'60048','JBL UnderArmound Flash Wireless',11113,'',125.00,250.00,1,0.25),
('Professional noise cancelling headphones','Electronics',20,'60049','Beats Solo Pro',11110,'',140.00,280.00,1,2),
 ("Strawberry taste.", "Fitness", 1, "V0001", "Clif Shot Bloks Strawberry", 21111, "no special notes", 1, 2.17, 1, 0.2),
 ("Workout Blue Raspberry.", "Fitness", 1, "V0002", "C4 Sport Pre", 21112, "no special notes", 8, 22.17, 1, 0.9),
 ("Honey.", "Fitness", 1, "V0003", "Honey Stingers Organic", 21111, "no special notes", 0.5, 1.87, 1, 0.1),
 ("Lemon Lime.", "Fitness", 1, "V0004", "Nuun Sport", 21111 , "no special notes", 2, 7.29, 1, 0.2),
 ("B12.", "Fitness", 1, "V0005", "Jamieson B12 5X Stronger", 21113, "no special notes", 3, 11.24, 1, 0.1),
 ("Gummies with different taste contain Vitamins A, B6, B12, C, D3 and E as well as essential minerals.", "Fitness", 1, "V0006", "Jamieson Gummies Multi", 21113, "no special notes", 3, 11.99, 1, 0.3),
 ("Ener-C is a Non-GMO certified effervescent multivitamin drink mix in convenient dose sachets.", "Fitness", 1, "V0007", "Ener-C Multivitamin Drink Mix 30 Pack - Variety Pack", 21114, "no special notes", 9, 14.99, 1, 0.2),
 ("A protein blend containing high quality sources of protein that are easily absorbed by the body.", "Fitness", 1, "V0008", "Biosteel Whey Protein Blend Vanilla - 750g Tub - 24g Protein", 21115, "no special notes", 14, 37.49, 1, 0.7),
 ("Made from carefully selected, premium, plant-based food ingredients you’d choose yourself if you had the time, Vega One has everything you want (and nothing you don’t)—all in one delicious scoop.e", "Fitness", 1, "V0009", "Vega One Shake Chocolate - 876G", 21116, "no special notes",20, 52.99, 1, 0.8),
 ("A plant based protein powder that uses upcycled locally sourced produce and helps save the planet. Infused with micronutrients and 20g protein in every scoop.", "Fitness", 1, "V0010", "Outcast Foods Plant Strong Protein, Vanilla", 21117, "no special notes",16,  48.99, 1, 0.2),
 ("Jamieson 10 Billion is a daily probiotic which has 14 unique strains for complete intestinal and digestive health. This probiotic balances intestinal microflora for overall digestive and immune health, the two main benefits that come from healthy bacteria in the gut.", "Fitness", 1, "V0011", "Jamieson Probiotic 10 Billion Essentials", 21113, "no special notes", 5, 17.24, 1, 0.1),
 ("DigestMORE ULTRA is a therapeutic strength enzyme formula designed for those whose digestive problems occur on a daily basis, or are serious in nature. ", "Fitness", 1, "V0012", "Renew Life Digestmore Ultra (60'S)", 21118, "no special notes",8.49,  26.49, 1, 0.05),
 ("Probiotic 5 Billion with 200 mg Cranberry from Webber Naturals is specially formulated to help re-establish protective probiotic gastrointestinal and vaginal microflora and to provide urinary tract support.", "Fitness", 1, "V0013", "Webber Naturals Probiotic 5 Billion With 200 Mg Cranberry 45 Vegetarian Capsules", 21119, "no special notes", 3,12.74, 1, 0.2),
 ("Magnesium Bisglycinate from Webber Naturals is a more absorbable form of magnesium that is calming and gentle on the digestive system.", "Fitness", 1, "V0014", "Webber Naturals Magnesium Bisglycinate 200 Mg 60 Vegetarian Capsules", 21119, "no special notes", 2, 10.49, 1, 0.02),
 ("Floradix is the best Natural liquid Iron Supplement in North America. It helps fight back against Iron deficiency by promoting the formation of healthy red blood cells.", "Fitness", 1, "V0015", "Salus Floradix Formula Iron Tablets 80's", 21120, "no special notes", 5, 17.24, 1, 0.2),
 ("Natural Calm Magnesium Citrate Powder. The Better-Tasting, Better-Absorbing, Best-Loved Magnesium Drink.", "Fitness", 1, "V0016", "Natural Calm 226G - Organic Lemon Flavour", 21121, "no special notes", 8, 22.49, 1, 0.2),
 ("Keep that perfect balance of flavour and fuel by your side with YETI’s new 10oz. Tumbler - sized to be just enough for just about anywhere.", "Fitness", 1, "V0017", "YETI Rambler 10oz Tumbler", 21122, "no special notes", 10, 24.99, 1, 0.2),
 ("From office to trail, this tall drink of water will go anywhere you go – and will provide 24 ounces of pure refreshment along the way.", "Fitness", 1, "V0018", "Hydro Flask 24 oz Standard Mouth Water Bottle - Black", 21123, "no special notes", 15, 41.99, 1, 0.2),
 ("Big enough for a whole day on the river or trails, our 32 oz Wide Mouth Bottle is made with professional-grade stainless steel and a wider opening for faster fill.", "Fitness", 1, "V0019", "Hydroflask 32 oz Wide Mouth Bottle", 21123, "no special notes", 17, 47.99, 1, 0.2),
 ("Keep life moving with our 21 oz bottle and Standard Flex Cap. It stashes easily into a small shoulder bag, your pack’s side pocket, or your car cup holder, and holds enough ice cold goodness to keep you going for hours without weighing you down. ", "Fitness", 1, "V0020", "Hydroflask 21 oz Standard Mouth Bottle", 21123, "no special notes", 10, 39.99, 1, 0.2),
 ("The Rambler® 26 oz. Bottle is the goldilocks of our bottle line, perfect all day, every day. With a quick twist, the TripleHaul™ handle comes off, exposing our shatter-resistant, dishwasher safe spout that allows for controlled gulps on the go. ", "Fitness", 1, "V0021", "YETI Rambler 26 oz Chug Bottle", 21122, "no special notes", 20, 54.99, 1, 0.2),
 ("Nike 24 oz Hyperfuel Water Bottle - Blue Fury.", "Fitness", 1, "V0022", "Nike 24 oz Hyperfuel Water Bottle - Blue Fury", 44444, "no special notes", 5, 13.99, 1, 0.2),
 ("The Nike Hyperfeul Waterbottle features a leakproof puff valve spout which provides a quick flow of water for instantaneous hydration and prevents leaking when not in use.", "Fitness", 1, "V0023", "Nike 18 oz Hyperfuel Water Bottle - Black", 44444, "no special notes", 3, 11.99, 1, 0.2),
 ("The Nike Double Flask Belt features two 10oz lightweight flasks to keep you hydrated on your run that are easy to access when you need to hydrate.", "Fitness", 1, "V0024", "Nike 20 oz Double Pocket Flask Belt - Grey/Black", 44444, "no special notes", 11, 39.99, 1, 0.2),
 ("Stay hydrated throughout your run with the Nike Large 22 .Oz - bottle belt. The form-fitting shape and stabilised design curves to your body and reduces bounce as you work out. ", "Fitness", 1, "V0025", "Nike 22 oz Large Bottle Belt- Black", 44444, "no special notes", 9, 34.99, 1, 0.2);

INSERT INTO item 
(description, itemcategory, casesize, sku, itemname, supplierid, note, costprice, retailprice, active, weight) 
VALUES
("Fit for any training regime, Reebok Fitness Gloves deliver comfort and grip for top performance. Made from breathable Lycra with an Amara suede palm, the gloves combine protection with a natural feel for weighted and bodyweight workouts.", "Sports Equipment", 12, 10450, "Reebok Fitness Gloves", 10000, NULL, 70.99, 30.99, 1, 0.0881),
("The timeless aerobic Reebok Step remains an integral and immensely popular piece of equipment in the group fitness exercise arena.", "Sports Equipment", 4, 10451, "Reebok Professional Aerobic Step", 10000, NULL, 135.55, 43.99, 1, 16.75),
("The Reebok deck enables you to perform effective cardio workouts based on aerobic stepping, plus it can convert into a flat, incline or decline weight bench for strength training and conditioning.", "Sports Equipment", 4, 10452, "Reebok Professional Deck Workout Bench", 10000, NULL, 287.00, 54.89, 1, 27.99),
("Skateboard-inspired work shoe.", "Sports Equipment", 12, 10453, "Reebok Men Soyay Shoes", 10000, NULL, 174.55, 59.99, 1, 1),
("High quality green yoga mat", "Sports Equipment", 12, 10454,"Reebok Fitness Yoga Mat", 10000, NULL, 49.99, 14.99, 1, 2.11),
("Polyester and Spandex XL Shoe size 12-13 (EURO 45-46)", "Sports Equipment", 12, 10456,"Reebok Senior Hockey Socks", 10000, NULL, 8.99, 4.00, 1, 0.099),
("93% CO/7% EL-Single jersey-enzyme finish / coating - silicone", "Sports Equipment", 8, 10457,"Reebok Women workout Bra", 10000, NULL, 33.55, 12.88, 1, 0.19),
("Reebok Royal Pervader Shoes. Running-inspired shoes with a modern, fast-paced style.", "Sports Equipment", 12, 10458,"Reebok women Royal Running Shoes", 10000, NULL, 61.55, 33.99, 1, 1.54),
("Always Training - TRAINING IS NOT JUST ONE THING. IT'S BOOT CAMP, IT'S HIIT AND IT'S CIRCUIT TRAINING, IT'S THE REGIMEN WE MALE UP OURSELVES.", "Sports Equipment", 12, 10459,"Reebok CrossFit 8.0 Training Shoes", 10000, NULL, 102.05, 45.99, 1, 18.4),
("With an elasticated fit to keep your hair under control, the silicone lining reduces slippage for total focus. Fit for all sports and training styles; the one size bands fit snug to your head to defeat irritation.", "Sports Equipment", 24, 10460,"Reebok Sports Hair Bands", 10000, NULL, 30, 9.99, 1, 0.04),
("Reebok Men Active Running Shorts are the choice for a lightweight performance short. Excel in your training with exercise wear that is versatile and affordable.", "Sports Equipment", 12, 10461,"Reebok Men Drawstring Shorts", 10000, NULL, 24.88, 19.00, 1, 0.41),
("Made from shatter-proof Tritan material, the Wide Mouth Bottle keeps you hydrated for top performance.", "Sports Equipment", 6, 10462,"", 10000, NULL, 24, 13, 1, 0.30),
('The helmet is white and is size large. Reebok recommends this goalie mask for a person with a head circumference of 21.5"-24.5" and a hat size of 6 7/8" - 7 3/4".', "Sports Equipment", 6, 10463,"Reebok Ice Hockey Helmet 9k PRO", 10000, NULL, 443.99, 219.99, 1, 1.3),
("The Reebok professional core board provides an UNSTABLE platform that can be used by both beginners and advanced users to help improve strength and function of the core muscles with its ability to tilt, twist and recoil against the body natural movements.", "Sports Equipment", 3, 10464,"Reebok core board", 10000, NULL,200.79, 94.99, 1, 30.4),
("The 2-in-1 design features breathable, built-in mesh tights for full coverage as you dominate your opponent. The top layer has a slim, stretchy fit elevated by textured knit material.", "Sports Equipment", 12, 10465,"Reebok Combat Kickboxing Shorts", 10000, NULL, 49.33, 21.99, 1, 0.30),
("Reebok has teamed up with dynamic to produce these high-quality medicine balls. Both brands are very well known in the cross-fit arena and beyond.", "Sports Equipment", 8, 10466,"Reebok Soft-Shell Medicine Ball", 10000, NULL, 89.77, 44.99, 1, 4.11),
("The mouth guard is a kids size designed for ages 5-10. This mouth guard has a strap to attach to a facemask for hockey, football etc.", "Sports Equipment", 6, 10467,"Reebok Smart Kids Mouth guard", 10000, NULL, 8.99, 6.99, 1, 0.16),
("Reebok Boxing Gloves - Gold/White, 14oz", "Sports Equipment", 4, 10468,"Reebok Boxing Gloves", 10000, NULL, 57.72, 43.99, 1, 1.7),
("Available in 10 oz, 12 oz, 14 oz and 16 oz weights, the gloves cater for all needs, abilities and applications.", "Sports Equipment", 4, 10469,"Reebok Combat Leather Training Gloves", 10000, NULL,94.55, 33.33, 1, 1.6),
("Reebok Kettlebell - 40lb", "Sports Equipment", 2, 10470,"Reebok Kettlebell", 10000, NULL, 175, 43.99, 1, 39.9),
('Standard sleeping bag, colour = blue', 'Camping', 3, '8000001', 'Blue Nike Sleeping Bag', '44444', NULL, 10.99, 19.99, 1, 10.0),
('Standard sleeping bag, colour = green', 'Camping', 3, '8000002', 'Green Nike Sleeping Bag', '44444', NULL, 10.99, 19.99, 1, 10.0),
('Standard sleeping bag, colour = red', 'Camping', 3, '8000003', 'Red Nike Sleeping Bag', '44444', NULL, 10.99, 19.99, 1, 10.0),
('A standard tent that fits 4 adults, colour = blue', 'Camping', 2, '8000005', 'Blue 4 Person Nike Tent', '44444', NULL, 35.99, 89.99, 1, 15.0),
('A standard tent that fits 8 adults, colour = red', 'Camping', 2, '8000006', 'Red 8 Person Nike Tent', '44444', NULL, 49.99, 139.99, 1, 20.0),
('A standard tent that fits 10 adults, colour = green', 'Camping', 1, '8000007', 'Green 10 Person Nike Tent', '44444', NULL, 59.99, 159.99, 1, 12.0),
('A standard twin air mattress with a hand pump', 'Camping', 3, '8000008', 'Nike Twin Air Mattress', '44444', NULL, 15.99, 59.99, 1, 4.0),
('A standard double air mattress with a hand pump', 'Camping', 3, '8000009', 'Nike Double Air Mattress', '44444', NULL, 19.99, 89.99, 1, 6.0),
('Standard 4 quad camping chair, colour = blue', 'Camping', 6, '8000010', 'Blue Nike Camping Chair', '44444', NULL, 8.99, 24.99, 1, 12.0),
('Standard 4 quad camping chair, colour = red', 'Camping', 6, '8000011', 'Red Nike Camping Chair', '44444', NULL, 8.99, 24.99, 1, 12.0),
('Standard size basketball', 'Sports Equipment', 6, '8000012', 'Nike Regulation Basketball', '44444', NULL, 15.99, 45.99, 1, 4.0),
('Childrens size basketball', 'Sports Equipment', 6, '8000013', 'Nike Childrens Basketball', '44444', NULL, 8.99, 24.99, 1, 2.0),
('Standard metal bat with a leather grip', 'Sports Equipment', 4, '8000015', 'Nike Metal Baseball Bat', '44444', NULL, 25.99, 89.99, 1, 8.0),
('Standard size soccer ball, colour = black/white', 'Sports Equipment', 6, '8000016', 'Nike Soccer Ball', '44444', NULL, 15.99, 45.99, 1, 6.0),
('Large soccer net, made of plastic', 'Sports Equipment', 2, '8000017', 'Nike Soccer Net', '44444', NULL, 29.99, 105.99, 1, 10.0),
('Adjustable height basketball net, 6ft-10ft', 'Sports Equipment', 1, '8000018', 'Nike Basketball Net', '44444', NULL, 159.99, 599.99, 1, 100.0),
('6ft childrens basketball net, non-adjustable', 'Sports Equipment', 1, '8000019', 'Nike Childrens Basketball Net', '44444', NULL, 59.99, 169.99, 1, 35.0),
('Standard hockey puck', 'Sports Equipment', 12, '8000020', 'Nike Hockey Puck', '44444', NULL, 0.59, 3.99, 1, 12.0),
('Standard baseball', 'Sports Equipment', 12, '8000021', 'Nike Baseball', '44444', NULL, 1.99, 5.99, 1, 8.0),
('Pack of 12 standard golf balls', 'Sports Equipment', 12, '8000022', 'Nike Golf Balls', '44444', '', 9.99, 58.99, 1, 12.0),
("Simple shade provides sun protection and makes the ultimate tent porch.","Camping",1,"NF0A3GAD","Homestead Sun Shade",55555,NULL,179.99,209.99,1,20.53),
("Protect your gear from wet weather with this lightweight, packable rain cover that's crafted with fully taped seams and an adjustable elastic closure for a secure fit around your pack.","Camping",10,"CA7Z","Pack Rain Cover",55555,NULL,5.99,17.99,1,1.23),
("Durable technical pack for lightweight comfort on multi-day excursions.","Camping",1,"NF0A3GA6","Terra 55 Backpack",55555,NULL,129.99,229.99,1,7.35),
("Bulk-free technical pack made lighter for all-day comfort on the move.","Camping",1,"NF0A3GA5","Terra 65 Backpack",55555,NULL,149.99,249.99,1,9.15),
("Modeled after our Backcountry 91 Pack, the water-repellant, durable Steep Tech Pack has exterior shovel and ice axe carries, an interior probe carry and a top-lid goggle pocket.","Camping",1,"NF0A4SJ3","Steep Tech Pack",55555,NULL,99.99,169.99,1,3.15),
("The North Dome Chalk Bag is athlete-designed for simple yet secure chalk access, when you need it most.","Camping",5,"NF0A3S6W","North Dome Chalk Back",55555,NULL,9.99,39.99,1,3.65),
("The 100%-recycled North Dome Rope Bag is impeccably designed to deliver convenient, sustainable storage for your exploration.","Camping",1,"NF0A3S6U","North Dome Rope Bag",55555,NULL,99.99,199.99,1,2.15),
("This is not your average duffel. It's bomber. Our burly Base Camp Duffel is made from a durable laminate material that can handle rough rides around the globe.","Camping",1,"NF0A3ETP","Base Camp Duffel-M",55555,NULL,59.99,159.99,1,3.8),
("This is not your average duffel. It's bomber. Our burly Base Camp Duffel is made from a durable laminate material that's ready to be roughed around in-flight, or to be transported up a mountain via a yak.","Camping",1,"NF0A3ETQ","Base Camp Duffel-L",55555,NULL,79.99,179.99,1,4.9),
("This is not your average duffel. It’s bomber. Our burly Base Camp Duffel is made from a durable laminate material that stands up to the roughest days of travel.","Camping",1,"NF0A3ETO","Base Camp Duffel-L",55555,NULL,39.99,139.99,1,2.11),
("This is not your average duffel. It's bomber. Our burly Base Camp Duffel is made of a durable laminate material that's ready to be roughed around in-flight, or transported up a mountain via a yak.","Camping",1,"NF0A3ETR","Base Camp Duffel-XL",55555,NULL,99.99,199.99,1,4.69),
("This is not your average duffel. It’s bomber. Our burly Base Camp Duffel is made from a durable laminate material that holds up to the roughest days of travel.","Camping",1,"NF0A3ETN","Base Camp Duffel-XS",55555,NULL,19.99,119.99,1,2.08),
("This is not your average duffel. It’s bomber. Our burly Base Camp Duffel is made of a durable laminate material that's ready to be roughed around in-flight, or transported up a mountain via a yak.","Camping",1,"NF0A3ETS","Base Camp Duffel-XXL",55555,NULL,109.99,209.99,1,4.90),
("The Travel Duffel Pack is an easy-to-love travel companion, with padded shoulder straps, easy-access storage and unmistakable old-school vibes.","Camping",1,"NF0A3KZP","Travel Duffel Pack",55555,NULL,29.99,129.99,1,2.02),
("Tough-as-hell backpack with a massive main compartment for your everyday use that features a dedicated compartment for shoes and laundry.","Camping",1,"NF0A3KYE","Explore Haulaback backpack S",55555,NULL,89.99,189.99,1,3.7),
("Durable duffel for hauling everything you need without the extra weight.","Camping",1,"NF0A3KWP","Flyweight Duffel",55555,NULL,34.99,74.99,1,1.35),
("Travel fearlessly knowing your skis or snowboard are protected from harsh conditions in this roller bag that’s practically bombproof.","Camping",1,"NF0A3KWP","Base Camp Snow Roller Bag",55555,NULL,199.99,299.99,1,9.4),
("The new Rolling Thunder is the perfect companion for a week or two abroad. The self-cleaning wheels, ample internal space, external pockets and tough frame make this 80-liter capacity bag equipped to take you (and your gear) around the world.","Camping",1,"NF0A3C93","Rolling Thunder-30",55555,NULL,269.99,369.99,1,9.14),
("Small but mighty, the new Rolling Thunder—22” will be the toughest piece of carry-on luggage in the overhead bin during any weekend getaway.","Camping",1,"NF0A3C94","Rolling Thunder-22",55555,NULL,219.99,319.99,1,7.55),
("Ready to go from the mountain cabin to the boardroom, our new, 75-liter capacity clamshell suitcase is crafted of our extra-tough Base Camp material for streamlined durability.","Camping",1,"NF0A3C96","Stratoliner-L",55555,NULL,299.99,399.99,1,11.7),
("The 860v11 is built for long runs with a Fresh Foam midsole that provides stable cushioning mile after mile", "Sports Equipment", 10, "M80V10", "Fresh Foam 860V11", 33333, NULL, 162.99, 152.99, 1, 0.59),
("The Fresh Foam 1080v10 is our premium expression of runner’s data supreme comfort and cutting-edge design", "Sports Equipment",12, "M1080", "Fresh Foam 1080V10", 33333, NULL, 209.8, 185.5, 1, 0.89),
("Featuring cutting-edge NB DRYx and NB ICEx technologies, the Impact Run Singlet wicks away moisture helping you stay cool and dry as you push through the last miles of your marathon run", "Sports Equipment", 15, "V809I", "Impact Run Singlet", 33333, NULL, 39.99, 30.82, 1, 0.10),
("Your active kid can layer on style and comfort with our Essentials Full Zip Hoodie", "Sports Equipment", 20, "G4786", "Youth Full Zip Hoodie", 33333, NULL, 47.99, 45.99, 1, 0.50),
("The Youth Essentials Stacked Fleece Short", "Sports Equipment", 20, "V456G", "Fleece Short", 33333, NULL, 31.99, 25.99, 1, 0.20),
("Your active kid can pull on style and comfort with our Essentials Stacked Logo Sweatpants", "Sports Equipment", 15, "V7878", "Stacked Sweatpants", 33333, NULL, 39.99, 24.99, 1, 0.19),
("Keep your head in the game. The NB Team Cap is a classic curved peaked cap with an elasticated band for a custom fit", "Sports Equipment", 40, "B5676", "Team Cap", 33333, NULL, 29.99, 15.99, 1, 0.10),
("The playmakers’ choice; for the artists of the game, who strive to perform with daring creativity", "Sports Equipment", 10, "GH655", "Tekela V3 Pro Night Heat FG", 33333, NULL, 85.99, 70.99, 1, 0.80),
("Comfort and style you can wear anywhere, just like your favorite tee", "Sports Equipment", 45, "H675H", "Fresh Foam Roav Tee Shirt", 33333, NULL, 65.66, 50.99, 1, 0.89),
("The FreezeLX V3 Box men's lacrosse shoe is built to complement your game and optimize your performance", "Sports Equipment", 19, "UB567", "FreezeLX V3 Box", 33333, NULL, 139.99, 129.99, 1, 1.95),
("The Coleman Tablecloth comes in a beautiful bright red checkered pattern for a simple yet unique look.The vinyl surface contains a layer of protective coating, ensuring easy cleanup. When not is use the tablecloth compactly", "Camping", 20, "X4544", "Vinlyl Tablecloth, Red", 88888, NULL, 5.49, 3.49, 1, 0.50),
("Brew up enough coffee for everyone to have a couple cups with the Coleman 9 Cup Percolator", "Camping", 50, "BV455", "9 Cup Coffee percolator", 88888, NULL, 67.80, 60.5, 1, 10.5),
("There’s a utensil for every campsite meal in the Coleman 12-Piece Stainless Steel Flatware Set with plastic handles", "Camping", 15, "VF546", "Coleman 12 piece stainless steel Flatware", 88888, NULL, 18.98, 10.58, 1, 10.5),
("Grill meat and toast sandwiches over a campfire, barbeque or outdoor fireplace with a Coleman Camp Cooker", "Camping", 20, "XC435", "Camp Cooker", 88888, NULL, 15.97, 10.56, 1, 15.8),
("Enjoy toast and jam, even at the campsite, with the round Coleman Camp Stove Toaster", "Camping", 10, "X45R4", "Camp Stove Toaster", 88888, NULL, 51.95, 45.85, 1, 118.5),
("Keep your food and drinks cold for an extended time, and make the fun last longer, when you bring a Coleman® 70 Quart Xtreme 5 Cooler", "Camping", 11, "VF546", "70 QUART XTREME 5 COOLER", 88888, NULL, 156.45, 150.65, 1, 150.6),
("Cook breakfast, lunch and dinner in any weather on your backpacking trip with the Coleman Guide Series Compact Naphta Fuel Stove", "Camping", 15, "XV546", "1 BURNER NAPHTA STOVE", 88888, NULL, 98.54, 85.45, 1, 254.56),
("Keep a carton of eggs safe from breaking until breakfast with help from a Coleman 12 Count Egg Container", "Camping", 18, "CV546", "12 COUNT EGG CONTAINER", 88888, NULL, 3.98, 1.98, 1, 0.90),
("Serve up burgers, soups, cereal and everything in between when you’re eating off Coleman Melamine Family Dinnerware", "Camping",15, "CR567", "Melamine Dishware", 88888, NULL, 29.97, 18.65, 1, 152.65),
("Cook hotdogs and roast marshmallows over a campfire in safety with the Coleman Extendable Cooking Fork", "Camping", 10, "XC099", "EXTENDABLE COOKING FORK", 88888, NULL, 10.25, 5.26, 1, 25.65),
(" the 30-Can Soft Cooler’s extra foam insulation will keep food and drinks cold up to 42 hours","camping",5,"2000036372","30-Can Portable Soft Cooler Space Blue",88888,NULL,38.5,48.03,1,1.4);



-- INVENTORY --
-- PUT INVENTORY INSERTS HERE ---

