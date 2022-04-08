import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:x_book_app/models/user.dart';


// All the methods that will interact with Firebase Auth

class AuthService {

final FirebaseAuth _auth = FirebaseAuth.instance;

// create User Object based on Firebase User Info 
CustomUser? _userFromFirebaseUser(User user) {
  return CustomUser(uid: user.uid);
}


// Auth Change Stream

Stream<CustomUser?> get user {
  return _auth.authStateChanges()
  .map((User? user) => _userFromFirebaseUser(user!));
}

// Sign in Anonymously 
Future signInAnon() async {
  try {
    UserCredential result =  await _auth.signInAnonymously();
    User? user = result.user;
    return _userFromFirebaseUser(user!);
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return null;
  }
}

// Sign in email and password 
Future signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result =  await _auth.signInWithEmailAndPassword(email: email, password: password); 
    User? user = result.user;
    return _userFromFirebaseUser(user!);
  } catch (e) {
    print(e.toString());
    return null;
  }
}


// Register with email and password 
Future registerWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result =  await _auth.createUserWithEmailAndPassword(email: email, password: password); 
    User? user = result.user;
    return _userFromFirebaseUser(user!);
  } catch (e) {
    print(e.toString());
    return null;
  }
}

// Sign out 
Future signOut() async {
    try {
      print("Signing out");
      return await _auth.signOut();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return null;
    }
  }


}



