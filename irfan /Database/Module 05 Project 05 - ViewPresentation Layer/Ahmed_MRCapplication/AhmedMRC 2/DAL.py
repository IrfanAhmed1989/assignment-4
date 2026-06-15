
# DAL.py
import mysql.connector
from mysql.connector import Error

class Db:
    def __init__(self):
        self.cnx = None

    def connect(self, host: str, port: int, user: str, password: str, database: str = "mrc"):
        try:
            self.cnx = mysql.connector.connect(
                host=host,
                port=port,
                user=user,
                password=password,
                database=database,
                autocommit=False
            )
            if not self.cnx.is_connected():
                raise RuntimeError("Connection failed.")
        except Error as e:
            raise RuntimeError(f"MySQL connection error: {e}")

    def cursor(self):
        if not self.cnx or not self.cnx.is_connected():
            raise RuntimeError("No active MySQL connection.")
        return self.cnx.cursor(buffered=True)

    def commit(self):
        if self.cnx and self.cnx.is_connected():
            self.cnx.commit()

    def rollback(self):
        if self.cnx and self.cnx.is_connected():
            self.cnx.rollback()

    def close(self):
        if self.cnx and self.cnx.is_connected():
            self.cnx.close()


class VesselDAL:
    def __init__(self, db: Db):
        self.db = db

    def get_all(self):
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


class PassengerDAL:
    def __init__(self, db: Db):
        self.db = db

    def get_all(self):
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


class TripDAL:
    def __init__(self, db: Db):
        self.db = db

    def get_all_view(self):
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

    def add_trip(self, vessel_name, passenger_first, passenger_last, date_str, time_str, length_hours, total_passengers):
        cur = self.db.cursor()
        try:
            cur.callproc("addTrip", (vessel_name, passenger_first, passenger_last, date_str, time_str, length_hours, total_passengers))
            for result in cur.stored_results():
                row = result.fetchone()
                if row:
                    return {"status": "duplicate", "code": 0}
            return {"status": "inserted", "code": 1}
        finally:
            cur.close()

