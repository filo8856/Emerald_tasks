import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  void handleGoogleSignIn(){
    // Connect to Firebase Auth here
    print("Google Sign-in clicked");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            //App title or logo
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Sign In to Continue",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            // Google Sign-In button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: handleGoogleSignIn, 
                  icon: Image.network(
                    "https://developers.google.com/identity/images/g-logo.png",
                    height: 24,
                  ),
                  label: const Text(
                    "Sign-In with Google",
                    style: TextStyle(fontSize: 16),
                  )
                )
              ),
            )
          ],
        )
      ),
    );
  }
}