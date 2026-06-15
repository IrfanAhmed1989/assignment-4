# DAL.py
# Data Access Layer - connection manager only (step 4)

import mysql.connector
from mysql.connector import Error


class Db:
    """
    Lightweight connection manager for MySQL.
    View/BLL will pass host, port, user, password, and database='mrc'.
    """

    def __init__(self):
        self.cnx = None

    def connect(self, host: str, port: int, user: str, password: str, database: str = "mrc"):
        """
        Open a connection to MySQL.
        Raises a clear exception message if connection fails.
        """
        try:
            self.cnx = mysql.connector.connect(
                host=host,
                port=port,
                user=user,
                password=password,
                database=database,
                autocommit=False,
            )
            if not self.cnx or not self.cnx.is_connected():
                raise RuntimeError("Connection failed: unknown reason.")
        except Error as e:
            raise RuntimeError(f"MySQL connection error: {e}")

    def cursor(self):
        """
        Get a buffered cursor (safe for stored procedures and multiple fetches).
        Caller must close the cursor after use.
        """
        if not self.cnx or not self.cnx.is_connected():
            raise RuntimeError("No active MySQL connection. Call connect() first.")
        return self.cnx.cursor(buffered=True)

    def commit(self):
        if self.cnx and self.cnx.is_connected():
            self.cnx.commit()

    def rollback(self):
        if self.cnx and self.cnx.is_connected():
            self.cnx.rollback()

    def close(self):
        try:
            if self.cnx and self.cnx.is_connected():
                self.cnx.close()
        except Exception:
            pass
# ---------- READ-ONLY DAL CLASSES (step 5) ----------

class VesselDAL:
    def __init__(self, db: Db):
        self.db = db

    def get_all(self):
        """
        Calls the stored procedure getVesselList()
        Returns a list of dicts: [{'ID': ..., 'Vessel': ..., 'Cost_Per_Hour': ...}, ...]
        """
        cur = self.db.cursor()
        try:
            cur.callproc("getVesselList")
            rows = []
            for result in cur.stored_results():
                cols = [d[0] for d in result.description]
                for r in result.fetchall():
                    rows.append(dict(zip(cols, r)))
            return rows
        finally:
            cur.close()

    def get_id_by_name(self, name: str) -> int:
        """
        Uses the function getVesselID(name). Returns the ID or -1 if not found.
        """
        cur = self.db.cursor()
        try:
            cur.execute("SELECT getVesselID(%s)", (name,))
            (vid,) = cur.fetchone()
            return int(vid) if vid is not None else -1
        finally:
            cur.close()

    def add(self, name: str, cost_per_hour: float) -> int:
        """
        Calls the stored procedure addVessel(name, cost_per_hour).
        Returns the VesselID (existing or newly inserted).
        """
        cur = self.db.cursor()
        try:
            cur.callproc("addVessel", (name, cost_per_hour))
            vessel_id = None
            for result in cur.stored_results():
                # Expect one row with alias 'VesselID'
                row = result.fetchone()
                if row is not None:
                    cols = [d[0] for d in result.description] if result.description else []
                    if cols and "VesselID" in cols:
                        vessel_id = row[cols.index("VesselID")]
                    else:
                        vessel_id = row[0]
            if vessel_id is None:
                raise RuntimeError("addVessel did not return VesselID.")
            return int(vessel_id)
        finally:
            cur.close()


