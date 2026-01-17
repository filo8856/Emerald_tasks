final nowIso = DateTime.now().toIso8601String();

String prompt1 =
    '''
Current date and time (ISO 8601):
$nowIso

Rules:
- Interpret relative dates like "today", "tomorrow", "next Monday" based on the above date.
You are a task state manager.

Input:
- existing_tasks: JSON array of tasks (may be empty), in this format
- Each task must look like:
{
  "Title": "string",
  "dependency": "string",
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
  ''';
String prompt2 = '''
You are a stateful task clarification and update agent.

You will be called repeatedly in a loop.

Each call provides:
1) current_tasks: a JSON array of task objects
2) user_reply: the user's latest answer (empty on the first call)

Task model (STRICT):
Each task has:
- Title (string, required)
- deadline (ISO-8601 datetime or null)
- effort (integer minutes or null)
- priority (Low | Medium | High | Critical)
- dependency (string or null)
- additional details (string)

Your responsibilities (DO IN ORDER):

STEP 1 — APPLY USER REPLY
- If user_reply is not empty:
  - Use it to update ONLY the relevant missing or ambiguous fields.
  - Match tasks by Title (case-insensitive).
  - NEVER overwrite fields that are already filled unless the user explicitly changes them.
  - If the reply answers multiple questions, apply all of them.

STEP 2 — CHECK COMPLETENESS
A task is COMPLETE only if ALL are known:
- deadline (or explicitly confirmed as none)
- effort (integer minutes)
- priority
- dependency (string or explicitly none)

STEP 3 — ASK FOLLOW-UP QUESTIONS (IF NEEDED)
- Identify ALL remaining missing fields across ALL tasks.
- Ask ONLY targeted clarification questions for those fields.
- Group questions logically.
- Prefer multiple-choice options where possible.
- NEVER ask about fields that are already complete.
- NEVER repeat a question already answered.

STEP 4 — OUTPUT UPDATED STATE

Response format (STRICT JSON ONLY):

{
  "tasks": [
    {
      "Title": "...",
      "deadline": "... or null",
      "effort": number or null,
      "priority": "Low | Medium | High | Critical",
      "dependency": "... or null",
      "additional details": "..."
    }
  ],
  "questions": [
    {
      "task": "<Title or 'Multiple tasks'>",
      "field": "<deadline | effort | priority | dependency | flexibility>",
      "question": "<clear concise question>",
      "options": [optional array of suggested answers]
    }
  ],
  "done": false
}

If ALL tasks are complete, return:

{
  "tasks": [ ...final updated tasks... ],
  "questions": [],
  "done": true
}

CRITICAL RULES:
- NEVER hallucinate values.
- NEVER drop tasks.
- NEVER output explanations or markdown.
- NEVER output partial JSON.
- Keys MUST match exactly.
- Output MUST always include the updated tasks array.
''';
