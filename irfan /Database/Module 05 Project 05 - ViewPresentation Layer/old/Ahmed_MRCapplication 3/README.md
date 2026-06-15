
# Ahmed_MRCapplication

GUI application for the MRC database assignment (Week 5). The GUI replaces the prior CLI view and follows separation of concerns:
- GUI (View) → BLL → DAL → MySQL (Week 4/5 starter DB)

## 1) Prerequisites
- Windows 10/11
- Python 3.11+
- MySQL Server (local), default port 3306
- Python package:
```bash
python -m pip install mysql-connector-python
```

## 2) Load the Week 4/5 Starter DB (unmodified)

1. Open MySQL Workbench and connect to your local server.
2. Run `Starter_Code_Week_4+5.sql` (no changes).
3. Quick checks:
    ```sql
    USE mrc;
    SELECT COUNT(*) FROM vessels;
    SELECT COUNT(*) FROM passengers;
    SELECT * FROM `All Trips` LIMIT 5;
    SHOW PROCEDURE STATUS WHERE Db='mrc';
    SHOW FUNCTION STATUS WHERE Db='mrc';
    ```

## 3) Configure & Run

The app connects with:

- host: `localhost`
- port: `3306`
- user: `root`
- password: *(empty or your local root password — set in `BLL.__init__` where `self._db.connect(...)` is called)*
- database: `mrc`

Start the GUI:

```bash
python GUI.py
```

Login: any non‑empty username/password (per assignment spec).

## 4) Features (Rubric Alignment)

- **Login form:** non‑empty required; user‑friendly layout.
- **View All Trips:** table shows ID (if present), Passenger, Vessel, Start, End, Price.
- **Add Trip:** Passenger & Vessel dropdowns from DB; Date & Time inputs; BLL blocks double‑booking (same passenger or vessel with overlapping window); inserts via DAL stored procedure; new trips appear in View All Trips.
- **Separation of concerns:** GUI ↔ BLL ↔ DAL ↔ DB objects (starter SQL unchanged).

## 5) Troubleshooting

- `ModuleNotFoundError: No module named 'mysql'` → install connector:
    ```bash
    python -m pip install mysql-connector-python
    ```
- `IndentationError` → ensure 4 spaces (no tabs). If needed, put `pass` under the offending `if:` to unblock, then restore logic.
- Connection issues → verify MySQL is running and credentials match your local setup.

## 6) Screenshots to Verify Before Submit

1. Workbench: `mrc` schema expanded (Tables, Views, Procedures, Functions) + sample query results  
2. GUI Login: after logging in  
3. View All Trips: rows visible from DB  
4. Add Trip (non‑overlap): success, and row appears in View All Trips  
5. Add Trip (overlap): double‑booking message shown  
6. Dropdowns: Passenger & Vessel with real DB names

---

## 7) Zip Packaging (submission)

Create a zip named `Ahmed_MRCapplication.zip` containing:

```
Ahmed_MRCapplication/
├─ GUI.py
├─ BLL.py
├─ DAL.py
├─ README.md
└─ (optional) libs/ or __pycache__/   ← exclude if your LMS requires only source files
```

**Do not** include the starter SQL file; just reference it in the README.

