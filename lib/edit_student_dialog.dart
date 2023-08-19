import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_management_website/model/student.dart';

import 'natifiers.dart';

class EditStudent {
  final String currentKey;
  final BuildContext context;
  EditStudent({required this.currentKey, required this.context});
  show() async {
    bool imageChanged = false;
    DatabaseReference currentDataReference = FirebaseDatabase.instance.ref();
    StudentData currentData = StudentData.fromJson(await currentDataReference
        .child('Students/$currentKey')
        .get()
        .then((snapshot) {
      return snapshot.value as Map;
    }));
    TextEditingController nameContoller =
        TextEditingController(text: currentData.name);
    TextEditingController studentIDContoller =
        TextEditingController(text: currentData.studentID);
    TextEditingController emailIDContoller =
        TextEditingController(text: currentData.email);
    TextEditingController phoneNumberContoller =
        TextEditingController(text: currentData.phoneNumber);
    TextEditingController ageContoller =
        TextEditingController(text: currentData.age);

    PlatformFile? pickedFile;
    String? imagePath = currentData.profilePictureUri != null
        ? currentData.profilePictureUri!
        : null;

    void clearButtonFunction() {
      nameContoller.text = '';
      studentIDContoller.text = '';
      emailIDContoller.text = '';
      phoneNumberContoller.text = '';
      ageContoller.text = '';
      pickedFile = null;
      imagePath = null;
      Notifiers.notifyImage();
    }

    Future<void> imagePickHelper() async {
      imageNotifier.value = false;
      await FilePicker.platform.pickFiles(type: FileType.image).then((value) =>
          pickedFile = value != null ? value.files.first : pickedFile);
    }

    if (context.mounted) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Please Fill Up Following Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: imageNotifier,
                builder: (context, value, child) => Flexible(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: imagePath != null
                        ? Stack(children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(imagePath!),
                              maxRadius: 300,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: FloatingActionButton(
                                onPressed: () {
                                  imagePath = null;
                                  pickedFile = null;
                                  Notifiers.notifyImage();
                                },
                                child: const Icon(Icons.delete_rounded),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                onPressed: () async {
                                  await imagePickHelper();
                                  Uint8List? imageInBytes = pickedFile!.bytes;
                                  var tempReference = FirebaseStorage.instance
                                      .ref()
                                      .child('images/temp.jpg');
                                  await tempReference.putData(imageInBytes!);
                                  imageChanged = true;
                                  imagePath =
                                      await tempReference.getDownloadURL();
                                  imageNotifier.value = true;
                                  Notifiers.notifyImage();
                                },
                                child: const Icon(Icons.edit),
                              ),
                            )
                          ])
                        : Stack(children: [
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/student-management-web-b973c.appspot.com/o/images%2Fdefault_image.jpg?alt=media&token=34741d05-39ce-47d7-887d-037b85cc037a"),
                              maxRadius: 300,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                onPressed: () async {
                                  await imagePickHelper();
                                  if (pickedFile != null) {
                                    Uint8List? imageInBytes = pickedFile!.bytes;
                                    imageChanged = true;
                                    var tempReference = FirebaseStorage.instance
                                        .ref()
                                        .child('images/temp.jpg');
                                    tempReference.putData(imageInBytes!);
                                    imageNotifier.value = true;
                                    imageNotifier.value = true;
                                    Notifiers.notifyImage();
                                  }
                                },
                                child: const Icon(Icons.add_a_photo_rounded),
                              ),
                            )
                          ]),
                  ),
                ),
              ),
              TextFormField(
                controller: nameContoller,
                decoration: const InputDecoration(
                    hintText: "Student Name", labelText: "Student Name"),
              ),
              TextFormField(
                controller: studentIDContoller,
                decoration: const InputDecoration(
                    hintText: "Student ID", labelText: "Student ID"),
              ),
              TextFormField(
                  controller: emailIDContoller,
                  decoration: const InputDecoration(
                      hintText: "Email ID", labelText: "Email ID")),
              TextFormField(
                  controller: phoneNumberContoller,
                  decoration: const InputDecoration(
                      hintText: "Phone Number", labelText: "Phone Number")),
              TextFormField(
                  controller: ageContoller,
                  decoration:
                      const InputDecoration(hintText: "Age", labelText: "Age"))
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => clearButtonFunction(),
                child: const Text("Clear")),
            ElevatedButton(
                onPressed: () async {
                  if (imageChanged) {
                    var tempReference =
                        FirebaseStorage.instance.ref().child('images/temp.jpg');
                    tempReference.delete();
                  }
                  var imageReference = FirebaseStorage.instance.ref().child(
                      'images/${nameContoller.text}${studentIDContoller.text}.jpg');
                  Navigator.of(context).pop();
                  if (pickedFile != null) {
                    Uint8List? imageInBytes = pickedFile!.bytes;
                    await imageReference.putData(imageInBytes!);
                    imagePath = await imageReference.getDownloadURL();
                  }

                  Map<String, String?> currentStudentData = {
                    'name': nameContoller.text.toString(),
                    'studentID': studentIDContoller.text.toString(),
                    'email': emailIDContoller.text.toString(),
                    'phone': phoneNumberContoller.text.toString(),
                    'age': ageContoller.text.toString(),
                    'profilePictureUri': imagePath
                  };

                  await FirebaseDatabase.instance
                      .ref('Students')
                      .child(currentKey)
                      .update(currentStudentData);
                  Notifiers.notifyDetails();
                  Notifiers.notifyList();
                },
                child: const Text("Submit"))
          ],
        ),
      );
    }
  }
}
