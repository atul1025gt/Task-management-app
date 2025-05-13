// TODO: UI to add/edit tasks
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../bloc/task_event.dart';
import '../../../data/models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  String _status = 'Pending';
  int _priority = 1;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _status = widget.task?.status ?? 'Pending';
    _priority = widget.task?.priority ?? 1;
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _title,
        description: _description,
        status: _status,
        createdDate: widget.task?.createdDate ?? DateTime.now(),
        priority: _priority,
      );

      final bloc = context.read<TaskBloc>();
      widget.task == null
          ? bloc.add(AddTask(newTask))
          : bloc.add(UpdateTask(newTask));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter title' : null,
                onSaved: (val) => _title = val!,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Pending', 'Completed']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
                onSaved: (val) => _status = val!,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [1, 2, 3]
                    .map((p) => DropdownMenuItem(
                        value: p, child: Text('Priority $p')))
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
                onSaved: (val) => _priority = val!,
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(isEditing ? 'Save Changes' : 'Create Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
