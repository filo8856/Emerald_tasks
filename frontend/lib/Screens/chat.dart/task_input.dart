import 'dart:convert';
import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_tile.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
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
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );
      final existingTasks = tasks.map((t) => t.toJson()).toList();
      String prompt =
          '''
You are a task state manager.

Input:
- existing_tasks: JSON array of tasks (may be empty), in this format
- Each task must look like:
{
  "Title": "string",
  "deadline": "ISO-8601 datetime or null",
  "effort": number or null,
  "priority": "High | Medium | Low",
  "additional details": "string"
}

- user_input: natural language that may add multiple tasks, specify dependencies, or edit existing tasks.

Output:
Return the COMPLETE, UPDATED JSON array of tasks.

Rules:
1) PRESERVE STATE: The output array MUST include ALL tasks from 'existing_tasks' that were not modified,
   PLUS any new or updated tasks. Do not drop existing tasks unless the user explicitly asks to delete them.
2) Split multiple tasks into separate entries.
3) If the user edits an existing task, update it by matching Title (case-insensitive).
   If ambiguous, choose the closest match and mention ambiguity in "additional details".
4) Put dependencies in "additional details" using: "Depends on: <Title1>, <Title2>".
   Example:
   user_input: "Email mentor after Finish PPT"
   => Email mentor.additional details MUST include "Depends on: Finish PPT"
5) deadline:
   - deadline MUST always be full ISO-8601 datetime or null.
  -  Never return date-only strings.

   - If time is mentioned, use ISO 8601 string (include timezone if available).
   - If missing, null.
6) effort:
   - Convert hours/minutes to integer minutes if possible (e.g., 1.5h -> 90).
   - If missing, null.
7) priority:
   - If not given, infer: urgent deadlines -> High, otherwise Medium; trivial -> Low.

CRITICAL OUTPUT RULES:
- Output MUST be a single JSON array of task objects. No nesting. No extra wrapper keys.
- Never output empty objects {}.
- Keys MUST be exactly: "Title", "deadline", "effort", "priority", "additional details".
- Deduplicate tasks by Title (case-insensitive). If duplicates occur, merge them into ONE task:
  - Prefer values that are not null/empty.
  - If priorities differ, choose the higher urgency: High > Medium > Low.
  this is your ison:-
  ${jsonEncode({"user_input": _controller.text, "tasks": existingTasks})}
''';
      final uri = Uri.parse(
        "https://emerald-ai-1.onrender.com/tasks/update", // 🔴 replace
      );

      // final response = await http.post(
      //   uri,
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode({"user_input": _controller.text, "tasks": tasks}),
      // );

      // // ❗ Always check status code
      // if (response.statusCode != 200) {
      //   throw Exception("Server error: ${response.statusCode}");
      // }
      final response = await model.generateContent([Content.text(prompt)]);
      final rawText = response.text;
      if (rawText == null) {
        throw Exception("Empty response from Gemini");
      }
      final jsonText=extractJson(rawText);
      final List decoded = jsonDecode(jsonText);
      setState(() {
        tasks = (decoded).map((t) => Task.fromJson(t)).toList();
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
