// TODO: Filter/Sort dropdown widget
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/task_bloc.dart';
import '../../../bloc/task_event.dart';
import '../../../data/models/task.dart';

class FilterDropdown extends StatefulWidget {
  const FilterDropdown({super.key});

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  String _selectedStatus = 'All';

  void _onFilterChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedStatus = value;
    });

    context.read<TaskBloc>().add(LoadTasks()); // Reset list before filtering

    if (value != 'All') {
      context.read<TaskBloc>().add(SearchTasks(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedStatus,
      onChanged: _onFilterChanged,
      items: ['All', 'Pending', 'Completed']
          .map((status) => DropdownMenuItem(
                value: status,
                child: Text('Status: $status'),
              ))
          .toList(),
      underline: Container(height: 1, color: Colors.grey),
    );
  }
}
