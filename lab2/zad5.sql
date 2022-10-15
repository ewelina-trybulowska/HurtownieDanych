-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-15 21:53:28.163

-- tables
-- Table: Dim_history
CREATE TABLE Dim_history (
    ID int  NOT NULL,
    Grade int  NOT NULL,
    Grade_date date  NOT NULL,
    CONSTRAINT Dim_history_pk PRIMARY KEY (ID)
);

-- Table: Fact_Employee
CREATE TABLE Fact_Employee (
    ID_employee int  NOT NULL,
    PESEL char(11)  NOT NULL,
    address text  NOT NULL,
    salary money  NOT NULL,
    Dim_history_ID int  NOT NULL,
    CONSTRAINT Fact_Employee_pk PRIMARY KEY (ID_employee)
);

-- foreign keys
-- Reference: Fact_Employee_Dim_history (table: Fact_Employee)
ALTER TABLE Fact_Employee ADD CONSTRAINT Fact_Employee_Dim_history
    FOREIGN KEY (Dim_history_ID)
    REFERENCES Dim_history (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

