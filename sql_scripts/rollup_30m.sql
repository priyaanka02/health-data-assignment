-- 30-Minute Data Aggregation with Gaps

WITH time_series AS (
    
    SELECT 
        generate_series(
            DATE_TRUNC('hour', NOW() - INTERVAL '24 hours'),
            NOW(),
            INTERVAL '30 minutes'
        ) AS bucket_start
),
user_list AS (
    
    SELECT DISTINCT user_id FROM public.health_data
),
all_buckets AS (
        SELECT 
        u.user_id,
        t.bucket_start
    FROM user_list u
    CROSS JOIN time_series t
),
aggregated_data AS (
        SELECT 
        user_id,
        DATE_TRUNC('hour', "timestamp") + 
        INTERVAL '30 minutes' * FLOOR(EXTRACT('minute' FROM "timestamp") / 30) AS bucket_start,
        
        COUNT(*) AS samples,
        ROUND(AVG(heart_rate)::numeric, 1) AS heart_rate_avg,
        MIN(heart_rate_min) AS heart_rate_min,
        MAX(heart_rate_max) AS heart_rate_max,
        SUM(steps) AS steps_sum,
        ROUND(AVG(respiratory_rate)::numeric, 1) AS respiratory_rate_avg,
        ROUND(SUM(activity_energy)::numeric, 2) AS activity_energy_sum,
        ROUND(SUM(distance)::numeric, 3) AS distance_sum
    FROM public.health_data
    WHERE "timestamp" >= NOW() - INTERVAL '24 hours'
    GROUP BY 
        user_id,
        DATE_TRUNC('hour', "timestamp") + 
        INTERVAL '30 minutes' * FLOOR(EXTRACT('minute' FROM "timestamp") / 30)
)

SELECT 
    ab.user_id,
    ab.bucket_start,
    COALESCE(ad.samples, 0) AS samples,
    ad.heart_rate_avg,
    ad.heart_rate_min,
    ad.heart_rate_max,
    ad.steps_sum,
    ad.respiratory_rate_avg,
    ad.activity_energy_sum,
    ad.distance_sum
FROM all_buckets ab
LEFT JOIN aggregated_data ad 
    ON ab.user_id = ad.user_id 
    AND ab.bucket_start = ad.bucket_start
ORDER BY ab.user_id, ab.bucket_start;
