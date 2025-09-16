import psycopg2
import random
from datetime import datetime, timedelta
import sys

def generate_health_data():
        
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="health",
            user="dev",
            password="pass",
            port="5432"
        )
        cursor = conn.cursor()
        print(" Connected to PostgreSQL database")
    except Exception as e:
        print(f" Database connection failed: {e}")
        return
    
    cursor.execute("DELETE FROM public.health_data")
    print(" Cleared existing data")
    
    # User IDs
    users = ['U12345', 'U67890', 'U11111', 'U22222', 'U33333']
    
    # Start time
    start_time = datetime.now() - timedelta(hours=24)
    
    print(f" Generating data from {start_time.strftime('%Y-%m-%d %H:%M')} to {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    
    # data for each user
    total_records = 0
    for user_id in users:
        print(f" Generating data for user: {user_id}")
        
        current_time = start_time
        records_inserted = 0
        
        # 1 record per minute for 24 hours (1440 minutes)
        for minute in range(1440):
            current_time = start_time + timedelta(minutes=minute)
            
            # Skipping some records randomly to show connectivity issues
            if random.random() < 0.15:
                continue
                
        
            hour = current_time.hour
            
            # Heart rate varies by time (lower at night, higher during day)
            if 22 <= hour or hour <= 6:  # Night time
                base_hr = random.randint(55, 75)
            elif 7 <= hour <= 9 or 17 <= hour <= 19:  # Active hours
                base_hr = random.randint(80, 110)
            else:  # Regular day
                base_hr = random.randint(65, 90)
       
            if 7 <= hour <= 21:  # Day time
                steps = random.randint(0, 150)  # per minute
            else:  # Night time
                steps = random.randint(0, 10)
      
            heart_rate = max(50, min(150, base_hr + random.randint(-8, 8)))
            hr_min = max(45, heart_rate - random.randint(5, 20))
            hr_max = min(180, heart_rate + random.randint(10, 30))
         
            insert_query = """
                INSERT INTO public.health_data (
                    user_id, "timestamp", heart_rate, heart_rate_min, heart_rate_max,
                    heart_rate_variability, respiratory_rate, steps, activity_energy,
                    basal_energy, distance, flights_climbed, exercise_minutes,
                    stand_hours, workout_count, walking_heart_rate_avg, cycling_distance
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            
            values = (
                user_id, 
                current_time,
                heart_rate,
                hr_min,
                hr_max,
                round(random.uniform(20, 80), 2),  # HRV
                round(random.uniform(12, 20), 1),  # Respiratory rate
                steps,
                round(random.uniform(0, 15), 2),   # Activity energy
                round(random.uniform(1, 3), 2),    # Basal energy
                round(steps * random.uniform(0.0007, 0.0009), 3) if steps > 0 else 0,  # Distance
                random.randint(0, 2) if random.random() < 0.1 else 0,  # stairsets climbed
                1 if random.random() < 0.3 and 7 <= hour <= 21 else 0,  # Exercise minutes
                1 if minute % 60 == 0 and random.random() < 0.6 and 7 <= hour <= 21 else 0,  # Stand hours
                1 if random.random() < 0.05 and 7 <= hour <= 21 else 0,  # Workout count
                heart_rate + random.randint(-10, 10) if steps > 50 else None,  # Walking HR avg
                round(random.uniform(0, 2), 3) if random.random() < 0.05 else 0  # Cycling distance
            )
            
            cursor.execute(insert_query, values)
            records_inserted += 1
        
        print(f"   Inserted {records_inserted} records for {user_id}")
        total_records += records_inserted
    
   
    conn.commit()
    
    # summary
    cursor.execute("SELECT COUNT(*) FROM public.health_data")
    total_in_db = cursor.fetchone()
    cursor.execute("SELECT COUNT(DISTINCT user_id) FROM public.health_data")
    unique_users = cursor.fetchone()
    cursor.execute("SELECT MIN(timestamp), MAX(timestamp) FROM public.health_data")
    time_range = cursor.fetchone()
    
    print(f"\nData generation completed successfully!")
    print(f"SUMMARY:")
    print(f"   Total records inserted: {total_records}")
    print(f"   Records in database: {total_in_db}")
    print(f"   Unique users: {unique_users}")
    print(f"   Time range: {time_range} to {time_range[2]}")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    generate_health_data()

