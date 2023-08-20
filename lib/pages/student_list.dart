import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student_management_website/dialogs/alert_dialog.dart';
import 'package:student_management_website/custom_tiles/desktop_tile.dart';
import 'package:student_management_website/global/global_data.dart';
import 'package:student_management_website/model/student.dart';
import 'package:student_management_website/functions/natifiers.dart';
import 'package:student_management_website/dialogs/new_student_dialog.dart';
import 'package:student_management_website/pages/search_page.dart';
import 'package:student_management_website/pages/students_details.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => StudentListState();
}

class StudentListState extends State<StudentList> {
  static List<StudentModel> listOfStudents = [];

  DatabaseReference currentDataReference = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    retrieveFromDB();
  }

  retrieveFromDB() {
    currentDataReference.child("Students").onChildAdded.listen((data) {
      StudentData currentData =
          StudentData.fromJson(data.snapshot.value as Map);
      StudentModel currentModel =
          StudentModel(currentData: currentData, key: data.snapshot.key);
      listOfStudents.add(currentModel);
      setState(() {
        globalStudentList = listOfStudents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Students"),
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: ShowSearchPage()),
              icon: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.75,
            child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: ValueListenableBuilder(
                  valueListenable: listNotifier,
                  builder: (context, value, child) => ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      Future<StudentData> getCurrentData() {
                        DatabaseReference ref = FirebaseDatabase.instance.ref();
                        return ref
                            .child('Students/${listOfStudents[index].key}')
                            .get()
                            .then((snapshot) {
                          return StudentData.fromJson(snapshot.value as Map);
                        });
                      }

                      return FutureBuilder(
                        future: getCurrentData(),
                        builder: (context, snapshot) => snapshot
                                    .connectionState ==
                                ConnectionState.done
                            ? LayoutBuilder(
                                builder: (context, constraints) => constraints
                                            .maxWidth <
                                        600
                                    ? ListTile(
                                        leading:
                                            snapshot.data!.profilePictureUri !=
                                                    null
                                                ? CircleAvatar(
                                                    maxRadius: 30,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data!
                                                            .profilePictureUri!),
                                                  )
                                                : const CircleAvatar(
                                                    maxRadius: 30,
                                                    backgroundImage: NetworkImage(
                                                        "https://firebasestorage.googleapis.com/v0/b/student-management-web-b973c.appspot.com/o/images%2Fdefault_image.jpg?alt=media&token=34741d05-39ce-47d7-887d-037b85cc037a"),
                                                  ),
                                        title: Text(snapshot.data!.name!),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Text(
                                              "Student ID : ${snapshot.data!.studentID}",
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                            Flexible(
                                                child: Text(
                                              "Age : ${snapshot.data!.age}",
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                          ],
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      Dialogs.showDeleteAlert(
                                                          listOfStudents[index]
                                                              .currentData!
                                                              .studentID!,
                                                          listOfStudents[index]
                                                              .currentData!
                                                              .name!,
                                                          context,
                                                          index,
                                                          listOfStudents[index]
                                                              .key!));
                                            },
                                            icon: const Icon(
                                              Icons.delete_rounded,
                                              color: Colors.red,
                                            )),
                                        onTap: () {
                                          GlobalArggs.index = index;
                                          GlobalArggs.deleteKey =
                                              listOfStudents[index].key!;
                                          Navigator.pushNamed(
                                              context, '/studentdetails');
                                        })
                                    : Desktop().desktopTile(
                                        snapshot.data!,
                                        () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  Dialogs.showDeleteAlert(
                                                      listOfStudents[index]
                                                          .currentData!
                                                          .studentID!,
                                                      listOfStudents[index]
                                                          .currentData!
                                                          .name!,
                                                      context,
                                                      index,
                                                      listOfStudents[index]
                                                          .key!));
                                        },
                                        context,
                                        () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetails(
                                                index: index,
                                                deleteKey:
                                                    listOfStudents[index].key!,
                                              ),
                                            )),
                                      ))
                            : const CircularProgressIndicator(),
                      );
                    },
                    itemCount: listOfStudents.length,
                  ),
                )),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.sizeOf(context).width * 0.13),
        child: FloatingActionButton(
          onPressed: () {
            StudentDialogs(context).newStudentDialog();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
