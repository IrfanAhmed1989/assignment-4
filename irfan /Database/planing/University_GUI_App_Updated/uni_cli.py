import uni_bll

def print_list(list):
    for item in list:
        print(item)

def main():
    print("Welcome to the University CLI App!")
    print("================")
    print("Let's view all courses!")
    print("================")
    print_list(uni_bll.Course_BLL.get_all_courses())
    print("================")
    print("Let's view all CS courses!")
    print_list(uni_bll.Course_BLL.get_course_by_dept("Comp. Sci."))
    print("================")
    print("Let's add a new CS course!")
    print("================")
    try:
        print(uni_bll.Course_BLL.add_course(4,"Newer CS","Comp. Sci.", 4))
    except Exception as e:
        print(e)
    print("================")
    print("Let's view all CS courses again!")
    print("================")
    print_list(uni_bll.Course_BLL.get_course_by_dept("Comp. Sci."))


if __name__ == "__main__":
    main()