import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'initial/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCfD3IMTbY0NNLBmbR5eJ97AjDciLlaeRY",
          authDomain: "student-management-web-b973c.firebaseapp.com",
          databaseURL:
              "https://student-management-web-b973c-default-rtdb.firebaseio.com",
          projectId: "student-management-web-b973c",
          storageBucket: "student-management-web-b973c.appspot.com",
          messagingSenderId: "235652828411",
          appId: "1:235652828411:web:800ee2d28b7826bea4b45e"));
  runApp(const MyApp());
}
