"""
Our business logic layer
"""
import uni_dal


class Course_BLL:
    """
    We create this class to organize our BLL functions together.
    We create three mathods that can be used by the front end for different requests
    and an add method that uses the Course Object we defined in the DAL
    """
    def get_all_courses():
        return uni_dal.Course_DAL.get_courses()
    
    def get_course_by_dept(my_dept):
        return uni_dal.Course_DAL.get_courses(dept=my_dept)
    
    def get_course_by_id(my_course_id):
        return uni_dal.Course_DAL.get_courses(dept=my_course_id)
    
    def add_course(course_id, course_title, course_dept, course_credits):
        if type(course_id) != int:
            raise Exception('course_id must be an int!')
        if type(course_title) != str:
            raise Exception('course_title must be a str!')
        my_course = uni_dal.Course_Object(course_id, course_title, course_dept, course_credits)
        result = uni_dal.Course_DAL.add_course(my_course)
        if result == -1:
            raise Exception("Unable to add duplicate course")
        return f"Added {my_course.__str__()}"

class Dept_BLL:
    def getDepts():
        return uni_dal.Dept_DAL.get_depts()