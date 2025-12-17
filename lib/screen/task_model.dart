import 'dart:convert';

class SubTask {
  String title;
  bool isCompleted;

  SubTask({required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() => {
    'title': title,
    'isCompleted': isCompleted,
  };

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
    title: json['title'],
    isCompleted: json['isCompleted'] ?? false,
  );
}

class Task {
  int id; // <--- TAMBAHAN BARU: ID UNIK UNTUK ALARM
  String title;
  String details;
  String? date;       
  DateTime? deadline; 
  bool isCompleted;
  bool isStarred;
  List<SubTask> subtasks;

  Task({
    required this.id, // Wajib ada ID
    required this.title, 
    this.details = "", 
    this.date,
    this.deadline, 
    this.isCompleted = false,
    this.isStarred = false,
    this.subtasks = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id, // Simpan ID
    'title': title,
    'details': details,
    'date': date,
    'deadline': deadline?.toIso8601String(),
    'isCompleted': isCompleted,
    'isStarred': isStarred,
    'subtasks': subtasks.map((s) => s.toJson()).toList(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    // Kalau data lama tidak punya ID, buat ID baru otomatis pakai waktu sekarang
    id: json['id'] ?? DateTime.now().millisecondsSinceEpoch, 
    title: json['title'],
    details: json['details'] ?? "",
    date: json['date'],
    deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    isCompleted: json['isCompleted'],
    isStarred: json['isStarred'],
    subtasks: json['subtasks'] != null 
      ? (json['subtasks'] as List).map((s) => SubTask.fromJson(s)).toList()
      : [],
  );
}

class TaskGroup {
  String title;
  List<Task> tasks;

  TaskGroup({required this.title, required this.tasks});

  Map<String, dynamic> toJson() => {
    'title': title,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };

  factory TaskGroup.fromJson(Map<String, dynamic> json) => TaskGroup(
    title: json['title'],
    tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
  );
}