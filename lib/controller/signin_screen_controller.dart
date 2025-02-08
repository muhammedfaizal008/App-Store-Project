import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninScreenController with ChangeNotifier {
  Future<void> onSignIn(
    BuildContext context, {
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (credential.user != null) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User registration successful!"),
            backgroundColor: Colors.green,
          ),
        );

      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
