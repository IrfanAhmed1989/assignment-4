# BLL.py
# Read + Write business logic wrappers (Step 14)

from DAL import Db, VesselDAL, PassengerDAL, TripDAL


class RevenueService:
    """High-level access to revenue-related queries."""
    def __init__(self, db: Db):
        self.trip_dal = TripDAL(db)

    def total_by_vessel(self):
        """
        Returns a list of dicts:
        [{'Vessel Name': 'Sea Breeze', 'Revenue': '$600.00'}, ...]
        """
        return self.trip_dal.get_total_revenue_by_vessel_view()


class LookupService:
    """Lookup helpers that normalize -1 (not found) into a clear shape."""
    def __init__(self, db: Db):
        self.vessel_dal = VesselDAL(db)
        self.passenger_dal = PassengerDAL(db)

    def vessel_id(self, name: str):
        vid = self.vessel_dal.get_id_by_name(name)
        return {"found": vid != -1, "id": vid}

    def passenger_id(self, first: str, last: str):
        pid = self.passenger_dal.get_id_by_name(first, last)
        return {"found": pid != -1, "id": pid}


class TripService:
    """Trip queries + write orchestration."""
    def __init__(self, db: Db):
        self.db = db
        self.trip_dal = TripDAL(db)
        self.vessel_dal = VesselDAL(db)
        self.passenger_dal = PassengerDAL(db)

    # ---------- READ ----------
    def all_trips(self):
        """
        Returns a list of dicts matching the `All Trips` view columns:
        ['Date and Time','Vessel Name','Passenger Name','Passenger Address','Passenger Phone','Trip Duration','Total Cost']
        """
        return self.trip_dal.get_all_view()

    # ---------- WRITE ORCHESTRATION ----------
    def add_trip_with_new_entities(
        self,
        vessel_name: str,
        vessel_cost_per_hour: float,
        passenger_first: str,
        passenger_last: str,
        passenger_phone: str,
        date_str: str,       # 'YYYY-MM-DD'
        time_str: str,       # 'HH:MM:SS'
        length_hours: float, # e.g., 3.5
        total_passengers: int
    ) -> dict:
        """
        Orchestrates:
          1) addVessel (idempotent in SQL; inserts if needed, returns ID)
          2) addPassenger (idempotent in SQL; inserts if needed, returns ID)
          3) addTrip (may return duplicate / not-found codes, or insert)
        Commits on successful insert; otherwise rolls back.

        Returns dict:
          {
            'ok': True/False,
            'action': 'inserted' | 'duplicate' | 'missing',
            'detail': str,
            'status': code_int
          }
        """
        try:
            # 1) Ensure vessel exists, get ID (procedure is idempotent)
            vessel_id = self.vessel_dal.add(vessel_name, vessel_cost_per_hour)

            # 2) Ensure passenger exists, get ID (procedure is idempotent)
            passenger_id = self.passenger_dal.add(passenger_first, passenger_last, passenger_phone)

            # 3) Try to add the trip by names (per the stored procedure signature)
            result = self.trip_dal.add_trip(
                vessel_name=vessel_name,
                passenger_first=passenger_first,
                passenger_last=passenger_last,
                date_str=date_str,
                time_str=time_str,
                length_hours=length_hours,
                total_passengers=total_passengers
            )

            status = result.get("status")
            code = result.get("code")

            if status == "inserted":
                # Only now do we commit
                self.db.commit()
                return {
                    "ok": True,
                    "action": "inserted",
                    "detail": f"Trip inserted for vessel_id={vessel_id}, passenger_id={passenger_id}.",
                    "status": code
                }

            # Any other status: do not commit; report gracefully
            self.db.rollback()

            if status == "duplicate":
                return {
                    "ok": False,
                    "action": "duplicate",
                    "detail": "Duplicate trip (same vessel+passenger+date+time).",
                    "status": code
                }
            elif status in ("vessel_not_found", "passenger_not_found", "vessel_and_passenger_not_found"):
                return {
                    "ok": False,
                    "action": "missing",
                    "detail": status.replace("_", " "),
                    "status": code
                }
            else:
                return {
                    "ok": False,
                    "action": "unknown",
                    "detail": "Unexpected result from addTrip.",
                    "status": code
                }

        except Exception as ex:
            # Safety net: if anything blows up mid‑flow, rollback
            try:
                self.db.rollback()
            except Exception:
                pass
            return {
                "ok": False,
                "action": "error",
                "detail": str(ex),
                "status": None
            }