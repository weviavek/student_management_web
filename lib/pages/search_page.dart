import 'package:flutter/material.dart';
import 'package:student_management_website/model/student.dart';

List<StudentModel>globalStudentList=[];
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
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              title: Text(matchedStudents[index].currentData!.name!),
            ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: matchedStudents.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<StudentModel> matchedStudents = [];
    for (final current in globalStudentList) {
      if (current.currentData!.name!.contains(query)) {
        matchedStudents.add(current);
      }
    }
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              title: Text(matchedStudents[index].currentData!.name!),
            ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: matchedStudents.length);
  }
}
