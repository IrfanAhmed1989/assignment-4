
# BLL.py
from DAL import Db, PassengerDAL, VesselDAL, TripDAL
from datetime import datetime, timedelta

class BLL:
    def __init__(self):
        # Connect to MySQL using your password
        self._db = Db()
        self._db.connect(host="localhost", port=3306, user="root", password="iiii", database="mrc")

        # Initialize DAL classes
        self._passenger_dal = PassengerDAL(self._db)
        self._vessel_dal = VesselDAL(self._db)
        self._trip_dal = TripDAL(self._db)

        # Cache passengers and vessels
        self.passengers = [
            {
                "id": int(r["ID"]),
                "name": f"{r['First_Name']} {r['Last_Name']}",
                "first": r["First_Name"],
                "last": r["Last_Name"]
            }
            for r in self._passenger_dal.get_all()
        ]
        self.vessels = [{"id": int(v["ID"]), "name": v["Vessel"]} for v in self._vessel_dal.get_all()]

    def get_passengers(self):
        return [{"id": p["id"], "name": p["name"]} for p in self.passengers]

    def get_vessels(self):
        return [{"id": v["id"], "name": v["name"]} for v in self.vessels]

    def get_trips(self):
        rows = self._trip_dal.get_all_view()
        trips = []
        for i, r in enumerate(rows, start=1):
            start_txt = r.get("Date and Time", "")
            # ✅ Fix: Parse format like "03/15/2025 @ 11:30 AM"
            try:
                s_dt = datetime.strptime(start_txt, "%m/%d/%Y @ %I:%M %p")
            except ValueError:
                s_dt = datetime.now()  # fallback if parsing fails

            # Duration and end time
            dur = float(r.get("Trip Duration", 2.0))
            e_dt = s_dt + timedelta(hours=dur)

            trips.append({
                "id": r.get("TripID", i),  # Use row number if TripID missing
                "passenger_name": r.get("Passenger Name", ""),
                "vessel_name": r.get("Vessel Name", ""),
                "start_datetime_str": s_dt.strftime("%Y-%m-%d %H:%M"),
                "end_datetime_str": e_dt.strftime("%Y-%m-%d %H:%M"),
                "price_str": str(r.get("Total Cost", "0.00"))
            })
        return trips

    # ✅ Double-booking prevention helpers
    def _overlaps(self, start_a, end_a, start_b, end_b):
        """True if [start_a, end_a) intersects [start_b, end_b)."""
        return start_a < end_b and start_b < end_a

    def _would_double_book(self, passenger_name, vessel_name, start_dt, end_dt):
        """Check existing trips to prevent double-booking for passenger or vessel."""
        for t in self.get_trips():
            t_start = datetime.strptime(t["start_datetime_str"], "%Y-%m-%d %H:%M")
            t_end = datetime.strptime(t["end_datetime_str"], "%Y-%m-%d %H:%M")
            same_passenger = (t["passenger_name"].strip().lower() == passenger_name.strip().lower())
            same_vessel = (t["vessel_name"].strip().lower() == vessel_name.strip().lower())
            if (same_passenger or same_vessel) and self._overlaps(start_dt, end_dt, t_start, t_end):
                return True
        return False

    def add_trip(self, passenger_id, vessel_id, start_datetime, end_datetime, price=0.0):
        p = next((x for x in self.passengers if x["id"] == passenger_id), None)
        v = next((x for x in self.vessels if x["id"] == vessel_id), None)
        if not p or not v:
            return False, "Invalid passenger or vessel."
        if end_datetime <= start_datetime:
            return False, "End time must be after start time."

        # 🔒 Double-booking prevention
        if self._would_double_book(p["name"], v["name"], start_datetime, end_datetime):
            return False, "Double-booking detected for passenger or vessel in the given time window."

        length_hours = (end_datetime - start_datetime).total_seconds() / 3600.0
        result = self._trip_dal.add_trip(
            v["name"], p["first"], p["last"],
            start_datetime.strftime("%Y-%m-%d"),
            start_datetime.strftime("%H:%M:%S"),
            length_hours, 1
        )

        if result["status"] == "inserted":
            self._db.commit()
            return True, "Trip added successfully."
        else:
            self._db.rollback()
            return False, "Duplicate or error adding trip."
