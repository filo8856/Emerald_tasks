import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Title')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
        child: SizedBox(
          height: 50.h,
          child: Container(color: Colors.black),
        ),
      ),
    );
  }
}
