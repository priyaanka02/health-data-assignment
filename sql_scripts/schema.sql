-- Health Data Table Schema
-- main table to store Apple Watch-like health data

CREATE TABLE IF NOT EXISTS public.health_data (
    id BIGSERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    "timestamp" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    heart_rate INTEGER,
    heart_rate_min INTEGER,
    heart_rate_max INTEGER,
    heart_rate_variability NUMERIC,
    respiratory_rate NUMERIC,
    steps INTEGER,
    activity_energy NUMERIC,
    basal_energy NUMERIC,
    distance NUMERIC,
    flights_climbed INTEGER,
    exercise_minutes INTEGER,
    stand_hours INTEGER,
    workout_count INTEGER,
    walking_heart_rate_avg NUMERIC,
    cycling_distance NUMERIC
);

-- indexes
CREATE INDEX IF NOT EXISTS idx_health_data_user_timestamp 
ON public.health_data (user_id, "timestamp");

CREATE INDEX IF NOT EXISTS idx_health_data_timestamp 
ON public.health_data ("timestamp");

COMMENT ON TABLE public.health_data IS 'Health data collected from Apple Watch devices';
COMMENT ON COLUMN public.health_data.user_id IS 'Unique identifier for each user';
COMMENT ON COLUMN public.health_data."timestamp" IS 'When the health data was recorded';

