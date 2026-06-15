
from datetime import datetime, timedelta
from BLL import BLL

# Initialize BLL
bll = BLL()

# Pick valid passenger and vessel IDs from the database
passenger_id = bll.get_passengers()[0]['id']  # First passenger
vessel_id = bll.get_vessels()[0]['id']        # First vessel

# Define start and end times
start_dt = datetime(2025, 12, 10, 10, 0)  # Test date
duration_hours = 2.0
end_dt = start_dt + timedelta(hours=duration_hours)

# Try adding the trip
ok, msg = bll.add_trip(passenger_id, vessel_id, start_dt, end_dt, price=0.0)
print(f"Add Trip Result: {ok}, Message: {msg}")

# Fetch all trips to confirm insertion
trips = bll.get_trips()
print(f"Total Trips: {len(trips)}")
print("Last Trip Added:", trips[-1])


