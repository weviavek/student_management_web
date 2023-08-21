import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_management_website/pages/student_list.dart';

import '../functions/natifiers.dart';

class Dialogs {
  static Widget showDeleteAlert(String id, String name, BuildContext context,
      bool hasImage, int index, String deleteKey) {
    return AlertDialog(
      content: Text("Do you want to delete $name permenently?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () async {
              StudentListState.listOfStudents.removeAt(index);
              if (hasImage) {
                final tempRef =
                    FirebaseStorage.instance.ref().child('images/$name$id.jpg');
                tempRef.delete();
              }
              Navigator.of(context).popUntil((route) => route.isFirst);
              DatabaseReference dbRef =
                  FirebaseDatabase.instance.ref().child("Students");
              await dbRef.child(deleteKey).remove();
              Notifiers.notifyList();
            },
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
            child: const Text("Delete")),
      ],
    );
  }
}
