// TODO: Auth BLoC for Google Sign-In
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    emit(user != null ? Authenticated(user) : Unauthenticated());
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return emit(Unauthenticated());

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      emit(Authenticated(userCred.user!));
    } catch (e) {
      emit(AuthError("Google Sign-In failed: ${e.toString()}"));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    emit(Unauthenticated());
  }
}
