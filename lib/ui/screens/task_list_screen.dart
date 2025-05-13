import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../bloc/task_event.dart';
import '../../../bloc/task_state.dart';
import '../../../bloc/theme_cubit.dart';
import '../../../data/models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/filter_dropdown.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<TaskBloc>().add(SearchTasks(query));
  }

  void _onFilterChanged(String? value) {
    if (value == null) return;
    setState(() => _selectedStatus = value);
    context.read<TaskBloc>().add(LoadTasks()); // Reset

    if (value != 'All') {
      context.read<TaskBloc>().add(SearchTasks(value));
    }
  }

  void _navigateToForm({Task? task}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // 🔽 Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              onChanged: _onFilterChanged,
              items: ['All', 'Pending', 'Completed']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text('Status: $status'),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // 📝 Task List
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(child: Text('No tasks available.'));
                  }
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskCard(
                        task: task,
                        onEdit: () => _navigateToForm(task: task),
                        onDelete: () =>
                            context.read<TaskBloc>().add(DeleteTask(task.id)),
                      );
                    },
                  );
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),

      // ➕ FAB to Add Task
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
