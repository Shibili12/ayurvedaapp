import 'package:ayurvedaapp/core/network/api_service.dart';
import 'package:ayurvedaapp/providers/auth_provider.dart';
import 'package:ayurvedaapp/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(api: ApiService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
