import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage =
  FlutterSecureStorage(); // Secure storage for persistence

  // Sign in with email and password, including isActive check
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      // Perform sign-in
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('employees').doc(result.user?.uid).get();

      // Check if the 'isActive' field is true
      bool isActive = userDoc.get('isActive') ?? false;

      // If user is not active, sign them out and throw an exception
      if (!isActive) {
        await _auth.signOut();
        throw Exception('Account is inactive. Please contact support.');
      }

      // Store the UID in secure storage
      await _storage.write(key: 'user_uid', value: result.user?.uid);

      // Return the user if active
      return result.user;
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.delete(key: 'user_uid'); // Delete UID on sign-out
  }

  // Fetch the role of a user based on UID
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('employees').doc(uid).get();
      return doc.get('role');
    } catch (e) {
      throw Exception('Failed to get role: $e');
    }
  }

  // Fetch the UID of the currently logged-in user from secure storage
  Future<String?> getStoredUserId() async {
    return await _storage.read(key: 'user_uid');
  }
}
