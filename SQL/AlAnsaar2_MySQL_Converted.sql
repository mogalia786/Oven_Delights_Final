-- =============================================
-- AlAnsaar2 Database - MySQL Conversion
-- Converted from SQL Server to MySQL
-- Date: 19 Oct 2025
-- =============================================

-- Drop database if exists (for clean import)
DROP DATABASE IF EXISTS alansaar_test;

-- Create database
CREATE DATABASE alansaar_test
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Use the database
USE alansaar_test;

-- =============================================
-- Table: CardActivation
-- =============================================
CREATE TABLE CardActivation (
    CardID VARCHAR(50) NULL,
    Dates DATETIME NULL,
    Activated VARCHAR(50) NULL,
    TimeActivated DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: CardDetails
-- =============================================
CREATE TABLE CardDetails (
    CardHolder VARCHAR(100) NULL,
    TradingAS VARCHAR(100) NULL,
    Stand VARCHAR(100) NULL,
    Types VARCHAR(100) NULL,
    CardID VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: CardStatus
-- =============================================
CREATE TABLE CardStatus (
    CardNumber VARCHAR(50) NULL,
    Status VARCHAR(50) NULL,
    Blocked VARCHAR(50) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: CardTransaction
-- =============================================
CREATE TABLE CardTransaction (
    CardId VARCHAR(50) NULL,
    Transactions VARCHAR(100) NULL,
    TransDate DATETIME NULL,
    TransTime DATETIME NULL,
    TillID VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: ComplimentaryStatus
-- =============================================
CREATE TABLE ComplimentaryStatus (
    CNo VARCHAR(100) NULL,
    Used VARCHAR(50) NULL,
    Active VARCHAR(50) NULL,
    DateUsed DATETIME NULL DEFAULT '1900-01-01'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: ExhibitorDetails
-- =============================================
CREATE TABLE ExhibitorDetails (
    Exhibitor VARCHAR(100) NULL,
    TradingAs VARCHAR(100) NULL,
    Tel VARCHAR(100) NULL,
    Cell VARCHAR(100) NULL,
    Street VARCHAR(100) NULL,
    Area VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Postal VARCHAR(100) NULL,
    StandNo VARCHAR(100) NULL,
    Types VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: Logon (User Authentication)
-- =============================================
CREATE TABLE Logon (
    username VARCHAR(200) NULL,
    passwords VARCHAR(200) NULL,
    Firstname VARCHAR(200) NULL,
    Lastname VARCHAR(200) NULL,
    Admin VARCHAR(50) NULL,
    canSale VARCHAR(50) NULL,
    canCard VARCHAR(50) NULL,
    canExhibitor VARCHAR(50) NULL,
    canComp VARCHAR(50) NULL,
    canTicket VARCHAR(50) NULL,
    canReport VARCHAR(50) NULL,
    canTeller VARCHAR(50) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: LogSheet (Login History)
-- =============================================
CREATE TABLE LogSheet (
    Username VARCHAR(100) NULL,
    DateLoggedOn DATETIME NULL,
    TimeLoggedOn VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: Parking
-- =============================================
CREATE TABLE Parking (
    TillID VARCHAR(50) NULL,
    DateOfSale DATETIME NULL,
    TimeOFSale DATETIME NULL,
    Amount VARCHAR(50) NULL,
    NumOfCars VARCHAR(50) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: Sales (Ticket Sales)
-- =============================================
CREATE TABLE Sales (
    TillID VARCHAR(50) NULL,
    DateofSale DATETIME NULL,
    TimeOFSale DATETIME NULL,
    Amount VARCHAR(50) NULL,
    NumAdults INT NULL,
    NumChild INT NULL,
    NumComps INT NULL,
    TicketNo VARCHAR(100) NULL,
    HourOfSale VARCHAR(50) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: TicketPrice
-- =============================================
CREATE TABLE TicketPrice (
    Adult DECIMAL(10,2) NULL,
    Child DECIMAL(10,2) NULL,
    Pensioner DECIMAL(10,2) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: Till (POS Terminal)
-- =============================================
CREATE TABLE Till (
    TillID VARCHAR(100) NULL,
    Location VARCHAR(100) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: TransactionLogSheet (Audit Trail)
-- =============================================
CREATE TABLE TransactionLogSheet (
    Username VARCHAR(100) NULL,
    DateofEvent DATETIME NULL,
    TimeofEvent DATETIME NULL,
    Result VARCHAR(300) NULL,
    Event VARCHAR(200) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Insert Sample Data for Testing
-- =============================================

-- Sample user (admin/admin)
INSERT INTO Logon (username, passwords, Firstname, Lastname, Admin, canSale, canCard, canExhibitor, canComp, canTicket, canReport, canTeller)
VALUES ('admin', 'admin', 'Admin', 'User', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes');

-- Sample ticket prices
INSERT INTO TicketPrice (Adult, Child, Pensioner)
VALUES (50.00, 25.00, 30.00);

-- Sample till
INSERT INTO Till (TillID, Location)
VALUES ('TILL01', 'Main Entrance');

-- =============================================
-- Verification Queries
-- =============================================
-- SELECT * FROM Logon;
-- SELECT * FROM TicketPrice;
-- SELECT * FROM Till;

-- =============================================
-- Database conversion complete!
-- =============================================
