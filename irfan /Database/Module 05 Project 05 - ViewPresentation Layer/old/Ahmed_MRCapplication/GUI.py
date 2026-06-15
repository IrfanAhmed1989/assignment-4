
# GUI.py
import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime
import calendar

from BLL import BLL

APP_BLL = BLL()

# ---------- helpers ----------
def clear_content(root):
    for child in root.winfo_children():
        if isinstance(child, ttk.Frame) and getattr(child, "_is_content", False):
            child.destroy()
    content = ttk.Frame(root, padding=10)
    content._is_content = True
    content.grid(row=1, column=0, sticky="nsew")
    return content

def show_login(root):
    root.title("MRC App")
    root.geometry("920x600")
    root.grid_columnconfigure(0, weight=1)
    root.grid_rowconfigure(1, weight=1)

    content = clear_content(root)
    username_var = tk.StringVar()
    password_var = tk.StringVar()

    ttk.Label(content, text="Username").grid(row=0, column=0, sticky="w", padx=6, pady=6)
    ttk.Entry(content, textvariable=username_var, width=30).grid(row=0, column=1, sticky="w", padx=6, pady=6)

    ttk.Label(content, text="Password").grid(row=1, column=0, sticky="w", padx=6, pady=6)
    ttk.Entry(content, textvariable=password_var, show="*", width=30).grid(row=1, column=1, sticky="w", padx=6, pady=6)

    def do_login():
        if not username_var.get().strip() or not password_var.get().strip():
            messagebox.showerror("Login", "Please enter both username and password.")
            return
        show_home(root, username_var.get().strip())

    ttk.Button(content, text="Login", command=do_login).grid(row=2, column=1, sticky="w", padx=6, pady=10)

def show_home(root, username):
    header = ttk.Frame(root, padding=10)
    header.grid(row=0, column=0, sticky="ew")
    ttk.Label(header, text=f"Welcome, {username}").pack(side="left")
    ttk.Button(header, text="Logout", command=lambda: show_login(root)).pack(side="right")

    actions = ttk.Frame(root, padding=10)
    actions.grid(row=2, column=0, sticky="ew")
    ttk.Button(actions, text="View All Trips", command=lambda: show_trips(root)).pack(side="left", padx=4)
    ttk.Button(actions, text="Add Trip", command=lambda: show_add_trip(root)).pack(side="left", padx=4)

    show_trips(root)

def show_trips(root):
    content = clear_content(root)
    ttk.Label(content, text="All Trips", font=("Segoe UI", 14, "bold")).grid(row=0, column=0, sticky="w")

    columns = ("id", "passenger", "vessel", "start", "end", "price")
    tree = ttk.Treeview(content, columns=columns, show="headings", height=18)
    headings = {
        "id": "Trip ID",
        "passenger": "Passenger",
        "vessel": "Vessel",
        "start": "Start",
        "end": "End",
        "price": "Total Cost",
    }
    for col, text in headings.items():
        tree.heading(col, text=text)
        tree.column(col, width=140)
    tree.grid(row=1, column=0, sticky="nsew", padx=4, pady=6)
    content.grid_rowconfigure(1, weight=1)
    content.grid_columnconfigure(0, weight=1)

    try:
        trips = APP_BLL.get_trips()
        for t in trips:
            tree.insert("", "end", values=(
                t["id"],
                t["passenger_name"],
                t["vessel_name"],
                t["start_datetime_str"],
                t["end_datetime_str"],
                t["price_str"],
            ))
    except Exception as e:
        messagebox.showerror("Error", f"Error loading trips: {e}")

    ttk.Button(content, text="Back", command=lambda: show_home(root, "irfan")).grid(row=2, column=0, sticky="w", pady=8)

