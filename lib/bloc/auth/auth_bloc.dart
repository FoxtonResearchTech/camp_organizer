import 'package:camp_organizer/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmailPassword(event.email, event.password);
      if (user != null) {
        await _fetchUserRole(user.uid, emit);
      } else {
        emit(AuthError('Authentication failed.'));
      }
    } on FirebaseAuthException catch (e) {
      // Firebase-specific error handling
      emit(AuthError(_mapFirebaseErrorToMessage(e)));
    } catch (e) {
      emit(AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _fetchUserRole(String uid, Emitter<AuthState> emit) async {
    try {
      final role = await authRepository.getUserRole(uid);
      emit(AuthAuthenticated(role: role!));
    } catch (e) {
      emit(AuthError('Failed to retrieve user role.'));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Sign-out failed. Please try again.'));
    }
  }

  String _mapFirebaseErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
