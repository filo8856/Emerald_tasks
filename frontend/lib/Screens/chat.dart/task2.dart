import 'dart:convert';
import 'package:emerald_tasks/Auth.dart';
import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/Screens/Login.dart';
import 'package:emerald_tasks/Screens/chat.dart/task2.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_tile.dart';
import 'package:emerald_tasks/data.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

List<String>? currentQuestions;
bool check(List<Task> tasks) {
  List<String> cur = [];
  bool now = true;
  for (var x in tasks) {
    if (x.deadline == null && x.effortMinutes == null) {
      now = false;
      cur.insert(
        0,
        "How long would \"${x.title}\" take or what is its deadline?",
      );
    }
  }
  currentQuestions = cur;
  return now;
}

class Task2 extends StatefulWidget {
  final List<Task> tasks;
  Task2({super.key, required this.tasks});

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  bool checked = false;
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

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
    checked = check(tasks);
    if (!checked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        showQuestionsPopup(context, currentQuestions!);
      });
    }
  }

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
      print(
        jsonEncode({"user_input": _controller.text, "tasks": existingTasks}),
      );
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

    checked = check(tasks);
    if (!checked) {
      showQuestionsPopup(context, currentQuestions!);
    }
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
          "Null check",
          style: TextStyle(color: CustomTheme.primaryColor, fontSize: 30.r),
        ),
        actions: [
          FloatingActionButton(
            elevation:0.0,
            backgroundColor: CustomTheme.cardBackground,
            child:Icon(Icons.question_mark_rounded,color: CustomTheme.primaryColor),
            onPressed: () {
              if (!checked)
              {
                showQuestionsPopup(context, currentQuestions!);
              }
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
                    hintText: "Fill missing details...",
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
                    onPressed: isLoading
                        ? null
                        : (checked ? null : generateTasks),
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
                            "Fill tasks",
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

void showQuestionsPopup(
  BuildContext context,
  List<String> questions, {
  Duration duration = const Duration(seconds: 3),
}) {
  showDialog(
    context: context,
    barrierColor: CustomTheme.cardBackground,
    barrierDismissible: false, // user cannot dismiss
    builder: (context) {
      // auto close after duration
      Future.delayed(duration, () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return AlertDialog(
        backgroundColor: CustomTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Center(
          child: Text(
            "Quick Questions",
            style: TextStyle(color: CustomTheme.primaryColor, fontSize: 25.r),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: questions
              .take(3)
              .map(
                (q) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    "• $q",
                    style: TextStyle(
                      color: CustomTheme.primaryColor,
                      fontSize: 15.r,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    },
  );
}
