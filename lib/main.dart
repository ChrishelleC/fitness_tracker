import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/dashboard.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter.
  await Hive.initFlutter();

  // Open all necessary boxes.
  await Hive.openBox('userBox');
  await Hive.openBox('calorieBox');
  await Hive.openBox('workoutBox');

  // Access the userBox to determine which screen to show.
  var userBox = Hive.box('userBox');
  String? loggedInUser = userBox.get('loggedInUser');

  runApp(
    MyApp(
      startScreen: (loggedInUser?.isNotEmpty == true)
          ? DashboardScreen()
          : WelcomeScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracking',
      home: startScreen,
    );
  }
}