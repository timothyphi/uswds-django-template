-- SQL Server Database Initialization Script for USWDS Django Template
-- This script will be run when the SQL Server container starts up

USE master;
GO

-- Create the application database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'uswds_db')
BEGIN
    CREATE DATABASE uswds_db;
    PRINT 'Database uswds_db created successfully';
END
ELSE
BEGIN
    PRINT 'Database uswds_db already exists';
END
GO

-- Create a test database for running tests
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'uswds_db_test')
BEGIN
    CREATE DATABASE uswds_db_test;
    PRINT 'Test database uswds_db_test created successfully';
END
ELSE
BEGIN
    PRINT 'Test database uswds_db_test already exists';
END
GO

-- Switch to the application database
USE uswds_db;
GO

-- Add any initial schema setup here if needed
-- For now, Django migrations will handle the schema creation

PRINT 'Database initialization completed successfully';
GO