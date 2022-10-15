-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-15 20:34:57.234

-- tables
-- Table: DimClient
CREATE TABLE DimClient (
    ID_client int  NOT NULL,
    first_name varchar(30)  NOT NULL,
    second_name varchar(30)  NOT NULL,
    address varchar(30)  NOT NULL,
    phone_number char(10)  NOT NULL,
    CONSTRAINT DimClient_pk PRIMARY KEY (ID_client)
);

-- Table: DimProduct
CREATE TABLE DimProduct (
    ID_product int  NOT NULL,
    ISBN bigint  NOT NULL,
    title varchar(30)  NOT NULL,
    author varchar(30)  NOT NULL,
    number_of_pages int  NOT NULL,
    publisher varchar(30)  NOT NULL,
    CONSTRAINT DimProduct_pk PRIMARY KEY (ID_product)
);

-- Table: DimSupplier
CREATE TABLE DimSupplier (
    ID_supplier int  NOT NULL,
    NIP int  NOT NULL,
    address text  NOT NULL,
    name text  NOT NULL,
    CONSTRAINT DimSupplier_pk PRIMARY KEY (ID_supplier)
);

-- Table: FACT_ORDER
CREATE TABLE FACT_ORDER (
    ID_order int  NOT NULL,
    date date  NOT NULL,
    D_product int  NOT NULL,
    ID_client int  NOT NULL,
    ID_supplier int  NOT NULL,
    CONSTRAINT FACT_ORDER_pk PRIMARY KEY (ID_order)
);

-- foreign keys
-- Reference: FACT_ORDER_DimClient (table: FACT_ORDER)
ALTER TABLE FACT_ORDER ADD CONSTRAINT FACT_ORDER_DimClient
    FOREIGN KEY (ID_client)
    REFERENCES DimClient (ID_client)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FACT_ORDER_DimCompany (table: FACT_ORDER)
ALTER TABLE FACT_ORDER ADD CONSTRAINT FACT_ORDER_DimCompany
    FOREIGN KEY (ID_supplier)
    REFERENCES DimSupplier (ID_supplier)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FACT_ORDER_DimProduct (table: FACT_ORDER)
ALTER TABLE FACT_ORDER ADD CONSTRAINT FACT_ORDER_DimProduct
    FOREIGN KEY (D_product)
    REFERENCES DimProduct (ID_product)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

