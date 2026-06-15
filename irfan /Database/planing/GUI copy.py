
import tkinter as tk
from tkinter import messagebox
import mysql.connector

def connect_db():
    host = host_entry.get()
    user = user_entry.get()
    password = pass_entry.get()
    try:
        global conn
        conn = mysql.connector.connect(host=host, user=user, password=password, database="your_database_name")
        messagebox.showinfo("Success", "Connected to Database!")
        login_window.destroy()
        show_main_menu()
    except:
        messagebox.showerror("Error", "Connection Failed!")

login_window = tk.Tk()
login_window.title("Login")

tk.Label(login_window, text="Host").grid(row=0, column=0)
host_entry = tk.Entry(login_window)
host_entry.insert(0, "localhost")
host_entry.grid(row=0, column=1)

tk.Label(login_window, text="User").grid(row=1, column=0)
user_entry = tk.Entry(login_window)
user_entry.grid(row=1, column=1)

tk.Label(login_window, text="Password").grid(row=2, column=0)
pass_entry = tk.Entry(login_window, show="*")
pass_entry.grid(row=2, column=1)

tk.Button(login_window, text="Connect", command=connect_db).grid(row=3, column=0, columnspan=2)

login_window.mainloop()
