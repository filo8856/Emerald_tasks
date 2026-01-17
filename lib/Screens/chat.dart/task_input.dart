import 'dart:convert';
import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_tile.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key});

  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Task> tasks = [];
  bool isLoading = false;

  Future<void> generateTasks() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    try {
      final data = {
        "tasks": [
          {
            "Title": "Finish ML Assignment",
            "deadline": "2026-01-20T23:59:00",
            "effort": 180,
            "priority": "High",
            "additional details": "Logistic regression + report submission",
          },
          {
            "Title": "Go to Gym",
            "deadline": null,
            "effort": 60,
            "priority": "Medium",
            "additional details": "Strength + cardio workout",
          },
          {
            "Title": "Call Parents",
            "deadline": "2026-01-18T21:00:00",
            "effort": 30,
            "priority": "Low",
            "additional details": "Weekly catch-up call",
          },
        ],
      };

      // final uri = Uri.parse(
      //   "https://api.example.com/parse-tasks", // 🔴 replace
      // );

      // final response = await http.post(
      //   uri,
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode({"input_text": _controller.text}),
      // );

      // // ❗ Always check status code
      // if (response.statusCode != 200) {
      //   throw Exception("Server error: ${response.statusCode}");
      // }

      // final data = jsonDecode(response.body);
      setState(() {
        tasks = (data["tasks"] as List).map((t) => Task.fromJson(t)).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.cardBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomTheme.cardBackground,
        title: Text(
          "My Tasks",
          style: TextStyle(color: CustomTheme.primaryColor, fontSize: 30.r),
        ),
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
                    fontSize: 20.w,
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
                              color: Colors.black,
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
