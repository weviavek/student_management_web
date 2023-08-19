import 'package:flutter/material.dart';
import 'package:student_management_website/model/student.dart';

class Desktop {
  Widget desktopTile(
      StudentData currentStudent, Function() onPress, BuildContext context,Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              maxRadius: 50,
              backgroundImage: currentStudent.profilePictureUri != null
                  ? NetworkImage(currentStudent.profilePictureUri!)
                  : const NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/student-management-web-b973c.appspot.com/o/images%2Fdefault_image.jpg?alt=media&token=34741d05-39ce-47d7-887d-037b85cc037a"),
            ),
          ),
          SizedBox(
              width: MediaQuery.sizeOf(context).width * .15,
              child: Text("Name : ${currentStudent.name}")),
          SizedBox(
              width: MediaQuery.sizeOf(context).width * .15,
              child: Text("Age : ${currentStudent.age}")),
          SizedBox(
              width: MediaQuery.sizeOf(context).width * .15,
              child: Text("Email ID : ${currentStudent.email}")),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
                onPressed: onPress,
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                )),
          )
        ],
      ),
    );
  }
}
