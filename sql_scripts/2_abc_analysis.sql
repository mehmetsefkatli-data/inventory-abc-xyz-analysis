-- ==============================================================================
-- ANALYSIS 1: ABC INVENTORY CLASSIFICATION (VALUE-BASED)
-- ==============================================================================
-- This query categorizes inventory into A, B, and C classes based on the Pareto 
-- Principle (80/20 rule). It uses Window Functions to calculate cumulative totals 
-- and percentages to identify the most financially critical materials.

WITH AnnualUsage AS (
    -- Step 1: Calculate total usage quantity and total financial value per material
    SELECT 
        m.material_code,
        m.description,
        m.unit_price_eur,
        SUM(d.quantity_used) AS total_quantity,
        SUM(d.quantity_used * m.unit_price_eur) AS total_value_eur
    FROM materials m
    JOIN monthly_demand d ON m.material_id = d.material_id
    GROUP BY m.material_code, m.description, m.unit_price_eur
),
CumulativeValue AS (
    -- Step 2: Calculate running total value and overall inventory value
    SELECT 
        material_code,
        description,
        total_quantity,
        total_value_eur,
        -- Running total sorted by highest value first
        SUM(total_value_eur) OVER (ORDER BY total_value_eur DESC) AS running_total_value,
        -- Grand total of all materials combined
        SUM(total_value_eur) OVER () AS overall_total_value
    FROM AnnualUsage
),
ABC_Classification AS (
    -- Step 3: Calculate cumulative percentage and classify into A, B, or C
    SELECT 
        material_code,
        description,
        total_quantity,
        total_value_eur,
        ROUND((running_total_value / overall_total_value) * 100, 2) AS cumulative_percentage,
        CASE 
            WHEN (running_total_value / overall_total_value) <= 0.80 THEN 'A-Class (High Value - Tight Control)'
            WHEN (running_total_value / overall_total_value) <= 0.95 THEN 'B-Class (Medium Value - Regular Control)'
            ELSE 'C-Class (Low Value - Bulk Order)'
        END AS abc_category
    FROM CumulativeValue
)
-- Final Output: Display materials ranked by their financial impact
SELECT 
    material_code,
    description,
    total_value_eur,
    cumulative_percentage,
    abc_category
FROM ABC_Classification
ORDER BY total_value_eur DESC;