class PassengerDAL:
    def __init__(self, db: Db):
        self.db = db

    def get_all(self):
        """
        Calls the stored procedure getPassengerList()
        Returns a list of dicts with passenger columns.
        """
        cur = self.db.cursor()
        try:
            cur.callproc("getPassengerList")
            rows = []
            for result in cur.stored_results():
                cols = [d[0] for d in result.description]
                for r in result.fetchall():
                    rows.append(dict(zip(cols, r)))
            return rows
        finally:
            cur.close()

    def get_id_by_name(self, first_name: str, last_name: str) -> int:
        """
        Uses the function getPassengerID(first, last). Returns the ID or -1 if not found.
        """
        cur = self.db.cursor()
        try:
            cur.execute("SELECT getPassengerID(%s, %s)", (first_name, last_name))
            (pid,) = cur.fetchone()
            return int(pid) if pid is not None else -1
        finally:
            cur.close()

    def add(self, first_name: str, last_name: str, phone: str) -> int:
        """
        Calls the stored procedure addPassenger(first, last, phone).
        Returns the PassengerID (existing or newly inserted).
        """
        cur = self.db.cursor()
        try:
            cur.callproc("addPassenger", (first_name, last_name, phone))
            passenger_id = None
            for result in cur.stored_results():
                row = result.fetchone()  # expect one row
                if row is not None:
                    cols = [d[0] for d in result.description] if result.description else []
                    if cols and "PassengerID" in cols:
                        passenger_id = row[cols.index("PassengerID")]
                    else:
                        passenger_id = row[0]
            if passenger_id is None:
                raise RuntimeError("addPassenger did not return PassengerID.")
            return int(passenger_id)
        finally:
            cur.close()

class TripDAL:
    def __init__(self, db: Db):
        self.db = db

    def get_all_view(self):
        """
        Preferred: call the stored procedure getTripList(), which returns from `All Trips`.
        Returns a list of dicts matching the view column names.
        """
        cur = self.db.cursor()
        try:
            cur.callproc("getTripList")
            rows = []
            for result in cur.stored_results():
                cols = [d[0] for d in result.description]
                for r in result.fetchall():
                    rows.append(dict(zip(cols, r)))
            return rows
        finally:
            cur.close()

    def get_total_revenue_by_vessel_view(self):
        """
        Select directly from the spaced view name: `total revenue By vessel`
        Returns a list of dicts: [{'Vessel Name': 'Sea Breeze', 'Revenue': '$...'}, ...]
        """
        cur = self.db.cursor()
        try:
            cur.execute("SELECT * FROM `total revenue By vessel`")
            cols = [d[0] for d in cur.description]
            return [dict(zip(cols, r)) for r in cur.fetchall()]
        finally:
            cur.close()

    def add_trip(
        self,
        vessel_name: str,
        passenger_first: str,
        passenger_last: str,
        date_str: str,         # 'YYYY-MM-DD'
        time_str: str,         # 'HH:MM:SS'
        length_hours: float,   # e.g., 3.5
        total_passengers: int  # e.g., 4
    ) -> dict:
        """
        Calls stored procedure addTrip(vesselName, passengerF, passengerL, date, time, length, totalPassengers).

        Returns a dict status:
          - {'status': 'inserted', 'code': 1}                     -> success (no resultset returned)
          - {'status': 'duplicate', 'code': 0}                    -> duplicate trip detected
          - {'status': 'vessel_not_found', 'code': -1}
          - {'status': 'passenger_not_found', 'code': -2}
          - {'status': 'vessel_and_passenger_not_found', 'code': -3}
          - {'status': 'unknown_result', 'code': None}            -> unexpected shape
        """
        cur = self.db.cursor()
        try:
            cur.callproc(
                "addTrip",
                (vessel_name, passenger_first, passenger_last, date_str, time_str, length_hours, total_passengers)
            )

            # The procedure SELECTs a row ONLY for duplicate/missing cases.
            for result in cur.stored_results():
                row = result.fetchone()
                if row is not None:
                    cols = [d[0] for d in result.description] if result.description else []
                    if "DuplicateTrip" in cols:
                        return {"status": "duplicate", "code": 0}
                    if "NotFound" in cols:
                        val = int(row[cols.index("NotFound")]) if cols else int(row[0])
                        if val == -1:
                            return {"status": "vessel_not_found", "code": -1}
                        elif val == -2:
                            return {"status": "passenger_not_found", "code": -2}
                        elif val == -3:
                            return {"status": "vessel_and_passenger_not_found", "code": -3}
                        else:
                            return {"status": "unknown_result", "code": val}
                    # Fallback if some other column came back:
                    return {"status": "unknown_result", "code": None}

            # If no resultset rows were returned, the insert succeeded.
            return {"status": "inserted", "code": 1}

        finally:
            cur.close()                      