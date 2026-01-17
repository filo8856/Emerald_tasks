import 'dart:convert';
import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/Screens/chat.dart/task_tile.dart';
import 'package:emerald_tasks/data.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Task2 extends StatefulWidget {
  final List<Task> tasks;
  const Task2({super.key, required this.tasks});

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  List<Task> tasks = [];
  @override
  void initState() {
    tasks = widget.tasks;
    generateTasks();
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> generateTasks() async {
    setState(() => isLoading = true);

    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );
      final existingTasks = tasks.map((t) => t.toJson()).toList();
      final response = await model.generateContent([
        Content.text(
          prompt2 +
              jsonEncode({
                "user_input": _controller.text,
                "tasks": existingTasks,
              }),
        ),
      ]);
      final rawText = response.text;
      if (rawText == null) {
        throw Exception("Empty response from Gemini");
      }
      final cleaned = extractJson(rawText);
      final Map<String, dynamic> decoded = jsonDecode(cleaned);

      final List<Task> updatedTasks = (decoded['tasks'] as List)
          .map((t) => Task.fromJson(t))
          .toList();

      final bool done = decoded['done'] == true;
      final List questions = decoded['questions'] ?? [];
      

      if (!mounted) return;

      setState(() {
        tasks = updatedTasks;
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
          "Missing",
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
                    hintText: "Answer questions...",
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
                            "Recheck tasks",
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
  text = text.replaceAll(RegExp(r'```json|```'), '');

  final firstBrace = text.indexOf('{');
  final lastBrace = text.lastIndexOf('}');

  if (firstBrace == -1 || lastBrace == -1) {
    throw FormatException("No JSON object found");
  }

  var json = text.substring(firstBrace, lastBrace + 1);

  // Remove trailing commas
  json = json.replaceAll(RegExp(r',\s*([\]}])'), r'$1');

  return json;
}
