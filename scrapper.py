import os
import sys
import csv
import requests
from dotenv import load_dotenv  # <--- THIS LINE IS MISSING

load_dotenv()

CLIENT_ID = os.getenv('STRAVA_CLIENT_ID', '245862') 
CLIENT_SECRET = os.getenv('STRAVA_CLIENT_SECRET') 
REFRESH_TOKEN = os.getenv('STRAVA_REFRESH_TOKEN')

def get_fresh_token():
    """Traded the Refresh Token for a temporary 6-hour Access Token"""
    auth_url = "https://www.strava.com/oauth/token"
    payload = {
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'refresh_token': REFRESH_TOKEN,
        'grant_type': 'refresh_token'
    }
    res = requests.post(auth_url, data=payload)
    if res.status_code != 200:
        print(f"❌ Failed to refresh token: {res.status_code}")
        print(res.text)
        sys.exit(1)
    return res.json()['access_token']

def fetch_and_save():
    access_token = get_fresh_token()
    url = "https://www.strava.com/api/v3/athlete/activities"
    headers = {"Authorization": f"Bearer {access_token}"}
    
    # We want latest activities
    params = {"per_page": 100}
    
    print("Connecting to Strava with activity:read_all permissions...")
    response = requests.get(url, headers=headers, params=params)
    
    if response.status_code != 200:
        print(f"❌ API Error: {response.status_code}")
        print(response.text)
        sys.exit(1)
        
    activities = response.json()
    
    # Save path
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, 'activities.csv')
    
    # All required columns
    fields = [
        "activity_id", "date", "name", "type", "description", 
        "elapsed_time_s", "distance_km", "max_hr", "relative_effort", 
        "elapsed_time2", "moving_time_s", "distance_m", "max_speed", 
        "avg_speed", "elevation_gain", "elevation_loss", "elevation_low", 
        "elevation_high", "max_grade", "avg_grade", "calories"
    ]
    
    with open(file_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        
        for act in activities:
            # Safely get the date string before parsing
            start_date = act.get('start_date_local', '')
            date_str = start_date.split('T')[0] if start_date else ''
            
            writer.writerow({
                'activity_id': act.get('id', ''),
                'date': date_str,
                'name': act.get('name', ''),
                'type': act.get('type', ''),
                'description': act.get('description', ''),
                'elapsed_time_s': act.get('elapsed_time', ''),
                'distance_km': round(act.get('distance', 0) / 1000, 2) if act.get('distance') else 0,
                'max_hr': act.get('max_heartrate', ''),
                'relative_effort': act.get('suffer_score', ''),
                #'elapsed_time2': act.get('elapsed_time', ''),  # Duplicated as per your column list
                'moving_time_s': act.get('moving_time', ''),
                'distance_m': act.get('distance', ''),
                'max_speed': act.get('max_speed', ''),
                'avg_speed': act.get('average_speed', ''),
                'elevation_gain': act.get('total_elevation_gain', ''),
                #'elevation_loss': '',  # Strava API does not provide a native elevation loss field
                'elevation_low': act.get('elev_low', ''),
                'elevation_high': act.get('elev_high', ''),
                'max_grade': act.get('max_grade', ''),
                'avg_grade': act.get('average_grade', ''),
                'calories': act.get('calories', '') 
            })
            
    print(f"✅ Success! Saved {len(activities)} activities to {file_path}")

if __name__ == "__main__":
    fetch_and_save()