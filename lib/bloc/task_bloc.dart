// TODO: Task BLoC logic
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/task_repository.dart';
import '../data/models/task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;
  List<Task> _allTasks = [];

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<SearchTasks>(_onSearchTasks);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      _allTasks = await repository.getTasks();
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: ${e.toString()}'));
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await repository.addTask(event.task);
      add(LoadTasks()); // reload
    } catch (e) {
      emit(TaskError('Failed to add task: ${e.toString()}'));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await repository.updateTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError('Failed to update task: ${e.toString()}'));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.taskId);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError('Failed to delete task: ${e.toString()}'));
    }
  }

  void _onSearchTasks(SearchTasks event, Emitter<TaskState> emit) {
    final filtered = _allTasks
        .where((task) =>
            task.title.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(TaskLoaded(filtered));
  }
}
