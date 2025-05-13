// TODO: Task events
import '../data/models/task.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task task;
  UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final int taskId;
  DeleteTask(this.taskId);
}

class SearchTasks extends TaskEvent {
  final String query;
  SearchTasks(this.query);
}
