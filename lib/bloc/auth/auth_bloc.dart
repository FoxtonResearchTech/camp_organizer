import 'package:camp_organizer/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);

    // Initialize the authentication state on app startup
    _initializeAuthState();
  }

  // Initialize authentication state by checking stored UID
  Future<void> _initializeAuthState() async {
    final storedUid = await authRepository.getStoredUserId();

    if (storedUid != null) {
      // If UID is found, user is authenticated, fetch role and emit state
      await _fetchUserRole(storedUid);
    } else {
      // If no UID, user is unauthenticated
      emit(AuthUnauthenticated());
    }
  }

  // Handle the sign-in request
  void _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Concatenate email with @gmail.com if not already present
      String email = event.email.contains('@') ? event.email : '${event.email}@gmail.com';

      final user = await authRepository.signInWithEmailPassword(
          email, event.password);
      if (user != null) {
        await _fetchUserRole(user.uid); // Fetch role after successful sign-in
      } else {
        emit(AuthError('Authentication failed.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseErrorToMessage(e)));
    } catch (e) {
      emit(AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  // Fetch user role after sign-in
  Future<void> _fetchUserRole(String uid) async {
    try {
      final role = await authRepository.getUserRole(uid);
      emit(AuthAuthenticated(role: role!));
    } catch (e) {
      emit(AuthError('Failed to retrieve user role.'));
    }
  }

  // Handle the sign-out request
  void _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Sign-out failed. Please try again.'));
    }
  }

  // Map Firebase authentication errors to user-friendly messages
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
