import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Icon(
              Icons.camera_alt_outlined,
              color: Colors.green,
              size: 76,
            ),
            Text("Welcome to Food Tracker"),
            Text("Track your meals effortlessly, Snap a photo, and we will handle the rest."),
            ElevatedButton(
                onPressed: (){},
                child: Text("Continue with Google"),
            ),
            ElevatedButton(
                onPressed: (){},
                child: Text("Continue with Apple"),
            ),
            Spacer(),
            Text("By continuing, you agree to our Terms of Service and Privacy Policy"),
          ],
        ),
      )
    );
  }
}
