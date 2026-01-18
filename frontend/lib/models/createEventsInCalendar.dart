import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createCalendarEvents(String accessToken, List<dynamic> tasks) async {
  for (var task in tasks) {
    String title = task['Title'];
    String details = task['additional details'] ?? '';
    String priority = task['priority'] ?? 'Medium';

    String? deadline = task['deadline'];

    if (deadline == null) continue; // skip tasks without deadline

    DateTime start = DateTime.parse(deadline);
    int duration = task['effort'] ?? 30;

    DateTime end = start.add(Duration(minutes: duration));

    var event = {
      "summary": title,
      "description": "Priority: $priority\nDetails: $details",
      "start": {
        "dateTime": start.toIso8601String(),
        "timeZone": "Asia/Kolkata"
      },
      "end": {
        "dateTime": end.toIso8601String(),
        "timeZone": "Asia/Kolkata"
      }
    };

    final response = await http.post(
      Uri.parse("https://www.googleapis.com/calendar/v3/calendars/primary/events"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode(event),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Event added successfully: ${event['summary']}");
    } else {
      print("❌ Failed to add event: ${event['summary']}");
      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");
    }


  }
}