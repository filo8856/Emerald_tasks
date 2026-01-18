import 'package:emerald_tasks/Screens/Constants/custom_theme.dart';
import 'package:emerald_tasks/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

String formatEffort(int? minutes) {
  if (minutes == null) return "Effort: N/A";
  if (minutes < 60) return "Effort: $minutes min";
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? "Effort: ${h}h" : "Effort: ${h}h ${m}m";
}

String priorityLabel(TaskPriority priority) {
  return priority.name[0].toUpperCase() + priority.name.substring(1);
}

// String formatDeadline(DateTime? dateTime) {
//   if (dateTime == null) return "No deadline";

//   final hasTime =
//       !(dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0);

//   if (hasTime) {
//     return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
//   } else {
//     return DateFormat('dd MMM yyyy').format(dateTime);
//   }
// }
String formatDeadline(DateTime? dateTime) {
  if (dateTime == null) return "No deadline";

  return DateFormat('dd MMM yyyy').format(dateTime);
}

class TaskTile extends StatefulWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool show = false;
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
      // padding: EdgeInsets.all(CustomTheme.spacingM),
      padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
      decoration: CustomTheme.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Priority indicator dot
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: getPriorityColor(widget.task.priority),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: CustomTheme.spacingM),

          /// Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title + priority label
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.task.title,
                        style: TextStyle(
                          color: CustomTheme.primaryColor,
                          fontSize: 15.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      priorityLabel(widget.task.priority),
                      style: TextStyle(
                        color: getPriorityColor(widget.task.priority),
                        fontSize: 15.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down,color: CustomTheme.primaryColor),
                    ),
                  ],
                ),

                /// Dependency
                if (widget.task.dependencies.isNotEmpty) ...[
                  SizedBox(height: CustomTheme.spacingXS),
                  Text(
                    "Depends on: ${widget.task.dependencies.join(', ')}",
                    style: TextStyle(
                      color: CustomTheme.primaryColor.withOpacity(0.8),
                      fontSize: 10.r,
                    ),
                  ),
                ],

                /// Deadline
                if (widget.task.deadline != null) ...[
                  SizedBox(height: CustomTheme.spacingXS),
                  Text(
                    "Deadline: ${formatDeadline(widget.task.deadline)}",
                    style: TextStyle(
                      color: CustomTheme.primaryColor,
                      fontSize: 10.r,
                    ),
                  ),
                ],

                /// Effort
                if (widget.task.effortMinutes != null) ...[
                  SizedBox(height: CustomTheme.spacingXS),
                  Text(
                    formatEffort(widget.task.effortMinutes),
                    style: TextStyle(
                      color: CustomTheme.primaryColor,
                      fontSize: 10.r,
                    ),
                  ),
                ],
                if (show == true) ...[
                  SizedBox(height: CustomTheme.spacingXS),
                  Text(
                    "Additional details: ${widget.task.additionalDetails}",
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
