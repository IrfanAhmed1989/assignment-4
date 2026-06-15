
from DAL import Db, PassengerDAL, VesselDAL, TripDAL
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional, Tuple

class BLL:
    def __init__(self) -> None:
        # --- Connect and load from DAL ---
        self._db = Db()
        try:
            # Adjust credentials to match your local MySQL setup
            self._db.connect(
                host="localhost",
                port=3306,
                user="root",
                password="",
                database="mrc",
            )

            # Passengers via DAL
            self._passenger_dal = PassengerDAL(self._db)
            db_passengers = self._passenger_dal.get_all()

            # Map passengers using exact column names from getPassengerList()
            self.passengers = []
            for r in db_passengers:
                try:
                    pid = int(r["ID"])
                    first = str(r.get("First_Name", "")).strip()
                    last = str(r.get("Last_Name", "")).strip()
                    display_name = (f"{first} {last}").strip() or f"Passenger #{pid}"
                    self.passengers.append({
                        "id": pid,
                        "name": display_name,  # used by GUI dropdown
                        "first": first,        # used by addTrip stored procedure
                        "last": last,          # used by addTrip stored procedure
                    })
                except Exception:
                    # DEBUG print removed
                    continue

            # Vessels via DAL
            self._vessel_dal = VesselDAL(self._db)
            db_vessels = self._vessel_dal.get_all()
            self.vessels: List[Dict[str, Any]] = [
                {"id": int(v.get("ID")), "name": str(v.get("Vessel"))}
                for v in db_vessels
                if v.get("ID") is not None and v.get("Vessel") is not None
            ]

            # TripDAL (for View All Trips + Add Trip)
            self._trip_dal = TripDAL(self._db)
            # DEBUG print removed
        except Exception:
            # Fallback when DB connect / DAL calls fail
            try:
                import traceback
                # DEBUG prints removed
                # traceback.print_exc()
            except Exception:
                pass

            self.passengers = [
                {"id": 1, "name": "Ada Lovelace", "first": "Ada", "last": "Lovelace"},
                {"id": 2, "name": "Alan Turing", "first": "Alan", "last": "Turing"},
            ]
            self.vessels = [
                {"id": 1, "name": "Nautilus"},
                {"id": 2, "name": "Beagle"},
            ]
            # In-memory trips for GUI rendering when DB is unavailable
            self.trips: List[Dict[str, Any]] = [
                {
                    "id": 1,
                    "passenger_id": 1,
                    "vessel_id": 1,
                    "start_datetime": datetime(1815, 12, 10, 9, 30),
                    "price": 0.0,
                },
                {
                    "id": 2,
                    "passenger_id": 2,
                    "vessel_id": 2,
                    "start_datetime": datetime(1815, 12, 10, 11, 0),
                    "price": 0.0,
                },
            ]
            self._next_trip_id: int = 3

    # ---------------------- Optional auth ----------------------
    def login(self, username: str, password: str) -> Tuple[bool, str]:
        if not username or not password:
            return False, "Please enter both username and password."
        return True, ""

    # ---------------------- Dropdown data ----------------------
    def get_passengers(self) -> List[Dict[str, Any]]:
        """Return list of passengers: [{'id', 'name'}, ...]"""
        return [{"id": p["id"], "name": p["name"]} for p in self.passengers]

    def get_vessels(self) -> List[Dict[str, Any]]:
        """Return list of vessels: [{'id', 'name'}, ...]"""
        return list(self.vessels)

    # --------- DB-backed get_trips ----------
    def get_trips(self):
        """
        Return rows for the GUI table pulled from the DB view via TripDAL:
        - 'Passenger Name' -> passenger_name
        - 'Vessel Name' -> vessel_name
        - 'Date and Time' -> start_datetime_str
        - 'Trip Duration' -> used to derive end_datetime_str (fallback 2h)
        - 'Total Cost' -> price_str
        - 'TripID' (if present) -> id
        Falls back to the in-memory trips if the DB call fails.
        """
        from datetime import datetime, timedelta
        # Preferred path: read from DB view via stored procedure getTripList()
        try:
            if not hasattr(self, "_trip_dal") or self._trip_dal is None:
                raise RuntimeError("TripDAL not available")
            rows = self._trip_dal.get_all_view()  # returns list[dict] from `All Trips`
            out: List[Dict[str, Any]] = []
            for r in rows:
                start_txt = str(r.get("Date and Time", "")).strip()
                vessel_txt = str(r.get("Vessel Name", "")).strip()
                passenger_txt = str(r.get("Passenger Name", "")).strip()
                price_txt = str(r.get("Total Cost", "")).strip()

                # Derive end from Trip Duration if available; else default 2h
                end_txt = ""
                try:
                    if start_txt:
                        # parse "YYYY-MM-DD HH:MM[:SS]"
                        fmt = "%Y-%m-%d %H:%M:%S" if start_txt.count(":") == 2 else "%Y-%m-%d %H:%M"
                        s_dt = datetime.strptime(start_txt, fmt)
                        dur = r.get("Trip Duration")
                        hours = float(dur) if dur is not None else 2.0
                        e_dt = s_dt + timedelta(hours=hours)
                        end_txt = e_dt.strftime("%Y-%m-%d %H:%M")
                except Exception:
                    end_txt = ""

                trip_id = r.get("TripID", "")
                out.append({
                    "id": trip_id,
                    "passenger_name": passenger_txt,
                    "vessel_name": vessel_txt,
                    "start_datetime_str": start_txt,
                    "end_datetime_str": end_txt,
                    "price_str": price_txt,
                })
            out.sort(key=lambda k: k.get("start_datetime_str", ""))
            return out
        except Exception:
            # Fallback to in-memory formatting if the DB call fails
            result: List[Dict[str, Any]] = []

            def name_by_id(rows: List[Dict[str, Any]], id_: int) -> str:
                for rr in rows:
                    if rr["id"] == id_:
                        return rr["name"]
                return f"#{id_}"

            for t in getattr(self, "trips", []):
                s: datetime = t["start_datetime"]
                e: datetime = t.get("end_datetime") or (s + timedelta(hours=2))
                price: float = float(t.get("price", 0.0))
                result.append({
                    "id": t.get("id", ""),
                    "passenger_name": name_by_id(self.passengers, t["passenger_id"]),
                    "vessel_name": name_by_id(self.vessels, t["vessel_id"]),
                    "start_datetime_str": s.strftime("%Y-%m-%d %H:%M"),
                    "end_datetime_str": e.strftime("%Y-%m-%d %H:%M"),
                    "price_str": f"{price:.2f}",
                })
            result.sort(key=lambda r: r.get("start_datetime_str", ""))
            return result

    # ------------------ Add Trip ------------------
    def add_trip(
        self,
        passenger_id: int,
        vessel_id: int,
        start_datetime: Optional[datetime],
        end_datetime: Optional[datetime] = None,
        price: Optional[float] = 0.0,
    ) -> Tuple[bool, str]:
        """
        Insert a trip into DB via TripDAL.add_trip(...) while enforcing:
        - Entities exist
        - End after Start
        - Overlap prevention using current DB trips (view)
        """
        # Ensure DAL is available
        if not hasattr(self, "_trip_dal"):
            return False, "Database not available (TripDAL missing)."

        # Resolve entities exist
        p = next((x for x in self.passengers if x["id"] == passenger_id), None)
        v = next((x for x in self.vessels if x["id"] == vessel_id), None)
        if not p or not v:
            return False, "Invalid passenger or vessel."

        # Defaults if GUI passes None
        if start_datetime is None:
            start_datetime = datetime(1815, 12, 10, 9, 30)
        if end_datetime is None:
            end_datetime = start_datetime + timedelta(hours=2)

        # Basic validation
        if end_datetime <= start_datetime:
            return False, "End date/time must be after start date/time."

        # Compute trip length in hours
        length_hours = (end_datetime - start_datetime).total_seconds() / 3600.0
        if length_hours <= 0:
            return False, "Trip length must be greater than zero."

        # Overlap prevention using current DB trips
        try:
            existing = self._trip_dal.get_all_view()
        except Exception as e:
            return False, f"Error reading existing trips from DB: {e}"

        # Helper: always returns a tuple (None, None on failure)
        def parse_row_start_end(row: Dict[str, Any]) -> Tuple[Optional[datetime], Optional[datetime]]:
            s_txt = str(row.get("Date and Time", "")).strip()
            if not s_txt:
                return None, None

            fmts = [
                "%m/%d/%Y %I:%M %p",      # e.g., 03/01/2025 09:00 AM
                "%m/%d/%Y %I:%M:%S %p",
                "%Y-%m-%d %H:%M",         # e.g., 1815-12-10 09:30
                "%Y-%m-%d %H:%M:%S",
            ]

            s_dt: Optional[datetime] = None
            for fmt in fmts:
                try:
                    s_dt = datetime.strptime(s_txt, fmt)
                    break
                except Exception:
                    continue

            if s_dt is None:
                return None, None

            dur = row.get("Trip Duration")
            try:
                hours = float(dur) if dur is not None else 2.0
            except Exception:
                hours = 2.0
            e_dt = s_dt + timedelta(hours=hours)
            return s_dt, e_dt

        # ---------------------------------------------------------------------
        # Overlap section (indentation restored using the robust snippet)
        # ---------------------------------------------------------------------

        # New trip window
        new_start = start_datetime
        new_end   = end_datetime
        p_fullname = p["name"].strip()
        v_name     = v["name"].strip()

        def overlaps(a_start: datetime, a_end: datetime, b_start: datetime, b_end: datetime) -> bool:
            return (a_start < b_end) and (b_start < a_end)

        # Check existing rows from DB view for conflicts
        for row in existing:
            s_dt, e_dt = parse_row_start_end(row)
            if s_dt is None or e_dt is None:
                continue  # skip rows we can't parse

            row_passenger = str(row.get("Passenger Name", "")).strip()
            row_vessel    = str(row.get("Vessel Name", "")).strip()

            # If same passenger and times overlap → block
            if row_passenger == p_fullname and overlaps(new_start, new_end, s_dt, e_dt):
                return False, "Double booking: passenger already booked at that time."

            # If same vessel and times overlap → block
            if row_vessel == v_name and overlaps(new_start, new_end, s_dt, e_dt):
                return False, "Double booking: vessel already booked at that time."

        # Insert via DAL stored procedure addTrip(...)
        date_str = start_datetime.strftime("%Y-%m-%d")
        time_str = start_datetime.strftime("%H:%M:%S")
        passenger_first = p.get("first", p_fullname.split(" ")[0])
        passenger_last = p.get("last", " ".join(p_fullname.split(" ")[1:]) or p_fullname.split(" ")[0])
        vessel_name = v_name
        total_passengers = 1  # GUI doesn't collect this; default to 1
        try:
            result = self._trip_dal.add_trip(
                vessel_name=vessel_name,
                passenger_first=passenger_first,
                passenger_last=passenger_last,
                date_str=date_str,
                time_str=time_str,
                length_hours=length_hours,
                total_passengers=total_passengers,
            )
        except Exception as e:
            return False, f"Error inserting trip via DAL: {e}"

        status = result.get("status")
        code = result.get("code")
        if status == "inserted" and code == 1:
            # Persist to DB: commit
            try:
                self._db.commit()
            except Exception:
                pass
            return True, "Trip added successfully."
        elif status == "duplicate":
            return False, "Duplicate trip (same vessel/passenger/date/time/length)."
        elif status == "vessel_not_found":
            return False, "Vessel not found in DB."
        elif status == "passenger_not_found":
            return False, "Passenger not found in DB."
        elif status == "vessel_and_passenger_not_found":
            return False, "Vessel and passenger not found in DB."
        else:
            return False, f"Unexpected DB result (status={status}, code={code})."

