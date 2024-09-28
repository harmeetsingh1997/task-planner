import 'package:flutter/material.dart';

class Task {
  final String id;
  final String task;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  bool isChecked;

  Task({
    required this.id,
    required this.task,
    required this.description,
    required this.date,
    required this.time,
    this.isChecked = false,
  });
  Task copyWith({
    String? id,
    String? task,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    bool? isChecked,
  }) {
    return Task(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      isChecked: isChecked ?? this.isChecked,
    );
  }


  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '', // Add id parsing
      task: json['task'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] != null
          ? TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      )
          : TimeOfDay.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in the map
      'task': task,
      'description': description,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'isChecked': isChecked,
    };
  }
}
