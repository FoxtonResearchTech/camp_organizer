import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // Secure storage for persistence

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _storage.write(
          key: 'user_uid', value: result.user?.uid); // Store UID on sign-in
      return result.user;
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.delete(key: 'user_uid'); // Delete UID on sign-out
  }

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
