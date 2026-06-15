"""
This example Data Access Layer (DAL) connects to the sample university database and retrieves information from the course table.
There are methods to get, add, update, and delete information from this table.
"""

import mysql.connector
from config import config

"""
The Course Object class provides a blueprint for storing the data from our course database in the table.
This lets us pass each tuple in a single unit without needing to create lists.
We could store this in its own module and import it, but for simplicity, we will include it here.
"""
class Course_Object:
    def __init__(self, course_id, course_title, dept, credits):
        self.course_id = course_id
        self.course_title = course_title
        self.dept = dept
        self.credits = round(float(credits),2)

    def __str__(self):
        return f"{self.dept} {self.course_id}: {self.course_title} ({self.credits} credits)"

"""
The Course_DAL class connects to the database to retrieve and manipulate information in the course table.

"""
class Course_DAL:
    """
    This method retrieves information from the course table. There are three different versions built in.
    Being able to pass different arguments in different configurations gives us flexibility in our BLL.
    We can use the same functions with different arguments to get different results without having to 
    write three versions of the function.

    Since dept and course_id have default arguments, we will need to use a keyword arguments in our BLL to make
    sure we pass the necessary information without error.
    """
    def get_courses(dept = None, course_id = None):
        # Since we are getting courses, we need a place to store them, so we use this empty list
        course_cache = []

        # Next, we connect to the database using our config file and open a cursor
        db = mysql.connector.connect(**config)
        cursor = db.cursor()
        
        # Now we get into our branching logic based on the arguments we pass
        # If we specify a course_id, that takes precedence, since these are unique ids
        if course_id:
            # We separate the arguments out of our queries to improve security.
            # They need to be interable, so we can use a tuple or list
            args = (course_id,) # End single item tuples with a comma before closing the parentheses
            # Replace the arguments with %s where they would go in your query. The args will be passed in order left to right
            #cursor.execute("SELECT * FROM course WHERE course_id = %s", args) 
            cursor.callproc('get_course_by_id', args)
        # If we don't have a course_id but bo specify a dept, we go to the next branch
        elif dept:
            args = (dept,)
            #cursor.execute("SELECT * FROM course WHERE dept_name = %s", args)
            cursor.callproc('get_courses_by_department', args)
        # Finally, if no arguments are specified, we just grab the whole table
        else:
            #cursor.execute("SELECT * FROM course")
            cursor.callproc('get_all_courses')
        # Once our query completes, the information is stored in our cursor. We typiclaly need to iterate
        # through to access our data
        
        for result in cursor.stored_results():
            for item in result.fetchall():
                # We then take the information from each tuple and store it in a Course_Object
                course_cache.append(Course_Object(item[0],item[1],item[2],item[3]))
        # When we are done with our cursor, we close it
        cursor.close() # Close the cursor when finished
        db.close() # Disconnect from the database when finished (slower, but more secure)
        return course_cache
    
    def add_course(course_object):
        """
        This method adds a course to the database, and assumes that we will use the Course Object to hold our
        new course information.
        """
        db = mysql.connector.connect(**config)
        cursor = db.cursor()
        # We unpack our Course Object attributes into an arguments tuple
        args = (course_object.course_id, course_object.course_title, course_object.dept, course_object.credits)        
        # We run through 
        cursor.callproc('add_course', args)
        db.commit()
        for result in cursor.stored_results():
            for item in result.fetchall():
                final_result =  item[0] # returns -1 if a duplicate or the new course id
        cursor.close()
        db.close()
        return final_result
        
class Dept_DAL:
    def get_depts():
        dept_list = []
        db = mysql.connector.connect(**config)
        cursor = db.cursor()
        cursor.execute("SELECT dept_name FROM department;")
        for item in cursor.fetchall():
            dept_list.append(item[0])
        return dept_list
                


def main():
    # Helper function to print lists
    def print_list(list):
        for item in list:
            print(item)

    print_list(Course_DAL.get_courses())
    print("-----")
    print_list(Course_DAL.get_courses(dept = "Comp. Sci."))
    print("-----")
    print_list(Course_DAL.get_courses(course_id = "841"))
    print("-----")
    NewCourse = Course_Object(2,'new course','Biology','4')
    print(Course_DAL.add_course(NewCourse))
    


if __name__ == "__main__":
    main()





