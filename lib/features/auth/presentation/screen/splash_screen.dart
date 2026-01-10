import 'package:flutter/material.dart';

import '../../../common/presentation/screens/main_bottom_nav_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
          (predicate) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_rounded, size: 84, color: Colors.orange,),
            Text(
              "Calculate your everyday calory consumption",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
