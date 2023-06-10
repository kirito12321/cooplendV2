import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
  
}

class _EmailVerificationState extends State<EmailVerification> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:  [
           const Text('Please verify your email.'),
           TextButton(onPressed: () async {
             final user = FirebaseAuth.instance.currentUser;
             user?.sendEmailVerification();
           },child: const Text('Send email verification'),),
           TextButton(onPressed: () {
             Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
           }, child: const Text('Back'))
          ],
        ), 
    );
  }
}