// TODO: Task model
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String title;
  final String description;
  final String status; // e.g. 'Pending', 'Completed'
  final DateTime createdDate;
  final int priority;  // e.g. 1 = low, 2 = medium, 3 = high

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
