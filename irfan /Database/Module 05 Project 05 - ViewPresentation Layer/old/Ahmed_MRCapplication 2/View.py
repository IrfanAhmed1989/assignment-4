# View.py
# Step 15: Full workflow — revenue, getVesselID twice, add new vessel+passenger+trip, show All Trips, sea-monster fact
# Ensure local vendored packages in ./libs are importable BEFORE other imports.
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "libs"))

from BLL import RevenueService, LookupService, TripService
from DAL import Db

def prompt(text, default=None):
    if default is None:
        return input(text + ": ").strip()
    v = input(f"{text} [{default}]: ").strip()
    return v if v else default

def print_table(rows, headers, title=None, max_rows=None):
    if title:
        print(title)
    if not rows:
        print("(No rows)")
        return
    if max_rows is not None:
        rows = rows[:max_rows]

    widths = [len(h) for h in headers]
    for r in rows:
        for i, h in enumerate(headers):
            widths[i] = max(widths[i], len(str(r.get(h, ""))))
    def line(sep_left="+", sep_mid="+", sep_right="+"):
        return sep_left + sep_mid.join("-" * (w + 2) for w in widths) + sep_right
    def row(values):
        return "| " + " | ".join(str(v).ljust(widths[i]) for i, v in enumerate(values)) + " |"

    print(line())
    print(row(headers))
    print(line(sep_mid="+"))
    for r in rows:
        print(row([r.get(h, "") for h in headers]))
    print(line())

def main():
    print("MRC Console — Step 15: Full Workflow Demo\n")

    # --- DB prompts ---
    host = prompt("MySQL host", "localhost")
    port = int(prompt("MySQL port", "3306"))
    user = prompt("MySQL user", "root")
    password = prompt("MySQL password", "")
    database = prompt("MySQL database", "mrc")

    db = Db()
    try:
        db.connect(host=host, port=port, user=user, password=password, database=database)
        print("\nConnected successfully.\n")

        # Services
        revenue_service = RevenueService(db)
        lookup = LookupService(db)
        trip_service = TripService(db)

        # --- Part A: Total Revenue by Vessel ---
        revenue_rows = revenue_service.total_by_vessel()
        print_table(revenue_rows, headers=["Vessel Name", "Revenue"], title="Total Revenue by Vessel")

        # --- Part B: getVesselID() lookups (one match, one no-match) ---
        known_name = "Sea Breeze"   # expected to exist
        unknown_name = "Sea Bream"  # intentionally does not exist
        known = lookup.vessel_id(known_name)
        unknown = lookup.vessel_id(unknown_name)
        print("\ngetVesselID() lookups:")
        print(f"  • '{known_name}' -> found={known['found']}, id={known['id']}")
        print(f"  • '{unknown_name}' -> found={unknown['found']}, id={unknown['id']}")

        # --- Part C: Add NEW vessel + NEW passenger + NEW trip (then commit on success) ---
        # Choose values unlikely to collide with seeds:
        new_vessel_name = "Azure Leviathan"
        new_vessel_cph = 220.00  # cost per hour

        new_pass_first = "Nereus"
        new_pass_last = "Triton"
        new_pass_phone = "555-123-4567"

        # Choose a unique date/time to avoid duplicates
        new_date = "2025-06-29"
        new_time = "14:45:00"
        new_length_hours = 2.5
        new_total_passengers = 4

        print("\nAdding new Vessel + Passenger + Trip...")
        result = trip_service.add_trip_with_new_entities(
            vessel_name=new_vessel_name,
            vessel_cost_per_hour=new_vessel_cph,
            passenger_first=new_pass_first,
            passenger_last=new_pass_last,
            passenger_phone=new_pass_phone,
            date_str=new_date,
            time_str=new_time,
            length_hours=new_length_hours,
            total_passengers=new_total_passengers
        )

        # Report outcome
        if result.get("ok"):
            print(f"SUCCESS: {result.get('action')} — {result.get('detail')}")
        else:
            print(f"FAILED: {result.get('action')} — {result.get('detail')} (status={result.get('status')})")

        # --- Part D: Show All Trips (should include the new trip on success) ---
        print()
        trips = trip_service.all_trips()
        # Show a manageable slice (top 10)
        print_table(
            trips,
            headers=[
                "Date and Time",
                "Vessel Name",
                "Passenger Name",
                "Passenger Address",
                "Passenger Phone",
                "Trip Duration",
                "Total Cost",
            ],
            title="All Trips (Top 10)",
            max_rows=10
        )

        # --- Part E: Sea monster fact (AI assistant requirement) ---
        print("\nSea monster fact:")
        print("  The giant squid (Architeuthis dux) has eyes roughly the size of a dinner plate—")
        print("  among the largest in the animal kingdom—helping it detect predators like sperm whales in the deep ocean.\n")

    except Exception as ex:
        print(f"\nError: {ex}")
    finally:
        db.close()

if __name__ == "__main__":
    main()