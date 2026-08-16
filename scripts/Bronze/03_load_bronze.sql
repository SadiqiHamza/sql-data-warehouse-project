/*
===============================================================================
Script: 03_load_bronze.sql

Purpose:
    Loads raw data from CSV files into the Bronze layer tables.

Description:
    This script creates and defines the stored procedure
    bronze.load_bronze(), which:
        1. Truncates existing Bronze tables.
        2. Loads raw data from CSV files using PostgreSQL COPY.
        3. Displays progress messages during the loading process.
        4. Measures the execution time of each loading operation.
        5. Handles errors and reports error messages.
        6. Raises the original error if the loading process fails.

Usage:
    Execute this script once to create or update the stored procedure.

    Then run the procedure using:

        CALL bronze.load_bronze();

Prerequisites:
    - PostgreSQL must be running.
    - The Bronze schema and tables must already exist.
    - CSV files must be available inside the PostgreSQL container.
    - The datasets directory must be mounted in Docker.
    - Example mount:
          ./datasets:/datasets

Warning:
    This procedure truncates all Bronze tables before loading the data.
    Existing data in the Bronze layer will therefore be deleted and replaced
    with the current source data.

Layer:
    Bronze - Raw data ingestion
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
		DECLARE
			start_time TIMESTAMP;
			end_time TIMESTAMP;
			batch_start_time TIMESTAMP;
			batch_end_time TIMESTAMP;
		BEGIN

		batch_start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '================================================';
		RAISE NOTICE 'Loading Bronze Layer';
		RAISE NOTICE '================================================';

		RAISE NOTICE '------------------------------------------------';
		RAISE NOTICE 'Loading CRM Tables';
		RAISE NOTICE '------------------------------------------------';

		start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
		COPY bronze.crm_cust_info
		FROM '/datasets/source_crm/cust_info.csv'
		WITH (
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Load duration: %', end_time - start_time;
		RAISE NOTICE '------------------------------------------------';
		-- ============================================================================
		-- CRM: Product Info
		-- ============================================================================
		start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
		COPY bronze.crm_prd_info
		FROM '/datasets/source_crm/prd_info.csv'
		WITH (
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Load duration: %', end_time - start_time;
		RAISE NOTICE '------------------------------------------------';
		-- ============================================================================
		-- CRM: Sales details
		-- ============================================================================
		start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
		COPY bronze.crm_sales_details
		FROM '/datasets/source_crm/sales_details.csv'
		WITH (
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);

		end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Load duration: %', end_time - start_time;
		RAISE NOTICE '------------------------------------------------';
		-- ============================================================================
		-- ERP: Cust az12
		-- ============================================================================
		start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
		COPY bronze.erp_cust_az12
		FROM '/datasets/source_erp/CUST_AZ12.csv'
		WITH (
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);

		end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Load duration: %', end_time - start_time;
		RAISE NOTICE '------------------------------------------------';
		-- ============================================================================
		-- ERP: Loc A101
		-- ============================================================================
		start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		
		RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
		COPY bronze.erp_loc_a101
		FROM '/datasets/source_erp/LOC_A101.csv'
		WITH (
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);

		end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Load duration: %', end_time - start_time;
		RAISE NOTICE '------------------------------------------------';
		-- ============================================================================
		-- ERP: Px Cat g1v2
		-- ============================================================================
		start_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		COPY bronze.erp_px_cat_g1v2
		FROM '/datasets/source_erp/PX_CAT_G1V2.csv'
		WITH (
			FORMAT CSV,
			HEADER TRUE,
			DELIMITER ','
		);
		
		end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '>> Load duration: %', end_time - start_time;
		RAISE NOTICE '------------------------------------------------';
		batch_end_time := CLOCK_TIMESTAMP();
		RAISE NOTICE '================================================';
		RAISE NOTICE 'Bronze Layer Loading Completed Successfully!';
		RAISE NOTICE 'Total Load Duration: %', batch_end_time - batch_start_time;
		RAISE NOTICE '================================================';
	
	EXCEPTION
    WHEN OTHERS THEN

        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR: Bronze Layer Loading Failed!';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'SQL State: %', SQLSTATE;
        RAISE NOTICE '================================================';

        RAISE;
	END;
END;
$$;
