import 'package:student_management_website/model/student.dart';
import 'package:student_management_website/pages/student_list.dart';

class Validator {
  static String? nameValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Name can't be empty";
    }
    return null;
  }

  static String? studentIDValidator(String? value) {
    bool checker() {
      for (StudentModel current in StudentListState.listOfStudents) {
        if (current.currentData!.studentID == value) {
          return true;
        }
      }
      return false;
    }

    if (value != null && value.isEmpty) {
      return "Student ID can't be empty";
    } else if (!RegExp(r'^[0-9]{5}$').hasMatch(value!)) {
      return "Enter valid Student ID";
    } else if (checker()) {
      return "Student ID already exists";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Email can't be empty";
    } else if (!RegExp(r'^[\w-\.]+@([\w-\.]+\.)+[a-zA-Z]{2,}$')
        .hasMatch(value!)) {
      return "Enter valid Email ID";
    } else {
      return null;
    }
  }

  static String? phoneNumberValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Phone number can't be empty";
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value!)) {
      return "Enter valid Phone number";
    }
    return null;
  }

  static String? ageValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Age can't be empty";
    } else if (!RegExp(r'^[0-9]{2}$').hasMatch(value!)) {
      return "Enter correct age";
    }
    return null;
  }
}
