import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student_management_website/model/student.dart';

import '../custom_tiles/desktop_tile.dart';
import '../dialogs/alert_dialog.dart';
import '../global/global_data.dart';
import 'students_details.dart';

List<StudentModel> globalStudentList = [];

class ShowSearchPage extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<StudentModel> matchedStudents = [];
    for (final current in globalStudentList) {
      if (current.currentData!.name!.contains(query)) {
        matchedStudents.add(current);
      }
    }
    return matchedStudents.isNotEmpty
        ? Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.75,
                child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        Future<StudentData> getCurrentData() {
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref();
                          return ref
                              .child('Students/${matchedStudents[index].key}')
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
                                          leading: snapshot.data!
                                                      .profilePictureUri !=
                                                  null
                                              ? CircleAvatar(
                                                  maxRadius: 30,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data!
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
                                          onTap: () {
                                            GlobalArggs.index = index;
                                            GlobalArggs.deleteKey =
                                                matchedStudents[index].key!;
                                            Navigator.pushNamed(
                                                context, '/studentdetails');
                                          })
                                      : Desktop().desktopTile(
                                          snapshot.data!,
                                          () {
                                            bool hasImage = matchedStudents[
                                                            index]
                                                        .currentData!
                                                        .profilePictureUri ==
                                                    null
                                                ? false
                                                : true;
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Dialogs.showDeleteAlert(
                                                        matchedStudents[index]
                                                            .currentData!
                                                            .studentID!,
                                                        matchedStudents[index]
                                                            .currentData!
                                                            .name!,
                                                        context,
                                                        hasImage,
                                                        index,
                                                        matchedStudents[index]
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
                                                      matchedStudents[index]
                                                          .key!,
                                                ),
                                              )),
                                        ))
                              : const CircularProgressIndicator(),
                        );
                      },
                      itemCount: matchedStudents.length,
                    )),
              ),
            ),
          )
        : const Center(child: Text("Not Found"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<StudentModel> matchedStudents = [];
    for (final current in globalStudentList) {
      if (current.currentData!.name!.contains(query)) {
        matchedStudents.add(current);
      }
    }
    return matchedStudents.isNotEmpty
        ? Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.75,
                child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        Future<StudentData> getCurrentData() {
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref();
                          return ref
                              .child('Students/${matchedStudents[index].key}')
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
                                          leading: snapshot.data!
                                                      .profilePictureUri !=
                                                  null
                                              ? CircleAvatar(
                                                  maxRadius: 30,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data!
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
                                          onTap: () {
                                            GlobalArggs.index = index;
                                            GlobalArggs.deleteKey =
                                                matchedStudents[index].key!;
                                            Navigator.pushNamed(
                                                context, '/studentdetails');
                                          })
                                      : Desktop().desktopTile(
                                          snapshot.data!,
                                          () {
                                            bool hasImage = matchedStudents[
                                                            index]
                                                        .currentData!
                                                        .profilePictureUri ==
                                                    null
                                                ? false
                                                : true;
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Dialogs.showDeleteAlert(
                                                        matchedStudents[index]
                                                            .currentData!
                                                            .studentID!,
                                                        matchedStudents[index]
                                                            .currentData!
                                                            .name!,
                                                        context,
                                                        hasImage,
                                                        index,
                                                        matchedStudents[index]
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
                                                      matchedStudents[index]
                                                          .key!,
                                                ),
                                              )),
                                        ))
                              : const CircularProgressIndicator(),
                        );
                      },
                      itemCount: matchedStudents.length,
                    )),
              ),
            ),
          )
        : const Center(
            child: Text("Not Found"),
          );
  }
}