def _date_time_picker(parent):
    """Return a frame with Year/Month/Day/Hour/Minute pickers and a get_dt() function."""
    frame = ttk.Frame(parent)

    # Year picker: include default (1815) and nearby/current years
    year_var = tk.StringVar(value="1815")
    year_cb = ttk.Combobox(frame, textvariable=year_var, values=[str(y) for y in range(1815, datetime.now().year + 2)], width=6, state="readonly")
    year_cb.grid(row=0, column=0, padx=4)

    # Month picker
    months = [("01","Jan"),("02","Feb"),("03","Mar"),("04","Apr"),("05","May"),("06","Jun"),
              ("07","Jul"),("08","Aug"),("09","Sep"),("10","Oct"),("11","Nov"),("12","Dec")]
    month_var = tk.StringVar(value="12")
    month_cb = ttk.Combobox(frame, textvariable=month_var, values=[m[0] for m in months], width=4, state="readonly")
    month_cb.grid(row=0, column=1, padx=4)

    # Day picker (auto-populate based on month/year)
    day_var = tk.StringVar(value="10")
    day_cb = ttk.Combobox(frame, textvariable=day_var, values=[str(d).zfill(2) for d in range(1, 32)], width=4, state="readonly")
    day_cb.grid(row=0, column=2, padx=4)

    def refresh_days(*args):
        y = int(year_var.get())
        m = int(month_var.get())
        days_in_month = calendar.monthrange(y, m)[1]
        day_cb["values"] = [str(d).zfill(2) for d in range(1, days_in_month + 1)]
        if int(day_var.get()) > days_in_month:
            day_var.set(str(days_in_month).zfill(2))

    year_cb.bind("<<ComboboxSelected>>", refresh_days)
    month_cb.bind("<<ComboboxSelected>>", refresh_days)
    refresh_days()

    # Hour and Minute pickers
    hour_var = tk.StringVar(value="10")
    minute_var = tk.StringVar(value="00")
    hour_cb = ttk.Combobox(frame, textvariable=hour_var, values=[str(h).zfill(2) for h in range(0,24)], width=4, state="readonly")
    minute_cb = ttk.Combobox(frame, textvariable=minute_var, values=["00","15","30","45"], width=4, state="readonly")
    hour_cb.grid(row=0, column=3, padx=4)
    minute_cb.grid(row=0, column=4, padx=4)

    def get_dt():
        y = int(year_var.get())
        m = int(month_var.get())
        d = int(day_var.get())
        hh = int(hour_var.get())
        mm = int(minute_var.get())
        return datetime(y, m, d, hh, mm)

    return frame, get_dt

def show_add_trip(root):
    content = clear_content(root)
    ttk.Label(content, text="Add Trip", font=("Segoe UI", 14, "bold")).grid(row=0, column=0, sticky="w")

    passengers = APP_BLL.get_passengers()
    vessels = APP_BLL.get_vessels()

    ttk.Label(content, text="Passenger").grid(row=1, column=0, sticky="w", padx=4, pady=4)
    p_combo = ttk.Combobox(content, values=[f"{p['id']} - {p['name']}" for p in passengers], state="readonly", width=42)
    p_combo.grid(row=1, column=1, sticky="w", padx=4, pady=4)
    if passengers:
        p_combo.current(0)

    ttk.Label(content, text="Vessel").grid(row=2, column=0, sticky="w", padx=4, pady=4)
    v_combo = ttk.Combobox(content, values=[f"{v['id']} - {v['name']}" for v in vessels], state="readonly", width=42)
    v_combo.grid(row=2, column=1, sticky="w", padx=4, pady=4)
    if vessels:
        v_combo.current(0)

    ttk.Label(content, text="Start (Year/Month/Day/Hour/Minute)").grid(row=3, column=0, sticky="w", padx=4, pady=4)
    dt_frame, get_dt = _date_time_picker(content)
    dt_frame.grid(row=3, column=1, sticky="w", padx=4, pady=4)

    ttk.Label(content, text="Duration (hours)").grid(row=4, column=0, sticky="w", padx=4, pady=4)
    duration_var = tk.StringVar(value="2.0")
    duration_spin = ttk.Spinbox(content, textvariable=duration_var, from_=0.5, to=24.0, increment=0.5, width=7)
    duration_spin.grid(row=4, column=1, sticky="w", padx=4, pady=4)

    def submit():
        try:
            # Parse selections
            passenger_id = int(p_combo.get().split(" - ", 1)[0])
            vessel_id = int(v_combo.get().split(" - ", 1)[0])
            start_dt = get_dt()
            duration_hours = float(duration_var.get())

            ok, msg = APP_BLL.add_trip(passenger_id, vessel_id, start_dt, duration_hours, price=0.0)
            if ok:
                messagebox.showinfo("Add Trip", msg)
                show_trips(root)
            else:
                messagebox.showerror("Add Trip", msg)
        except Exception as e:
            messagebox.showerror("Add Trip", f"Error: {e}")

    ttk.Button(content, text="Submit", command=submit).grid(row=5, column=1, sticky="w", padx=4, pady=10)
    ttk.Button(content, text="Back", command=lambda: show_home(root, "irfan")).grid(row=6, column=0, sticky="w", padx=4, pady=8)



if __name__ == "__main__":
    root = tk.Tk()
    show_login(root)
    root.mainloop()

