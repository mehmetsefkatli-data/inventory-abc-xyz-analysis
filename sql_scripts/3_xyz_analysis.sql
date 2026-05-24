-- ==============================================================================
-- ANALYSIS 2: XYZ INVENTORY CLASSIFICATION (DEMAND VOLATILITY)
-- ==============================================================================
-- This query measures demand predictability using statistical variance. It 
-- calculates the Coefficient of Variation (CV) to classify items into X (steady), 
-- Y (fluctuating), and Z (erratic) classes, driving safety stock strategies.

WITH DemandStats AS (
    -- Step 1: Calculate the Mean (Average) Demand and Standard Deviation for each material
    SELECT 
        m.material_code,
        m.description,
        AVG(d.quantity_used) AS avg_demand,
        -- Use COALESCE to handle NULL standard deviations (e.g., if insufficient data points exist)
        COALESCE(STDDEV(d.quantity_used), 0) AS std_deviation
    FROM materials m
    JOIN monthly_demand d ON m.material_id = d.material_id
    GROUP BY m.material_code, m.description
),
CoefficientOfVariation AS (
    -- Step 2: Calculate the Coefficient of Variation (CV) = Standard Deviation / Mean
    SELECT 
        material_code,
        description,
        ROUND(avg_demand, 2) AS avg_demand,
        ROUND(std_deviation, 2) AS std_deviation,
        -- Prevent division by zero errors
        CASE 
            WHEN avg_demand = 0 THEN 0 
            ELSE ROUND((std_deviation / avg_demand), 2) 
        END AS cv_ratio
    FROM DemandStats
)
-- Step 3: Classify as X, Y, or Z based on the CV ratio threshold
SELECT 
    material_code,
    description,
    avg_demand,
    std_deviation,
    cv_ratio,
    CASE 
        WHEN cv_ratio <= 0.15 THEN 'X-Class (Steady Demand - Easy to Predict)'
        WHEN cv_ratio <= 0.40 THEN 'Y-Class (Fluctuating Demand - Needs Safety Stock)'
        ELSE 'Z-Class (Erratic Demand - Hard to Predict)'
    END AS xyz_category
FROM CoefficientOfVariation
ORDER BY cv_ratio ASC;
