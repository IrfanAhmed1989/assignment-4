Here’s a **fully rubric-compliant README.md** you can copy and paste:

***

# Ahmed MRC Application

A Tkinter-based GUI application for the Merrimack River Cruises (MRC) system. This app replaces the CLI view layer with a GUI that interacts with the **Business Logic Layer (BLL)** and **Data Access Layer (DAL)**, which in turn communicate with the **Week 4 & 5 Starter Database**.

***

##  Features

*   **Login Screen**: Requires non-empty username and password before accessing features.
*   **View All Trips**:
    *   Displays trips in a user-friendly table with columns: Trip ID, Passenger, Vessel, Start, End, Total Cost.
    *   Data is fetched via stored procedure `getTripList` from the starter DB.
*   **Add Trip**:
    *   Dropdowns for selecting **Passenger** and **Vessel** from the database.
    *   Date and Time picker (Year, Month, Day, Hour, Minute) so users don’t type manually.
    *   Duration spinner for trip length in hours.
    *   **Double-booking prevention**: BLL checks for overlapping trips for the same passenger or vessel.
*   **Immediate Updates**: Newly added trips appear in “View All Trips” without restarting the app.

***

##  Requirements

*   Python 3.x (macOS or Windows)
*   MySQL Server with **Week 4 & 5 Starter Code** loaded
*   Python package:
    ```bash
    python3 -m pip install mysql-connector-python
    ```

***

## Database Setup

1.  Open Terminal and start MySQL:
    ```bash
    mysql -u root -p
    ```
    Enter your password (`iiii`).
2.  Load the Week 4 & 5 Starter SQL file:
    ```sql
    source "/path/to/Starter_Code_Week_4+5.sql";
    ```
3.  Confirm stored procedures exist:
    ```sql
    USE mrc;
    CALL getPassengerList();
    CALL getVesselList();
    CALL getTripList();
    ```

***

## How to Run

```bash
# Navigate to your project folder
cd "/Users/irfanahmed/Desktop/Module 05 Project 05 - ViewPresentation Layer/Ahmed_MRCapplication"

# Run the GUI
python3 GUI.py
```

### Login:

*   Enter any username and password (both non-empty).
*   Click **Login**.

### Use the App:

*   **View All Trips** → Displays trips from DB.
*   **Add Trip** → Select passenger, vessel, date/time, duration → Submit.
*   If double-booking is detected, you’ll see an error message.

***

##  Deliverables Checklist

✔ GUI.py, BLL.py, DAL.py in one folder  
✔ README.md with clear instructions  
✔ Uses Week 4 & 5 Starter DB (unmodified)  
✔ Login form implemented  
✔ View All Trips table is user-friendly  
✔ Add Trip uses dropdowns and date/time picker  
✔ Double-booking prevention in BLL  
✔ New trips reflect immediately in View All Trips  
✔ Application runs without error



##  Zip for Submission

```bash
mkdir AhmedMRC
cp GUI.py BLL.py DAL.py README.md AhmedMRC/
zip -r AhmedMRC.zip AhmedMRC
```


