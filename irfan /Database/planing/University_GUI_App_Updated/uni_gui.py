import uni_bll as bll
import tkinter as tk
from tkinter import messagebox

from tkcalendar import DateEntry

courseList = []

def getDate():
    dateMessage.set(calendar.get())

def getDept():
    print(dept_choice.get())
    return dept_choice.get() 

def get_new_id():
    print(new_id.get())
    return new_id.get()

def get_new_title():
    print(new_title.get())
    return new_title.get()

def get_new_dept_choice():
    print(new_dept_choice.get())
    return new_dept_choice.get()

def get_new_credits():
    print(new_credits.get())
    return new_credits.get()



def populateCourses():
    for course in courseTree.get_children():
        courseTree.delete(course)

    courseList = bll.Course_BLL.get_course_by_dept(getDept())
    
    for course in courseList:
        courseTree.insert(parent="", index="end", values=(course.course_id, course.dept, course.course_title, course.credits))

def addCourse():
    try:
        bll.Course_BLL.add_course(int(get_new_id()), get_new_title(), get_new_dept_choice(), get_new_credits())
        messagebox.showinfo(title="Success", message="Course added successfully")
    except Exception as e:
        messagebox.showerror(title="Error", message=e)


# Create main window
root = tk.Tk()
root.geometry("800x600")
root.title("University GUI")
root.columnconfigure(0, weight=1)
root.columnconfigure(1, weight=1)
root.columnconfigure(2, weight=1)
tk.Label(root, text="Welcome to the Not-So-Great University App!", font="papyrus").grid(row=0, column=0)

# Spaceholder
tk.Label(root, text="").grid(row=1)

# Get and display departments
departments = bll.Dept_BLL.getDepts()
dept_choice = tk.ttk.Combobox(root, values=departments)
dept_choice.grid(column=1, row=2)
tk.Button(root,text="Show classes for department", command=populateCourses).grid(column=0, row=2)

tk.Label(root, text="").grid(row=3)

# Date picker example
calendar = DateEntry(root, date_pattern = "mm/dd/yyyy")
calendar.grid(row=4, column=1)
tk.Button(root,text="Click to show the Selected Date.", command=getDate).grid(row=4,column=0)
dateMessage = tk.StringVar()
dateMessage.set("Date goes here")
tk.Label(root,textvariable=dateMessage).grid(column=2, row=4)

tk.Label(root, text="").grid(row=5)

# Area for course display
courseTree = tk.ttk.Treeview(root, columns=("ID", "Dept","Title","Credits"), show ="headings")
courseTree.heading("ID", text="ID", anchor="w")
courseTree.heading("Dept", text="Dept", anchor="w")
courseTree.heading("Title", text="Title", anchor="w")
courseTree.heading("Credits", text="Credits", anchor="w")
courseTree.grid(row=6, columnspan=3)

tk.Label(root, text="").grid(row=7)

# Add course area
add_course_frame = tk.LabelFrame(root, text="Add New Course", borderwidth=5)
add_course_frame.grid(row=8)
# Labels
tk.Label(add_course_frame, text="New id: ", pady=5).grid(row=0, column=0)
tk.Label(add_course_frame, text="New title: ", pady=5).grid(row=1, column=0)
tk.Label(add_course_frame, text="New department: ", pady=5).grid(row=2, column=0)
tk.Label(add_course_frame, text="New credits: ", pady=5).grid(row=3, column=0)

# Entry areas (split the grids to avoid error when accessing values)
new_id = tk.Entry(add_course_frame)
new_id.grid(row=0, column=1)
new_title = tk.Entry(add_course_frame)
new_title.grid(row=1, column=1)
new_dept_choice = tk.ttk.Combobox(add_course_frame, values=departments)
new_dept_choice.grid(row=2, column=1)
new_credits = tk.Spinbox(add_course_frame, from_=0, to=12)
new_credits.grid(row=3, column=1)

# Button to add course
tk.Button(add_course_frame, text="Click Here to Add Course!", command=addCourse).grid(column=3, row=0, rowspan=4, padx=15)


def main():
    root.mainloop()


if __name__ == "__main__":
    main()