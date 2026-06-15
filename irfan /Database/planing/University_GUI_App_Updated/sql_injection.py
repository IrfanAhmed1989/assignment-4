"""
This file demonstrates a SQL injection attack.
"""

import mysql.connector
from config import config
from uni_dal import Course_DAL

def get_course_SQL_injection(course_id):
    course_cache = []
    db = mysql.connector.connect(**config)
    cursor = db.cursor()
    args = (course_id,)
    cursor.execute(f"SELECT * FROM course WHERE course_id = {course_id}") # Using f-strings does not prevent injection attacks
    #cursor.execute("SELECT * FROM course WHERE course_id = %s", args) # This format prevents the example attack
    for item in cursor.fetchall():
        course_cache.append(Course_DAL.Course_Object(item[0],item[1],item[2],item[3]))
    cursor.close()
    db.close()
    return course_cache

def create_attack_me_table():
    db = mysql.connector.connect(**config)
    cursor = db.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS attack_me(message VARCHAR(20)); INSERT INTO attack_me VALUES ('I am a table'); COMMIT;")
    cursor.close()
    db.close()
    print("Created or updated attack_me table")

def check_attack_me_table():
    print("Checking attack_me table")
    db = mysql.connector.connect(**config)
    cursor = db.cursor()
    try:
        cursor.execute("SELECT * FROM attack_me;")
        for item in cursor.fetchall():
            print(item)
    except Exception as e:
        print(e)
    cursor.close()
    db.close()

def main():

    print("-----")
    create_attack_me_table()
    print("-----")
    check_attack_me_table()
    print("-----")
    print("Injecting SQL")
    get_course_SQL_injection("NULL; DROP TABLE attack_me;") # Drop attack_me table
    print("-----")
    check_attack_me_table()

if __name__ == "__main__":
    main()