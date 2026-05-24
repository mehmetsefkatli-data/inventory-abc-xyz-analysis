-- ==============================================================================
-- DATABASE SETUP: INVENTORY OPTIMIZATION (ABC/XYZ ANALYSIS)
-- ==============================================================================

-- STEP 1: Clean up existing tables (Order is important due to foreign keys)
DROP TABLE IF EXISTS monthly_demand;
DROP TABLE IF EXISTS materials;

-- STEP 2: Create Tables

-- 2.1. Materials Master Data
CREATE TABLE materials (
    material_id SERIAL PRIMARY KEY,
    material_code VARCHAR(20) UNIQUE NOT NULL,
    description VARCHAR(100),
    unit_price_eur DECIMAL(10,2)
);

-- 2.2. Monthly Demand Data (Historical consumption logs)
CREATE TABLE monthly_demand (
    demand_id SERIAL PRIMARY KEY,
    material_id INT REFERENCES materials(material_id),
    demand_month DATE,
    quantity_used INT
);

-- STEP 3: Insert Sample Data

-- 3.1. Insert materials with varying unit prices
INSERT INTO materials (material_code, description, unit_price_eur) VALUES 
('MTR-001', 'Electric Motor 500W', 450.00),
('BRN-002', 'High-Speed Bearing', 85.00),
('SBL-003', 'Steel Beam 2m', 120.00),
('SCW-004', 'Hex Screw M8', 0.15),
('WSH-005', 'Metal Washer', 0.05);

-- 3.2. Insert 3-month consumption data 
-- (High volume/low cost vs. Low volume/high cost scenarios)
INSERT INTO monthly_demand (material_id, demand_month, quantity_used) VALUES
(1, '2026-01-01', 10), (1, '2026-02-01', 12), (1, '2026-03-01', 8),   -- Motor
(2, '2026-01-01', 50), (2, '2026-02-01', 45), (2, '2026-03-01', 60),   -- Bearing
(3, '2026-01-01', 30), (3, '2026-02-01', 25), (3, '2026-03-01', 35),   -- Steel Beam
(4, '2026-01-01', 5000), (4, '2026-02-01', 5500), (4, '2026-03-01', 4800), -- Screw
(5, '2026-01-01', 8000), (5, '2026-02-01', 7500), (5, '2026-03-01', 9000); -- Washer
