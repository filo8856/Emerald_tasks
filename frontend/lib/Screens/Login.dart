// import 'package:emerald_tasks/Screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../Auth.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _Login();
// }

// class _LoginState extends State<Login> {

//   void handleGoogleSignIn() async {
//     final user = await AuthService().signInWithGoogle();

//     if (user != null) {
//       print("Logged in as: ${user.email}");

//       // Navigate to Home screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Home()),
//       );
//     } else {
//       print("Google Sign-In cancelled");
//     }
//   }
// }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const Spacer(),

//             //App title or logo
//             const Text(
//               "Welcome",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 10),

//             const Text(
//               "Sign In to Continue",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),

//             const Spacer(),

//             // Google Sign-In button at the bottom
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   onPressed: handleGoogleSignIn, 
//                   icon: Image.network(
//                     "https://developers.google.com/identity/images/g-logo.png",
//                     height: 24,
//                   ),
//                   label: const Text(
//                     "Sign-In with Google",
//                     style: TextStyle(fontSize: 16),
//                   )
//                 )
//               ),
//             )
//           ],
//         )
//       ),
//     );
//   }
// }


import 'package:emerald_tasks/Screens/chat.dart/task_input.dart';
import 'package:emerald_tasks/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  void handleGoogleSignIn() async {
    final user = await AuthService().signInWithGoogle();

    if (user != null) {
      print("Logged in as: ${user.email}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskInputScreen()),
      );
    } else {
      print("Google Sign-In cancelled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

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
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
