import 'package:emerald_tasks/Screens/chat.dart/task_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';

class ReasoningScreen extends StatelessWidget {
  final String reasoning;

  const ReasoningScreen({super.key, required this.reasoning});

  @override
  Widget build(BuildContext context) {
    final lines = reasoning
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: CustomTheme.cardBackground,
      appBar: AppBar(
        backgroundColor: CustomTheme.cardBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Why this schedule?",
          style: TextStyle(
            color: CustomTheme.primaryColor,
            fontSize: 24.r,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomTheme.primaryColor,
            size: 40.r,
          ),
          onPressed: () {
            token = "";
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TaskInputScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(CustomTheme.spacingM),
        child: Markdown(
          data: reasoning,
          physics: const BouncingScrollPhysics(),
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: CustomTheme.primaryColor,
              fontSize: 16.w,
              height: 1.4,
            ),
            strong: TextStyle(
              color: CustomTheme.primaryGold,
              fontWeight: FontWeight.bold,
            ),
            em: TextStyle(
              fontStyle: FontStyle.italic,
              color: CustomTheme.primaryColor,
            ),
            listBullet: TextStyle(
              color: CustomTheme.primaryGold,
              fontSize: 18.w,
            ),
            h1: TextStyle(
              color: CustomTheme.primaryGold,
              fontSize: 22.w,
              fontWeight: FontWeight.bold,
            ),
            h2: TextStyle(
              color: CustomTheme.primaryGold,
              fontSize: 20.w,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
