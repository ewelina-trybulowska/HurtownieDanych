-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-15 21:08:53.326

-- tables
-- Table: DimCategory
CREATE TABLE DimCategory (
    ID_category int  NOT NULL,
    fruit_category varchar(30)  NOT NULL,
    CONSTRAINT DimCategory_pk PRIMARY KEY (ID_category)
);

-- Table: DimClient
CREATE TABLE DimClient (
    ID_client int  NOT NULL,
    name text  NOT NULL,
    NIP char(10)  NOT NULL,
    address text  NOT NULL,
    CONSTRAINT DimClient_pk PRIMARY KEY (ID_client)
);

-- Table: DimDate
CREATE TABLE DimDate (
    ID_date int  NOT NULL,
    day int  NOT NULL,
    month int  NOT NULL,
    time time  NOT NULL,
    CONSTRAINT DimDate_pk PRIMARY KEY (ID_date)
);

-- Table: DimFruit
CREATE TABLE DimFruit (
    ID_fruit int  NOT NULL,
    fruit_name varchar(30)  NOT NULL,
    price_kg money  NOT NULL,
    ID_category int  NOT NULL,
    CONSTRAINT DimFruit_pk PRIMARY KEY (ID_fruit)
);

-- Table: FactOrder
CREATE TABLE FactOrder (
    ID_order int  NOT NULL,
    order_amount money  NOT NULL,
    place_of_sale int  NOT NULL,
    amount_of_fruit decimal(2,2)  NOT NULL,
    ID_client int  NOT NULL,
    ID_date int  NOT NULL,
    ID_fruit int  NOT NULL,
    CONSTRAINT FactOrder_pk PRIMARY KEY (ID_order)
);

-- foreign keys
-- Reference: DimFruit_DimCategory (table: DimFruit)
ALTER TABLE DimFruit ADD CONSTRAINT DimFruit_DimCategory
    FOREIGN KEY (ID_category)
    REFERENCES DimCategory (ID_category)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FactOrder_DimClient (table: FactOrder)
ALTER TABLE FactOrder ADD CONSTRAINT FactOrder_DimClient
    FOREIGN KEY (ID_client)
    REFERENCES DimClient (ID_client)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FactOrder_DimDate (table: FactOrder)
ALTER TABLE FactOrder ADD CONSTRAINT FactOrder_DimDate
    FOREIGN KEY (ID_date)
    REFERENCES DimDate (ID_date)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FactOrder_DimFruit (table: FactOrder)
ALTER TABLE FactOrder ADD CONSTRAINT FactOrder_DimFruit
    FOREIGN KEY (ID_fruit)
    REFERENCES DimFruit (ID_fruit)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

