import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student_management_website/dialogs/alert_dialog.dart';
import 'package:student_management_website/custom_tiles/custom_text_tile.dart';
import 'package:student_management_website/dialogs/edit_student_dialog.dart';
import 'package:student_management_website/model/student.dart';
import 'package:student_management_website/functions/natifiers.dart';

class StudentDetails extends StatelessWidget {
  final String deleteKey;
  final int index;

  const StudentDetails(
      {super.key, required this.deleteKey, required this.index});

  @override
  Widget build(BuildContext context) {
    DatabaseReference currentDataReference = FirebaseDatabase.instance.ref();
    StudentData? student;
    helper() async {
      await currentDataReference
          .child('Students/$deleteKey')
          .get()
          .then((snapshot) {
        student = StudentData.fromJson(snapshot.value as Map);
      });
    }

    helper();
    double availableWidth = MediaQuery.sizeOf(context).width * 0.75;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: SizedBox(
          width: availableWidth,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            child: ValueListenableBuilder(
              valueListenable: detailsNotifier,
              builder: (context, value, child) => FutureBuilder(
                future: helper(),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.done
                    ? ListView(
                        children: [
                          const SizedBox(height: 16),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: CircleAvatar(
                                radius: 150,
                                backgroundImage: student!.profilePictureUri !=
                                        null
                                    ? NetworkImage(student!.profilePictureUri!)
                                    : const NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/student-management-web-b973c.appspot.com/o/images%2Fdefault_image.jpg?alt=media&token=34741d05-39ce-47d7-887d-037b85cc037a",
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              student!.name!,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextTile().customTextBox(availableWidth, "Student ID",
                              student!.studentID!),
                          TextTile().customTextBox(
                              availableWidth, "Email ID", student!.email!),
                          TextTile().customTextBox(availableWidth,
                              "Phone Number", student!.phoneNumber!),
                          TextTile().customTextBox(
                              availableWidth, "Age", student!.age!),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: SizedBox(
                                  width: availableWidth * .4,
                                  height: 50,
                                  child: Ink(
                                    color: Colors.red,
                                    child: const Center(
                                        child: Text(
                                      "Remove this student",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                                onTap: () async {
                                  bool hasImage =
                                      student!.profilePictureUri == null
                                          ? false
                                          : true;
                                  if (MediaQuery.sizeOf(context).width < 600) {
                                    showBottomSheet(
                                      enableDrag: true,
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.25,
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30)),
                                            child: Center(
                                              child: Dialogs.showDeleteAlert(
                                                  student!.studentID!,
                                                  student!.name!,
                                                  context,
                                                  hasImage,
                                                  index,
                                                  deleteKey),
                                            )),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          Dialogs.showDeleteAlert(
                                              student!.studentID!,
                                              student!.name!,
                                              context,
                                              hasImage,
                                              index,
                                              deleteKey),
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: availableWidth * .03,
                              ),
                              SizedBox(
                                width: availableWidth * .4,
                                height: 50,
                                child: InkWell(
                                  child: Ink(
                                    color: Colors.deepPurple,
                                    child: const Center(
                                        child: Text("Edit details",
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                  onTap: () {
                                    EditStudent(
                                            currentKey: deleteKey,
                                            context: context)
                                        .show();
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
