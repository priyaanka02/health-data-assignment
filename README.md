# Health Data Aggregation & Analytics Assignment

This project simulates the collection and aggregation of health data from Apple Watches, similar to what would be collected through HealthKit in a real-world research environment.

## Project Overview

- **Database**: PostgreSQL 14 running in Docker container
- **Data Volume**: 6,140+ health records across 5 users over 24 hours
- **Aggregation**: 15-minute and 30-minute time buckets with gap handling
- **Missing Data**: ~15% data gaps to simulate connectivity issues

## Quick Start

### Prerequisites
- Docker Desktop installed and running
- Python 3.x with pip
- Command line access

### Setup Instructions

1. **Start PostgreSQL Database**
docker run --name health-db -e POSTGRES_PASSWORD=pass -e POSTGRES_USER=dev -e POSTGRES_DB=health -p 5432:5432 -d postgres:14


2. **Create Database Schema**
docker exec -i health-db psql -U dev -d health < sql_scripts/schema.sql


3. **Install Python Dependencies**
pip install psycopg2-binary

4. **Generate Dummy Health Data**
python python_scripts/generate_data.py


5. **Run 15-Minute Aggregation**
docker exec -i health-db psql -U dev -d health < sql_scripts/rollup_15m.sql


6. **Run 30-Minute Aggregation (with gaps)**
docker exec -i health-db psql -U dev -d health < sql_scripts/rollup_30m.sql


## File Structure
health-data-assignment/
├── README.md # This file
├── sql_scripts/
│ ├── schema.sql # Database table creation
│ ├── rollup_15m.sql # 15-minute aggregation query
│ └── rollup_30m.sql # 30-minute aggregation with gaps
├── python_scripts/
│ └── generate_data.py # Dummy data generation script
└── csv_exports/
├── health_15m_last24h.csv # 15-minute aggregated data
└── health_30m_last24h.csv # 30-minute aggregated data


## Database Schema

The `health_data` table includes typical Apple Watch metrics:
- Heart rate (average, min, max, variability)
- Activity metrics (steps, energy, distance)
- Sleep/wellness metrics (respiratory rate, stand hours)
- Exercise tracking (workout count, exercise minutes)

## Data Generation Logic

- **5 Users**: U12345, U67890, U11111, U22222, U33333
- **Time-based patterns**: Higher activity during 7:00-21:00
- **Realistic ranges**: Heart rate 50-150 bpm, contextual step counts
- **Missing data**: 15% random gaps to simulate connectivity issues
- **Correlations**: Walking heart rate only when steps > 50/min

## Aggregation Features

### 15-Minute Buckets
- Groups data into 15-minute windows
- Only shows buckets with data (no gaps)
- Returns ~485 rows for 24 hours across 5 users

### 30-Minute Buckets
- Shows ALL 30-minute windows (including empty ones)
- Missing periods show `samples = 0` with NULL metrics
- Returns exactly 245 rows for complete time coverage

## Technical Implementation

- **Database**: PostgreSQL with proper indexing on user_id and timestamp
- **Time Buckets**: Uses DATE_TRUNC and FLOOR functions for precise bucketing
- **Gap Handling**: Cross join with time series to ensure complete coverage
- **Performance**: Indexes on timestamp and user_id for efficient queries

## Results Summary

- **Database Records**: 6,140 health data points
- **Time Range**: Last 24 hours with realistic time patterns
- **15-min Export**: 485 aggregated records
- **30-min Export**: 245 records with gaps included
- **Missing Data**: Properly simulated connectivity issues

## Database Connection Details

- **Host**: localhost
- **Port**: 5432
- **Database**: health
- **Username**: dev
- **Password**: pass

## Notes

This simulation demonstrates real-world data collection challenges including:
- Intermittent device connectivity
- Time-based usage patterns
- Realistic physiological correlations
- Proper gap handling for analytics








