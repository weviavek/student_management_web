
import 'package:flutter/material.dart';
import 'package:student_management_website/student_list.dart';
import 'package:student_management_website/students_details.dart';

import 'global_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:const AppBarTheme(color:  Colors.deepPurple,iconTheme: IconThemeData(color: Colors.white),actionsIconTheme: IconThemeData(color: Colors.white),titleTextStyle: TextStyle(color: Colors.white,fontSize: 25,)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const StudentList() ,
      routes: {'/studentdetails':(context)=>StudentDetails(deleteKey: GlobalArggs.deleteKey!, index: GlobalArggs.index!,)},
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

