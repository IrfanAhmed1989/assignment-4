
# GUI.py
# GUI View Layer: Login -> Main Menu -> View All Trips / Add Trip
import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime as _dt

from BLL import BLL

# Shared BLL instance so state persists across screens
APP_BLL = BLL()


# ---------- Helpers ----------
def clear_content(root: tk.Tk) -> ttk.Frame:
    """Destroy any existing content frame and create a new one."""
    # Remove previous content frames (marked via attribute)
    for child in root.winfo_children():
        if isinstance(child, ttk.Frame) and getattr(child, "_is_content", False):
            child.destroy()

    content = ttk.Frame(root, padding=10)
    content._is_content = True  # marker
    content.grid(row=1, column=0, sticky="nsew")
    root.grid_rowconfigure(1, weight=1)
    root.grid_columnconfigure(0, weight=1)
    return content


def compose_dt_from_spins(year_spin, month_spin, day_spin, hour_spin, minute_spin) -> _dt:
    """Build a datetime from five Spinboxes."""
    y = int(year_spin.get())
    m = int(month_spin.get())
    d = int(day_spin.get())
    hh = int(hour_spin.get())
    mm = int(minute_spin.get())
    return _dt(y, m, d, hh, mm)


def find_id_by_name(rows, selected_name: str) -> int:
    """rows: [{'id': int, 'name': '...'}]; return matching id by name."""
    for r in rows:
        if r.get("name") == selected_name:
            return r.get("id")
    raise ValueError(f"Could not find ID for {selected_name!r}")


# ---------- Screens ----------
def show_login(root: tk.Tk):
    root.title("MRC App - GUI (View All Trips via BLL)")
    root.geometry("860x520")

    # Header (title only on login)
    header = ttk.Frame(root, padding=10)
    header.grid(row=0, column=0, sticky="ew")
    ttk.Label(header, text="Login", font=("Segoe UI", 16, "bold")).pack(side="left")

    content = clear_content(root)

    username_var = tk.StringVar()
    password_var = tk.StringVar()
    status_var = tk.StringVar(value="")

    frm = ttk.Frame(content)
    frm.pack(pady=40)

    ttk.Label(frm, text="Username:", font=("Segoe UI", 11)).grid(row=0, column=0, sticky="e", padx=8, pady=6)
    ttk.Entry(frm, textvariable=username_var, width=28).grid(row=0, column=1, sticky="w", padx=8, pady=6)

    ttk.Label(frm, text="Password:", font=("Segoe UI", 11)).grid(row=1, column=0, sticky="e", padx=8, pady=6)
    ttk.Entry(frm, textvariable=password_var, width=28, show="•").grid(row=1, column=1, sticky="w", padx=8, pady=6)

    ttk.Label(frm, textvariable=status_var, foreground="#666", font=("Segoe UI", 10)).grid(
        row=2, column=0, columnspan=2, sticky="w", padx=8, pady=(4, 10)
    )

    def handle_login():
        u = username_var.get().strip()
        p = password_var.get().strip()
        # Your course allows non-empty creds; if you later require strict BLL login, replace this:
        if u and p:
            show_main_menu(root, u)
        else:
            status_var.set("Please enter both username and password.")

    ttk.Button(frm, text="Login", command=handle_login).grid(row=3, column=0, columnspan=2, pady=8)
    frm.columnconfigure(1, weight=1)


def show_main_menu(root: tk.Tk, username: str):
    # Header with welcome + logout
    header = ttk.Frame(root, padding=10)
    header.grid(row=0, column=0, sticky="ew")

    ttk.Label(header, text=f"Welcome, {username}", font=("Segoe UI", 12)).pack(side="left")
    ttk.Button(header, text="Logout", command=lambda: show_login(root)).pack(side="right")

    # Actions bar
    actions = ttk.Frame(root, padding=10)
    actions.grid(row=2, column=0, sticky="ew")
    ttk.Button(actions, text="View All Trips", command=lambda: show_view_trips(root)).pack(side="left", padx=(0, 10))
    ttk.Button(actions, text="Add Trip", command=lambda: show_add_trip(root)).pack(side="left")

    # Default view
    show_view_trips(root)


