# AI-Powered Personal Planning & Scheduling Agent

## Overview

The **AI-Powered Personal Planning & Scheduling Agent** is an intelligent assistant that helps users plan their day or week efficiently. Users can provide tasks in natural language, and the system will reason about priorities, effort, deadlines, and personal constraints, automatically scheduling tasks in the user’s Google Calendar.

The system architecture combines:

* **Flutter frontend** – for task input and user interaction.
* **Firebase Authentication** – to securely sign in users via Google accounts.
* **Google Calendar API** – to read and write calendar events using OAuth tokens.
* **AI module (Python + Gemini)** – to prioritize tasks based on natural language input and return an optimal task execution order.

---

## Features

* **Natural Language Task Input**
  Users can describe tasks in plain English, including optional details like deadlines, estimated effort, or priority.

* **Clarification & Context Gathering**
  The AI module can ask follow-up questions to fill in missing details such as task duration, urgency, flexibility, or dependencies.

* **AI-Powered Prioritization**
  Gemini-based reasoning generates a task priority order that balances deadlines, effort, and importance.

* **Google Calendar Integration**
  Reads existing events and schedules tasks in available time slots without conflicts.

* **Automatic Scheduling**
  Creates events in Google Calendar while respecting working hours, breaks, and required intervals between tasks.

* **Dynamic Rescheduling**
  Updates schedules in real-time when tasks change or new tasks are added, providing explanations for any adjustments.

---

## Architecture

```
Flutter Frontend
      │
      ▼
Firebase Auth (OAuth tokens)
      │
      ▼
AI Module (Python + Gemini)
      │
      ▼
Google Calendar API
      │
      ▼
Scheduled Events in Google Calendar
```

---

## Requirements

* Flutter 3.x+
* Dart 3.x+
* Firebase project for authentication
* Google Cloud project with Calendar API enabled
* Python 3.9+ (for Gemini AI module)
* Internet connection

---

## Usage

### 1. Set Up Firebase Authentication

1. Create a Firebase project.
2. Enable **Google Sign-In** in Firebase Authentication.
3. Add your Flutter app to Firebase and download `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
4. Configure FlutterFire in your project.

### 2. Run the Flutter App

```bash
flutter pub get
flutter run
```

The app provides a user interface to:

* Sign in with Google.
* Add tasks in natural language.
* Review clarifications from the AI module.
* View the scheduled tasks in Google Calendar.

### 3. AI Module (Python + Gemini)

1. Set up your Python environment:

```bash
python -m venv venv
source venv/bin/activate   # Linux / macOS
venv\Scripts\activate      # Windows
pip install -r requirements.txt
```

2. Run the AI module server or API endpoint.

   * The module receives task data from the Flutter app.
   * Gemini processes the tasks, assigns priority, and returns the execution order.

### 4. Google Calendar Integration

* The Flutter app sends the OAuth token to the AI module.
* The AI module uses the token with the Google Calendar API to schedule tasks based on Gemini’s priorities.
* All tasks are created as events in the user’s Google Calendar with no overlaps.

### 5. Updating Tasks

* Add, edit, or remove tasks anytime via the Flutter app.
* The AI module will recompute priorities and update Google Calendar events dynamically.

---

## Example Task Input

```text
- Finish project report, due Friday, estimated 3 hours
- Prepare presentation slides, medium priority
- Team meeting tomorrow at 2 PM
- Lunch break from 12 PM to 1 PM
```

---

## Future Enhancements

* Personalized learning to adapt task priorities based on user behavior.
* Integration with other task management apps like Todoist or Asana.
* Multi-user scheduling and collaboration.
* Support for recurring tasks and habits.

---