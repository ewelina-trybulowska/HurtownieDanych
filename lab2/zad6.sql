-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-15 22:07:26.584

-- tables
-- Table: DimBrand
CREATE TABLE DimBrand (
    ID_brand int  NOT NULL,
    brand varchar(30)  NOT NULL,
    CONSTRAINT DimBrand_pk PRIMARY KEY (ID_brand)
);

-- Table: DimDate
CREATE TABLE DimDate (
    ID_date int  NOT NULL,
    date date  NOT NULL,
    day int  NOT NULL,
    month int  NOT NULL,
    year int  NOT NULL,
    CONSTRAINT DimDate_pk PRIMARY KEY (ID_date)
);

-- Table: DimProduct
CREATE TABLE DimProduct (
    ID_product int  NOT NULL,
    name varchar(30)  NOT NULL,
    quantity_available int  NOT NULL,
    ID_brand int  NOT NULL,
    CONSTRAINT DimProduct_pk PRIMARY KEY (ID_product)
);

-- Table: DimWarehouse
CREATE TABLE DimWarehouse (
    ID_storage int  NOT NULL,
    country varchar(25)  NOT NULL,
    FactTable_WarehouseState_ID_state int  NOT NULL,
    CONSTRAINT DimWarehouse_pk PRIMARY KEY (ID_storage)
);

-- Table: FactTable_WarehouseState
CREATE TABLE FactTable_WarehouseState (
    ID_state int  NOT NULL,
    ID_product int  NOT NULL,
    DimDate_ID_date int  NOT NULL,
    CONSTRAINT FactTable_WarehouseState_pk PRIMARY KEY (ID_state)
);

-- foreign keys
-- Reference: DimProduct_DimBrand (table: DimProduct)
ALTER TABLE DimProduct ADD CONSTRAINT DimProduct_DimBrand
    FOREIGN KEY (ID_brand)
    REFERENCES DimBrand (ID_brand)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: DimWarehouse_FactTable_WarehouseState (table: DimWarehouse)
ALTER TABLE DimWarehouse ADD CONSTRAINT DimWarehouse_FactTable_WarehouseState
    FOREIGN KEY (FactTable_WarehouseState_ID_state)
    REFERENCES FactTable_WarehouseState (ID_state)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FactTable_DimProduct (table: FactTable_WarehouseState)
ALTER TABLE FactTable_WarehouseState ADD CONSTRAINT FactTable_DimProduct
    FOREIGN KEY (ID_product)
    REFERENCES DimProduct (ID_product)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FactTable_WarehouseState_DimDate (table: FactTable_WarehouseState)
ALTER TABLE FactTable_WarehouseState ADD CONSTRAINT FactTable_WarehouseState_DimDate
    FOREIGN KEY (DimDate_ID_date)
    REFERENCES DimDate (ID_date)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

