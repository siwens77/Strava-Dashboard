import os
import sys
import csv
import requests


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
    
    # Columns for your Shiny App
    fields = ['activity_id', 'date', 'name', 'type', 'distance_km', 'elevation_gain', 'moving_time_s']
    
    with open(file_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for act in activities:
            writer.writerow({
                'activity_id': act.get('id'),
                'date': act.get('start_date_local').split('T')[0],
                'name': act.get('name'),
                'type': act.get('type'),
                'distance_km': round(act.get('distance', 0) / 1000, 2),
                'elevation_gain': act.get('total_elevation_gain', 0),
                'moving_time_s': act.get('moving_time', 0)
            })
            
    print(f"✅ Success! Saved {len(activities)} activities to {file_path}")

if __name__ == "__main__":
    fetch_and_save()