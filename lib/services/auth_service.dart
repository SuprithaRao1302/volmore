import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user's UID in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', userCredential.user!.uid);

      return userCredential;
    } catch (e) {
      // Handle sign-in errors
      print('Sign in error: $e');
      return null;
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user's UID in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', userCredential.user!.uid);

      return userCredential;
    } catch (e) {
      // Handle sign-up errors
      print('Sign up error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Clear the stored UID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');

      await _auth.signOut();
    } catch (e) {
      // Handle sign-out errors
      print('Sign out error: $e');
    }
  }


  // Reset password
  
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      // Handle reset password errors
      print('Reset password error: $e');
      return false;
    }
  }
}