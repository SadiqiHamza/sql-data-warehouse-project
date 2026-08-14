/*
===============================================================================
Script: 01_create_schemas.sql

Purpose:
    This script creates the schemas used by the Data Warehouse:

    - Bronze: Raw data
    - Silver: Cleaned and transformed data
    - Gold: Business-ready data

Prerequisites:
    1. Start the PostgreSQL and pgAdmin containers using Docker Compose.
    2. Open pgAdmin and connect to PostgreSQL.
    3. Open the "datawarehouse" database.
    4. Run this script.

Note:
    The "datawarehouse" database is created automatically by Docker/PostgreSQL.
    This script only creates the Data Warehouse schemas.
===============================================================================
*/

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE SCHEMA IF NOT EXISTS gold;