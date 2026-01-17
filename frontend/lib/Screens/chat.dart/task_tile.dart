import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

String formatDeadline(DateTime? dateTime) {
  if (dateTime == null) return "No deadline";

  final hasTime =
      !(dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0);

  if (hasTime) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
  } else {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return CustomTheme.errorColor;
      case TaskPriority.medium:
        return CustomTheme.warningColor;
      case TaskPriority.low:
        return CustomTheme.successColor;
      case TaskPriority.critical:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: CustomTheme.spacingS),
      padding: EdgeInsets.all(CustomTheme.spacingM),
      decoration: CustomTheme.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Priority indicator
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: getPriorityColor(task.priority),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: CustomTheme.spacingM),

          /// Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  task.title,
                  style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontSize: 15.r,
                      ),
                ),

                /// Additional details / dependencies
                if (task.dependency!=null) ...[
                  SizedBox(height: CustomTheme.spacingXS),
                  Text(
                    task.dependency!,
                    style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontSize: 10.r,
                      ),
                  ),
                ],

                /// Deadline
                if (task.deadline != null) ...[
                  SizedBox(height: CustomTheme.spacingXS),
                  Text(
                    formatDeadline(task.deadline),
                    style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontSize: 10.r,
                      ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
