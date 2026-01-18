import 'dart:convert';
import 'package:emerald_tasks/Auth.dart';
import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/Screens/Login.dart';
import 'package:emerald_tasks/Screens/chat.dart/task2.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_tile.dart';
import 'package:emerald_tasks/data.dart';
import 'package:emerald_tasks/models/createEventsInCalendar.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key});

  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  List<Map<String, dynamic>> calendarEvents = [];
  bool isLoadingCalendar = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_fetchCalendarEvents();
  }

  Future<void> _fetchCalendarEvents() async {
    try {
      final events = await fetchNextWeekEvents(token);

      if (!mounted) return; // safety check

      setState(() {
        calendarEvents = events;
        isLoadingCalendar = false;
      });
      debugPrint(calendarEvents.toString());
    } catch (e) {
      debugPrint("Failed to fetch calendar events: $e");

      if (!mounted) return;

      setState(() {
        isLoadingCalendar = false;
      });
    }
  }

  void logOut() async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  final TextEditingController _controller = TextEditingController();
  List<Task> tasks = [];
  bool isLoading = false;

  Future<void> generateTasks() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    try {
      // final data = {
      //   "tasks": [
      //     {
      //       "Title": "Finish ML Assignment",
      //       "deadline": "2026-01-20T23:59:00",
      //       "effort": 180,
      //       "priority": "High",
      //       "additional details": "Logistic regression + report submission",
      //     },
      //     {
      //       "Title": "Go to Gym",
      //       "deadline": null,
      //       "effort": 60,
      //       "priority": "Medium",
      //       "additional details": "Strength + cardio workout",
      //     },
      //     {
      //       "Title": "Call Parents",
      //       "deadline": "2026-01-18T21:00:00",
      //       "effort": 30,
      //       "priority": "Low",
      //       "additional details": "Weekly catch-up call",
      //     },
      //   ],
      // };
      // final model = FirebaseAI.googleAI().generativeModel(
      //   model: 'gemini-2.5-flash',
      // );
      //   final existingTasks = tasks.map((t) => t.toJson()).toList();
      final uri = Uri.parse(
        "https://emerald-ai-1.vercel.app/tasks/update", // 🔴 replace
      );

      final existingTasks = tasks.map((t) => t.toJson()).toList();
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_input": _controller.text,
          "tasks": existingTasks,
        }),
      );

      //   // ❗ Always check status code
      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      print(decoded);
      final List<Task> updatedTasks = (decoded['tasks'] as List)
          .map((t) => Task.fromJson(t))
          .toList();
      if (!mounted) return;

      setState(() {
        tasks = updatedTasks;
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }

    //   final response = await model.generateContent([
    //     Content.text(
    //       prompt1 +
    //           jsonEncode({
    //             "user_input": _controller.text,
    //             "tasks": existingTasks,
    //           }),
    //     ),
    //   ]);
    //   final rawText = response.text;
    //   if (rawText == null) {
    //     throw Exception("Empty response from Gemini");
    //   }
    //   final List decoded = jsonDecode(extractJson(rawText));
    //   setState(() {
    //     tasks = (decoded).map((t) => Task.fromJson(t)).toList();
    //   });
    // } catch (e) {
    //   debugPrint(e.toString());
    // } finally {
    //   setState(() => isLoading = false);
    // }
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.cardBackground,
      drawer: Drawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: logOut,
          icon: Icon(Icons.logout),
          color: CustomTheme.borderGoldLight,
        ),
        centerTitle: true,
        backgroundColor: CustomTheme.cardBackground,
        title: Text(
          "My Tasks",
          style: TextStyle(color: CustomTheme.primaryColor, fontSize: 30.r),
        ),
        actions: [
          FloatingActionButton(
            elevation: 0.0,
            backgroundColor: CustomTheme.cardBackground,
            child: Icon(
              Icons.question_mark_rounded,
              color: CustomTheme.primaryColor,
            ),
            onPressed: () {
              if (tasks.isNotEmpty)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Task2(tasks: tasks)),
                );
            },
            mini: true,
          ),
        ],
      ),
      body: Column(
        children: [
          /// 🔼 TASK LIST
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      "No tasks yet",
                      style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontSize: 20.r,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(CustomTheme.spacingM),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskTile(task: tasks[index]);
                    },
                  ),
          ),

          /// 🔽 INPUT AREA
          Container(
            padding: EdgeInsets.all(CustomTheme.spacingM),
            decoration: BoxDecoration(
              color: CustomTheme.cardBackground,
              border: Border(
                top: BorderSide(color: CustomTheme.borderGold, width: 1.w),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  maxLines: 3,

                  style: TextStyle(
                    color: CustomTheme.primaryColor,
                    fontSize: 20.r,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none, // 👈 removes underline
                    enabledBorder:
                        InputBorder.none, // 👈 removes when not focused
                    focusedBorder: InputBorder.none,
                    hintText: "Describe your tasks naturally...",
                    hintStyle: TextStyle(
                      color: CustomTheme.primaryColor,
                      fontSize: 20.r,
                    ),
                  ),
                ),
                SizedBox(height: CustomTheme.spacingS),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomTheme.cardBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: CustomTheme.primaryGold, // 👈 gold border
                          width: 1.5.w,
                        ),
                      ),
                    ),
                    onPressed: isLoading ? null : generateTasks,
                    child: isLoading
                        ? SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: CustomTheme.primaryColor,
                            ),
                          )
                        : Text(
                            "Generate Tasks",
                            style: TextStyle(
                              color: CustomTheme.primaryColor,
                              fontSize: 20.r,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String extractJson(String text) {
  final start = text.indexOf('[');
  final end = text.lastIndexOf(']');
  if (start == -1 || end == -1) {
    throw Exception("No JSON array found in response");
  }
  return text.substring(start, end + 1);
}
