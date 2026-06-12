import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. registerWithEmail() - creates account, sets display name, and writes to Firestore
  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    // 1. Create Firebase Auth account
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Save display name to Firebase Auth profile
    await credential.user!.updateDisplayName(name);

    // 3. Save all profile fields to Firestore
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 4. Sign out immediately so the user has to log in manually
    await _auth.signOut();

    return credential;
  }

  // 2. signInWithEmail() - signs in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 3. signOut() - signs the current user out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