def show_view_trips(root: tk.Tk):
    content = clear_content(root)

    ttk.Label(content, text="View All Trips", font=("Segoe UI", 14, "bold")).grid(
        row=0, column=0, sticky="w", pady=(0, 8)
    )

    columns = ("id", "passenger", "vessel", "start_datetime", "end_datetime", "price")
    tree = ttk.Treeview(content, columns=columns, show="headings", height=14)
    tree.grid(row=1, column=0, sticky="nsew")

    # Headings
    tree.heading("id", text="ID")
    tree.heading("passenger", text="Passenger")
    tree.heading("vessel", text="Vessel")
    tree.heading("start_datetime", text="Start (YYYY-MM-DD HH:MM)")
    tree.heading("end_datetime", text="End (YYYY-MM-DD HH:MM)")
    tree.heading("price", text="Price")

    # Column widths
    tree.column("id", width=60, anchor="center")
    tree.column("passenger", width=220)
    tree.column("vessel", width=180)
    tree.column("start_datetime", width=220)
    tree.column("end_datetime", width=220)
    tree.column("price", width=100, anchor="e")

    # Data
    rows = []
    try:
        rows = APP_BLL.get_trips()
    except Exception as e:
        messagebox.showerror("Error", f"Error loading trips: {e}")

    for t in rows:
        tree.insert(
            "",
            "end",
            values=(
                t.get("id"),
                t.get("passenger_name"),
                t.get("vessel_name"),
                t.get("start_datetime_str"),
                t.get("end_datetime_str", ""),                  # safe if not present yet
                t.get("price_str", "0.00"),                     # safe default
            ),
        )

    # Scrollbar
    yscroll = ttk.Scrollbar(content, orient="vertical", command=tree.yview)
    tree.configure(yscrollcommand=yscroll.set)
    yscroll.grid(row=1, column=1, sticky="ns")

    # Stretch
    content.columnconfigure(0, weight=1)
    content.rowconfigure(1, weight=1)


