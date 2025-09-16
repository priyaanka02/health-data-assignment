-- 15-Minute Data Aggregation

SELECT 
    user_id,
    
    DATE_TRUNC('hour', "timestamp") + 
    INTERVAL '15 minutes' * FLOOR(EXTRACT('minute' FROM "timestamp") / 15) AS bucket_start,
    
    COUNT(*) AS samples,
    
    
    ROUND(AVG(heart_rate)::numeric, 1) AS heart_rate_avg,
    MIN(heart_rate_min) AS heart_rate_min,
    MAX(heart_rate_max) AS heart_rate_max,
    
    
    SUM(steps) AS steps_sum,
    
    
    ROUND(AVG(respiratory_rate)::numeric, 1) AS respiratory_rate_avg,
    ROUND(SUM(activity_energy)::numeric, 2) AS activity_energy_sum,
    ROUND(SUM(distance)::numeric, 3) AS distance_sum,
    
   
    SUM(flights_climbed) AS flights_climbed_sum,
    SUM(exercise_minutes) AS exercise_minutes_sum,
    SUM(stand_hours) AS stand_hours_sum,
    SUM(workout_count) AS workout_count_sum

FROM public.health_data
WHERE "timestamp" >= NOW() - INTERVAL '24 hours'
GROUP BY 
    user_id, 
    DATE_TRUNC('hour', "timestamp") + 
    INTERVAL '15 minutes' * FLOOR(EXTRACT('minute' FROM "timestamp") / 15)
ORDER BY user_id, bucket_start;
