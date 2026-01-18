import 'package:emerald_tasks/Screens/Login.dart';
import 'package:emerald_tasks/Screens/chat.dart/task2.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_input.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_tile.dart';
import 'package:emerald_tasks/Screens/home.dart';
import 'package:emerald_tasks/models/createEventsInCalendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ... 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.42857142857144, 911.2380952380952),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          // home: TaskInputScreen(),
          home: Login(),
          //home: Home(),
          //home: Task2(tasks: [])
          //home: TaskTile(task: task),
        );
      },
    );
  }
}