def show_add_trip(root: tk.Tk):
    content = clear_content(root)

    ttk.Label(content, text="Add Trip", font=("Segoe UI", 14, "bold")).grid(
        row=0, column=0, columnspan=6, pady=(0, 8)
    )
    feedback = tk.StringVar(value="")
    ttk.Label(content, textvariable=feedback, foreground="#666").grid(
        row=1, column=0, columnspan=6, sticky="w", pady=(0, 8)
    )

    # Load dropdown options
    try:
        passengers = APP_BLL.get_passengers()  # [{"id": 1, "name": "..."}]
        vessels = APP_BLL.get_vessels()        # [{"id": 1, "name": "..."}]
    except Exception as e:
        passengers, vessels = [], []
        feedback.set(f"Error loading dropdowns: {e}")

    # Passenger dropdown
    ttk.Label(content, text="Passenger:", font=("Segoe UI", 11)).grid(row=2, column=0, sticky="e", padx=6, pady=6)
    passenger_names = [p["name"] for p in passengers]
    passenger_combo = ttk.Combobox(content, values=passenger_names, state="readonly", width=26)
    passenger_combo.grid(row=2, column=1, sticky="w", padx=6, pady=6)
    if passenger_names:
        passenger_combo.current(0)

    # Vessel dropdown
    ttk.Label(content, text="Vessel:", font=("Segoe UI", 11)).grid(row=2, column=2, sticky="e", padx=6, pady=6)
    vessel_names = [v["name"] for v in vessels]
    vessel_combo = ttk.Combobox(content, values=vessel_names, state="readonly", width=24)
    vessel_combo.grid(row=2, column=3, sticky="w", padx=6, pady=6)
    if vessel_names:
        vessel_combo.current(0)

    # Start Date (Y-M-D)
    ttk.Label(content, text="Date (Y-M-D):", font=("Segoe UI", 11)).grid(row=3, column=0, sticky="e", padx=6, pady=6)
    year_spin = tk.Spinbox(content, from_=1500, to=2100, width=6)
    month_spin = tk.Spinbox(content, from_=1, to=12, width=4)
    day_spin = tk.Spinbox(content, from_=1, to=31, width=4)
    year_spin.grid(row=3, column=1, sticky="w", padx=(6, 0))
    month_spin.grid(row=3, column=1, sticky="w", padx=(62, 0))
    day_spin.grid(row=3, column=1, sticky="w", padx=(110, 0))
    year_spin.delete(0, "end");  year_spin.insert(0, "1815")
    month_spin.delete(0, "end"); month_spin.insert(0, "12")
    day_spin.delete(0, "end");   day_spin.insert(0, "10")

    # Start Time (H:M)
    ttk.Label(content, text="Time (H:M):", font=("Segoe UI", 11)).grid(row=3, column=2, sticky="e", padx=6, pady=6)
    hour_spin = tk.Spinbox(content, from_=0, to=23, width=4)
    minute_spin = tk.Spinbox(content, from_=0, to=59, width=4)
    hour_spin.grid(row=3, column=3, sticky="w", padx=(6, 0))
    minute_spin.grid(row=3, column=3, sticky="w", padx=(56, 0))
    hour_spin.delete(0, "end");   hour_spin.insert(0, "9")
    minute_spin.delete(0, "end"); minute_spin.insert(0, "30")

    # End Date (Y-M-D)
    ttk.Label(content, text="End (Y-M-D):", font=("Segoe UI", 11)).grid(row=4, column=0, sticky="e", padx=6, pady=6)
    end_year_spin = tk.Spinbox(content, from_=1500, to=2100, width=6)
    end_month_spin = tk.Spinbox(content, from_=1, to=12, width=4)
    end_day_spin = tk.Spinbox(content, from_=1, to=31, width=4)
    end_year_spin.grid(row=4, column=1, sticky="w", padx=(6, 0))
    end_month_spin.grid(row=4, column=1, sticky="w", padx=(62, 0))
    end_day_spin.grid(row=4, column=1, sticky="w", padx=(110, 0))
    end_year_spin.delete(0, "end");  end_year_spin.insert(0, "1815")
    end_month_spin.delete(0, "end"); end_month_spin.insert(0, "12")
    end_day_spin.delete(0, "end");   end_day_spin.insert(0, "10")

    # End Time (H:M)
    ttk.Label(content, text="End (H:M):", font=("Segoe UI", 11)).grid(row=4, column=2, sticky="e", padx=6, pady=6)
    end_hour_spin = tk.Spinbox(content, from_=0, to=23, width=4)
    end_minute_spin = tk.Spinbox(content, from_=0, to=59, width=4)
    end_hour_spin.grid(row=4, column=3, sticky="w", padx=(6, 0))
    end_minute_spin.grid(row=4, column=3, sticky="w", padx=(56, 0))
    end_hour_spin.delete(0, "end");   end_hour_spin.insert(0, "11")
    end_minute_spin.delete(0, "end"); end_minute_spin.insert(0, "30")

    # Price (optional)
    ttk.Label(content, text="Price:", font=("Segoe UI", 11)).grid(row=5, column=0, sticky="e", padx=6, pady=6)
    price_entry = ttk.Entry(content, width=12)
    price_entry.grid(row=5, column=1, sticky="w", padx=6, pady=6)
    price_entry.insert(0, "0.00")

    def on_add_trip():
        # Validate dropdowns
        if not passenger_combo.get() or not vessel_combo.get():
            feedback.set("Please select both Passenger and Vessel.")
            return

        # Build start datetime
        try:
            start_dt = compose_dt_from_spins(year_spin, month_spin, day_spin, hour_spin, minute_spin)
        except Exception as e:
            feedback.set(f"Invalid start date/time: {e}")
            return

        # Build end datetime
        try:
            end_dt = compose_dt_from_spins(end_year_spin, end_month_spin, end_day_spin, end_hour_spin, end_minute_spin)
        except Exception as e:
            feedback.set(f"Invalid end date/time: {e}")
            return

        # Validate end > start
        if end_dt <= start_dt:
            feedback.set("End date/time must be after start date/time.")
            return

        # Map names -> IDs
        try:
            passenger_id = find_id_by_name(passengers, passenger_combo.get())
            vessel_id = find_id_by_name(vessels, vessel_combo.get())
        except ValueError as e:
            feedback.set(str(e))
            return

        # Price
        try:
            price_val = float(price_entry.get())
        except Exception:
            price_val = 0.0

        # Call BLL
        try:
            ok, msg = APP_BLL.add_trip(
                passenger_id=passenger_id,
                vessel_id=vessel_id,
                start_datetime=start_dt,
                end_datetime=end_dt,
                price=price_val
            )
            feedback.set(msg or ("Trip added." if ok else "Could not add trip."))
            if ok:
                show_view_trips(root)  # go back to list and refresh
        except Exception as e:
            feedback.set(f"Error adding trip via BLL: {e}")

    ttk.Button(content, text="Add Trip", command=on_add_trip).grid(row=6, column=0, columnspan=6, pady=10)

    # Layout stretch
    content.columnconfigure(0, weight=0)
    content.columnconfigure(1, weight=1)
    content.columnconfigure(2, weight=0)
    content.columnconfigure(3, weight=1)
    content.rowconfigure(6, weight=1)


# ---------- App bootstrap ----------
def main():
    root = tk.Tk()
    show_login(root)
    root.mainloop()


if __name__ == "__main__":
    main()


