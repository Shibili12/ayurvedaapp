import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage(
                  "assets/splash.jpg",
                ),
                fit: BoxFit.fitHeight,
                opacity: .3)),
        child: Center(
          child: Image.asset(
            "assets/assetbig.png",
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
