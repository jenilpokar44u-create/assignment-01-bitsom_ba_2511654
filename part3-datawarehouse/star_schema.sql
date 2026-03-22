-- Create Dimension Tables

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    calendar_year INT NOT NULL,
    calendar_month INT NOT NULL,
    calendar_quarter INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL
);

CREATE TABLE dim_store (
    store_id VARCHAR(10) PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL
);

-- Create Fact Table

CREATE TABLE fact_sales (
    sale_id VARCHAR(15) PRIMARY KEY,
    date_id INT NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    quantity_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_revenue DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Insert Cleaned Sample Data into Dimensions

INSERT INTO dim_date (date_id, full_date, calendar_year, calendar_month, calendar_quarter, day_of_week) VALUES
(20240115, '2024-01-15', 2024, 1, 1, 'Monday'),
(20240120, '2024-01-20', 2024, 1, 1, 'Saturday'),
(20240210, '2024-02-10', 2024, 2, 1, 'Saturday'),
(20240214, '2024-02-14', 2024, 2, 1, 'Wednesday');

INSERT INTO dim_store (store_id, store_name, city, region) VALUES
('ST001', 'Downtown Hub', 'New York', 'East'),
('ST002', 'Westside Plaza', 'Los Angeles', 'West'),
('ST003', 'Metro Central', 'Chicago', 'Midwest');

INSERT INTO dim_product (product_id, product_name, category, brand) VALUES
('PRD101', 'Wireless Mouse', 'Electronics', 'Logitech'),
('PRD102', 'Cotton T-Shirt', 'Apparel', 'Nike'),
('PRD103', 'Coffee Beans', 'Groceries', 'Starbucks');

-- Insert Cleaned Sample Data into Fact Table (10 Rows)
-- Note: total_revenue is calculated as quantity_sold * unit_price

INSERT INTO fact_sales (sale_id, date_id, store_id, product_id, quantity_sold, unit_price, total_revenue) VALUES
('TXN9001', 20240115, 'ST001', 'PRD101', 2, 25.00, 50.00),
('TXN9002', 20240115, 'ST002', 'PRD102', 5, 20.00, 100.00),
('TXN9003', 20240115, 'ST003', 'PRD103', 1, 15.00, 15.00),
('TXN9004', 20240120, 'ST001', 'PRD102', 3, 20.00, 60.00),
('TXN9005', 20240120, 'ST002', 'PRD101', 1, 25.00, 25.00),
('TXN9006', 20240210, 'ST003', 'PRD101', 4, 25.00, 100.00),
('TXN9007', 20240210, 'ST001', 'PRD103', 10, 15.00, 150.00),
('TXN9008', 20240214, 'ST002', 'PRD102', 2, 20.00, 40.00),
('TXN9009', 20240214, 'ST003', 'PRD103', 5, 15.00, 75.00),
('TXN9010', 20240214, 'ST001', 'PRD101', 3, 25.00, 75.00);
