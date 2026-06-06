import os
import sys
import csv
import requests
import time
from dotenv import load_dotenv 

load_dotenv()

CLIENT_ID = os.getenv('STRAVA_CLIENT_ID') 
CLIENT_SECRET = os.getenv('STRAVA_CLIENT_SECRET') 
REFRESH_TOKEN = os.getenv('STRAVA_REFRESH_TOKEN')

def get_fresh_token():
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
        sys.exit(1)
    return res.json()['access_token']

def fetch_detailed_activities():
    access_token = get_fresh_token()
    headers = {"Authorization": f"Bearer {access_token}"}
    base_url = "https://www.strava.com/api/v3/activities/"
    list_url = "https://www.strava.com/api/v3/athlete/activities"
    
    print("Step 1: Finding activity IDs...")
    params = {"per_page": 200, "page": 1}
    list_res = requests.get(list_url, headers=headers, params=params)
    summary_activities = list_res.json()
    
    detailed_data = []
    
    print(f"Step 2: Fetching full details for {len(summary_activities)} activities...")
    for i, summary in enumerate(summary_activities):
        activity_id = summary['id']
        
        detail_res = requests.get(f"{base_url}{activity_id}", headers=headers)
        
        if detail_res.status_code == 200:
            detailed_data.append(detail_res.json())
            print(f"[{i+1}/{len(summary_activities)}] Fetched: {summary['name']}")
        elif detail_res.status_code == 429:
            print("⚠️ Rate limit hit! Waiting 15 minutes...")
            time.sleep(15 * 60) 
        

    save_to_csv(detailed_data)

def save_to_csv(activities):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, 'activities.csv')
    
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
            start_date = act.get('start_date_local', '')
            writer.writerow({
                'activity_id': act.get('id', ''),
                'date': start_date.split('T')[0] if start_date else '',
                'name': act.get('name', ''),
                'type': act.get('type', ''),
                'description': act.get('description', ''),
                'elapsed_time_s': act.get('elapsed_time', ''),
                'distance_km': round(act.get('distance', 0) / 1000, 2),
                'max_hr': act.get('max_heartrate', ''),
                'relative_effort': act.get('suffer_score', ''),
                'elapsed_time2': act.get('elapsed_time', ''),
                'moving_time_s': act.get('moving_time', ''),
                'distance_m': act.get('distance', ''),
                'max_speed': act.get('max_speed', ''),
                'avg_speed': act.get('average_speed', ''),
                'elevation_gain': act.get('total_elevation_gain', ''),
                'elevation_loss': 0,
                'elevation_low': act.get('elev_low', ''),
                'elevation_high': act.get('elev_high', ''),
                'max_grade': act.get('max_grade', ''),
                'avg_grade': act.get('average_grade', ''),
                'calories': act.get('calories', 0) 
            })
            
    print(f"🏁 Finished! Detailed data saved to {file_path}")

if __name__ == "__main__":
    fetch_detailed_activities()