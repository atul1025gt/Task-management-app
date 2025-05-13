// TODO: Google Sign-In screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc.dart';
import 'task_list_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TaskListScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthInitial || state is Unauthenticated) {
            return Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                onPressed: () {
                  context.read<AuthBloc>().add(SignInWithGoogle());
                },
              ),
            );
          } else if (state is Authenticated) {
            return const Center(child: Text('Logged in!'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
