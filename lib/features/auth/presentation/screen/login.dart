import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../application/app_colors.dart';

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
              color: AppColors.themeColor,
              size: 76,
            ),
            SizedBox(height: 20,),
            Text("Welcome to Food Tracker",
              textAlign: TextAlign.center,
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36
            ),),
            Text("Track your meals effortlessly, Snap a photo, and we will handle the rest.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text("Continue with Google", style: TextStyle(fontSize: 18),),
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white
                  ),
                  child: Text("Continue with Apple", style: TextStyle(fontSize: 18)),
              ),
            ),
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black87
                ),
                children: [
                  TextSpan(text: "By continuing, you agree to our"),
                  TextSpan(
                      text: " Terms of Service",
                      style: TextStyle(color: AppColors.themeColor, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap,
                  ),
                  TextSpan(text: " and"),
                  TextSpan(
                      text: " Privacy Policy",
                      style: TextStyle(color: AppColors.themeColor, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap,
                  ),
                ]
              ),
            ),
          ],
        ),
      )
    );
  }
}
