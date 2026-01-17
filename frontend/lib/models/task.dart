enum TaskPriority { low, medium, high, critical }

class Task {
  /// Short name shown in list / calendar
  final String title;

  /// Extra notes / dependencies
  final String additionalDetails;

  /// Optional deadline
  final String? dependency;
  final DateTime? deadline;

  /// Estimated effort in minutes
  final int? effortMinutes;

  /// Importance level
  final TaskPriority priority;

  Task({
    required this.title,
    this.dependency,
    this.additionalDetails = '',
    this.deadline,
    this.effortMinutes,
    this.priority = TaskPriority.low,
  });

  /// ----------------------------
  /// JSON ➜ Dart
  /// ----------------------------
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json["Title"],
      dependency:json["dependency"],
      additionalDetails: json["additional details"] ?? '',
      deadline: json["deadline"] != null
          ? DateTime.parse(json["deadline"])
          : null,
      effortMinutes: json["effort"],
      priority: _parsePriority(json["priority"]),
    );
  }

  /// ----------------------------
  /// Dart ➜ JSON
  /// ----------------------------
  Map<String, dynamic> toJson() {
    return {
      "Title": title,
      "dependency":dependency,
      "deadline": deadline?.toIso8601String(),
      "effort": effortMinutes,
      "priority": priority.name[0].toUpperCase() + priority.name.substring(1),
      "additional details": additionalDetails,
    };
  }

  /// ----------------------------
  /// Helper for priority parsing
  /// ----------------------------
  static TaskPriority _parsePriority(String? value) {
    switch (value?.toLowerCase()) {
      case "low":
        return TaskPriority.low;
      case "medium":
        return TaskPriority.medium;
      case "high":
        return TaskPriority.high;
      case "critical":
        return TaskPriority.critical;
      default:
        return TaskPriority.medium;
    }
  }
}
