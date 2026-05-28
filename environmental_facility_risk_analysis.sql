-- Environmental Facility Risk Analysis
-- Author: Eda Arslan
-- Objective: Analyze environmental operations data and identify facility-level compliance and energy risks.


-- 1. Create environmental_operations table

DROP TABLE IF EXISTS environmental_operations;

CREATE TABLE environmental_operations (
    date TEXT,
    facility TEXT,
    waste_type TEXT,
    waste_kg INTEGER,
    water_m3 INTEGER,
    energy_kwh INTEGER,
    limit_exceeded TEXT
);

-- 2. Insert environmental_operations data

INSERT INTO environmental_operations
(date, facility, waste_type, waste_kg, water_m3, energy_kwh, limit_exceeded)
VALUES
('2026-01-01', 'Plant A', 'Plastic', 120, 35, 420, 'No'),
('2026-01-02', 'Plant B', 'Chemical', 85, 50, 610, 'Yes'),
('2026-01-03', 'Plant A', 'Organic', 140, 40, 455, 'No'),
('2026-01-04', 'Plant C', 'Chemical', 95, 65, 700, 'Yes'),
('2026-01-05', 'Plant B', 'Plastic', 110, 48, 590, 'No'),
('2026-01-06', 'Plant C', 'Organic', 130, 60, 680, 'No'),
('2026-01-07', 'Plant A', 'Chemical', 75, 38, 430, 'No'),
('2026-01-08', 'Plant B', 'Organic', 160, 55, 640, 'Yes'),
('2026-01-09', 'Plant C', 'Plastic', 105, 62, 710, 'No'),
('2026-01-10', 'Plant A', 'Plastic', 115, 36, 425, 'No');

-- 3. Create facility_info table

DROP TABLE IF EXISTS facility_info;

CREATE TABLE facility_info (
    facility TEXT,
    region TEXT,
    manager TEXT,
    facility_type TEXT
);

-- 4. Insert facility_info data

INSERT INTO facility_info
(facility, region, manager, facility_type)
VALUES
('Plant A', 'North', 'Ayse', 'Manufacturing'),
('Plant B', 'South', 'Mehmet', 'Chemical'),
('Plant C', 'West', 'Elif', 'Assembly');

-- 5. Base joined table

SELECT
    eo.date,
    eo.facility,
    fi.region,
    fi.manager,
    fi.facility_type,
    eo.waste_type,
    eo.waste_kg,
    eo.water_m3,
    eo.energy_kwh,
    eo.limit_exceeded
FROM environmental_operations AS eo
LEFT JOIN facility_info AS fi
    ON eo.facility = fi.facility;

-- 6. Facility performance summary

SELECT
    eo.facility,
    fi.region,
    fi.manager,
    fi.facility_type,
    SUM(eo.waste_kg) AS total_waste,
    SUM(eo.water_m3) AS total_water,
    SUM(eo.energy_kwh) AS total_energy,
    AVG(eo.energy_kwh) AS avg_energy,
    COUNT(*) AS record_count,
    SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) AS violation_count
FROM environmental_operations AS eo
LEFT JOIN facility_info AS fi
    ON eo.facility = fi.facility
GROUP BY
    eo.facility,
    fi.region,
    fi.manager,
    fi.facility_type;

-- 7. Risk classification

SELECT
    eo.facility,
    fi.manager,
    SUM(eo.energy_kwh) AS total_energy,
    SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) AS violation_count,
    CASE
        WHEN SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) >= 2 THEN 'High Compliance Risk'
        WHEN SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) = 1 THEN 'Medium Compliance Risk'
        ELSE 'Low Compliance Risk'
    END AS compliance_risk_level,
    CASE
        WHEN SUM(eo.energy_kwh) >= 2000 THEN 'High Energy Risk'
        WHEN SUM(eo.energy_kwh) >= 1800 THEN 'Medium Energy Risk'
        ELSE 'Low Energy Risk'
    END AS energy_risk_level
FROM environmental_operations AS eo
LEFT JOIN facility_info AS fi
    ON eo.facility = fi.facility
GROUP BY
    eo.facility,
    fi.manager;

-- 8. Overall priority ranking

SELECT
    eo.facility,
    fi.manager,
    SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) AS violation_count,
    SUM(eo.energy_kwh) AS total_energy,
    CASE
        WHEN SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) >= 2 THEN 'Priority 1'
        WHEN SUM(eo.energy_kwh) >= 2000 THEN 'Priority 2'
        WHEN SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) = 1
             OR SUM(eo.energy_kwh) >= 1800 THEN 'Priority 3'
        ELSE 'Priority 4'
    END AS overall_priority
FROM environmental_operations AS eo
LEFT JOIN facility_info AS fi
    ON eo.facility = fi.facility
GROUP BY
    eo.facility,
    fi.manager;

-- 9. Manager risk summary

SELECT *
FROM (
    SELECT
        eo.facility,
        fi.manager,
        fi.region,
        SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) AS violation_count,
        SUM(eo.energy_kwh) AS total_energy,
        CASE
            WHEN SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) >= 2 THEN 'Priority 1'
            WHEN SUM(eo.energy_kwh) >= 2000 THEN 'Priority 2'
            WHEN SUM(CASE WHEN eo.limit_exceeded = 'Yes' THEN 1 ELSE 0 END) = 1
                 OR SUM(eo.energy_kwh) >= 1800 THEN 'Priority 3'
            ELSE 'Priority 4'
        END AS overall_priority
    FROM environmental_operations AS eo
    LEFT JOIN facility_info AS fi
        ON eo.facility = fi.facility
    GROUP BY
        eo.facility,
        fi.manager,
        fi.region
) AS priority_summary
WHERE overall_priority IN ('Priority 1', 'Priority 2', 'Priority 3');

-- 10. Waste type analysis

SELECT
    waste_type,
    SUM(waste_kg) AS total_waste,
    COUNT(*) AS record_count
FROM environmental_operations
GROUP BY waste_type
ORDER BY total_waste DESC;