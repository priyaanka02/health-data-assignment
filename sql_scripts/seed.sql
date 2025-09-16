-- Alternative SQL-only data generation
-- Note: The Python script (generate_data.py) is the main/original method


-- Example approach :
/*
INSERT INTO public.health_data (user_id, timestamp, heart_rate, steps)
SELECT 
    'U' || (n % 5 + 1)::text,
    NOW() - INTERVAL '24 hours' + (n || ' minutes')::INTERVAL,
    60 + (random() * 50)::int,
    CASE 
        WHEN EXTRACT(hour FROM NOW() - INTERVAL '24 hours' + (n || ' minutes')::INTERVAL) BETWEEN 7 AND 21 
        THEN (random() * 150)::int
        ELSE (random() * 10)::int
    END
FROM generate_series(1, 7200) n
WHERE random() > 0.15; -- Skip 15% for missing data
*/


