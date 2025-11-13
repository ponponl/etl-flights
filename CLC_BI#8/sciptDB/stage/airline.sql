-- Drop database if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'airline_stage')
BEGIN
    ALTER DATABASE airline_stage SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE airline_stage;
END
GO

-- Create database
CREATE DATABASE airline_stage
GO

-- Use the database
USE airline_stage
GO

-- Create stage_airlines table
CREATE TABLE stage_airlines(
    airline_code VARCHAR(10),
    airline_name VARCHAR(100),
    created DATETIME2,
    modified DATETIME2,
    PRIMARY KEY(airline_code)
);
GO

-- Create stage_airports table
CREATE TABLE stage_airports (
    airport_code VARCHAR(10) PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(100),
    state CHAR(2),
    country VARCHAR(50),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    created DATETIME2,
    modified DATETIME2
);
GO

-- Create stage_flight table
CREATE TABLE stage_flight (
    FLIGHT_DATE DATETIME2,
    AIRLINE VARCHAR(10),
    FLIGHT_NUMBER VARCHAR(10),
    TAIL_NUMBER VARCHAR(20),
    ORIGIN_AIRPORT VARCHAR(10),
    DESTINATION_AIRPORT VARCHAR(10),
    SCHEDULED_DEPARTURE INT,
    DEPARTURE_TIME FLOAT,
    DEPARTURE_DELAY FLOAT,
    TAXI_OUT FLOAT,
    WHEELS_OFF FLOAT,
    SCHEDULED_TIME FLOAT,
    ELAPSED_TIME FLOAT,
    AIR_TIME FLOAT,
    DISTANCE FLOAT,
    WHEELS_ON FLOAT,
    TAXI_IN FLOAT,
    SCHEDULED_ARRIVAL INT,
    ARRIVAL_TIME FLOAT,
    ARRIVAL_DELAY FLOAT,
    DIVERTED INT,
    CANCELLED INT,
    CANCELLATION_REASON VARCHAR(5),
    AIR_SYSTEM_DELAY FLOAT,
    SECURITY_DELAY FLOAT,
    AIRLINE_DELAY FLOAT,
    LATE_AIRCRAFT_DELAY FLOAT,
    WEATHER_DELAY FLOAT,
	SOURCE_ID VARCHAR(50),
    created DATETIME2,
    modified DATETIME2,
    PRIMARY KEY(FLIGHT_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT, FLIGHT_DATE, TAIL_NUMBER)
);
GO

-- Verify tables
SELECT * FROM stage_airlines;
SELECT * FROM stage_airports;
SELECT * FROM stage_flight;
GO