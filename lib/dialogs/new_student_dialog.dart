import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_management_website/functions/natifiers.dart';

import '../functions/validators.dart';

class StudentDialogs {
  BuildContext context;
  StudentDialogs(this.context);
  newStudentDialog() {
    TextEditingController nameContoller = TextEditingController();
    TextEditingController studentIDContoller = TextEditingController();

    TextEditingController emailIDContoller = TextEditingController();
    TextEditingController phoneNumberContoller = TextEditingController();
    TextEditingController ageContoller = TextEditingController();
    DatabaseReference currentDataReference = FirebaseDatabase.instance.ref();
    var tempImageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');

    PlatformFile? pickedFile;
    String? imagePath;
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

    final formKey = GlobalKey<FormState>();
    Future<void> imagePickHelper() async {
      imageNotifier.value = false;
      await FilePicker.platform.pickFiles(type: FileType.image).then((value) =>
          pickedFile = value != null ? value.files.first : pickedFile);
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Please Fill Up Following Details"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
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
                                    await tempImageReference
                                        .putData(imageInBytes!);
                                    imagePath =
                                        await tempImageReference.getDownloadURL();
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
                                      await tempImageReference
                                          .putData(imageInBytes!);
                                      imagePath = await tempImageReference
                                          .getDownloadURL();
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Validator.nameValidator(value),
                  controller: nameContoller,
                  decoration: const InputDecoration(
                      hintText: "Student Name", labelText: "Student Name"),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Validator.studentIDValidator(value,false),
                  controller: studentIDContoller,
                  decoration: const InputDecoration(
                      hintText: "Student ID", labelText: "Student ID"),
                ),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validator.emailValidator(value),
                    controller: emailIDContoller,
                    decoration: const InputDecoration(
                        hintText: "Email ID", labelText: "Email ID")),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validator.phoneNumberValidator(value),
                    controller: phoneNumberContoller,
                    decoration: const InputDecoration(
                        hintText: "Phone Number", labelText: "Phone Number")),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validator.ageValidator(value),
                    controller: ageContoller,
                    decoration:
                        const InputDecoration(hintText: "Age", labelText: "Age"))
              ],
            ),
          ),
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
                Future<void> currentFunction() async {
                  var imageReference = FirebaseStorage.instance.ref().child(
                      'images/${nameContoller.text}${studentIDContoller.text}.jpg');
                  if (pickedFile != null) {
                    tempImageReference.delete();
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
                  currentDataReference
                      .child("Students")
                      .push()
                      .set(currentStudentData)
                      .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                }

                if (formKey.currentState!.validate()) {
                  if (pickedFile != null) {
                    await currentFunction();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text(
                            "Do you want to continue without adding an image?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("No")),
                          ElevatedButton(
                              onPressed: () => currentFunction(),
                              child: const Text("Yes"))
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Text("Submit"))
        ],
      ),
    );
  }
}
