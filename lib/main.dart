// TODO: App entry point
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/task_bloc.dart';
import 'bloc/theme_cubit.dart';
import 'data/repositories/task_repository.dart';
import 'data/providers/task_api_provider.dart';
import 'ui/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AppStarted())),
        BlocProvider(create: (_) => TaskBloc(TaskRepository(apiProvider: TaskApiProvider()))),
        BlocProvider(create: (_) => ThemeCubit()), // <- ThemeCubit
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'Task Manager',
            theme: theme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}

