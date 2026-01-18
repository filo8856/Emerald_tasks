import 'dart:convert';
import 'package:emerald_tasks/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> createCalendarEvents(String accessToken, List<Task> tasks) async {
  for (final task in tasks) {
    if (task.deadline == null || task.effortMinutes == null) continue;

    final DateTime end = task.deadline!;
    DateTime start = end.subtract(Duration(minutes: task.effortMinutes!));

    // Prevent scheduling in the past
    if (start.isBefore(DateTime.now())) {
      start = DateTime.now();
    }

    final event = {
      "summary": task.title,
      "description":
          "Priority: ${task.priority.name}\n${task.additionalDetails}",
      "start": {
        "dateTime": start.toIso8601String(),
        "timeZone": "Asia/Kolkata", // ✅ REQUIRED
      },
      "end": {
        "dateTime": end.toIso8601String(),
        "timeZone": "Asia/Kolkata", // ✅ REQUIRED
      },
    };

    final response = await http.post(
      Uri.parse(
        "https://www.googleapis.com/calendar/v3/calendars/primary/events",
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(event),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("✅ Event added: ${task.title}");
    } else {
      debugPrint("❌ Failed: ${task.title}");
      debugPrint(response.body);
    }
  }
}

Future<List<Map<String, dynamic>>> fetchNextWeekEvents(
  String accessToken,
) async {
  final List<Map<String, dynamic>> allEvents = [];

  final now = DateTime.now();
  final nextWeek = now.add(const Duration(days: 7));

  String? pageToken;

  do {
    final uri = Uri.parse(
      'https://www.googleapis.com/calendar/v3/calendars/primary/events'
      '?timeMin=${now.toUtc().toIso8601String()}'
      '&timeMax=${nextWeek.toUtc().toIso8601String()}'
      '&singleEvents=true'
      '&orderBy=startTime'
      '&maxResults=2500'
      '${pageToken != null ? '&pageToken=$pageToken' : ''}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch events: ${response.statusCode}\n${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final List items = decoded['items'];

    allEvents.addAll(items.cast<Map<String, dynamic>>());

    pageToken = decoded['nextPageToken'];
  } while (pageToken != null);

  return allEvents;
}

