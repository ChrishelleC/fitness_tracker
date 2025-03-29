import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';

class WelcomeScreen extends StatefulWidget {
const WelcomeScreen({super.key});

@override
_WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();


bool _isValidEmail(String email) {
String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
RegExp regExp = RegExp(pattern);
return regExp.hasMatch(email);
}

void _login() async {
final name = _nameController.text.trim();
final email = _emailController.text.trim();

if (name.isNotEmpty && email.isNotEmpty) {
if (!_isValidEmail(email)) {
Get.snackbar(
"Invalid Email",
"Please enter a valid email address.",
snackPosition: SnackPosition.BOTTOM,
backgroundColor: Colors.red,
colorText: Colors.white,
);
return;

}

var userBox = await Hive.openBox('userBox');

await userBox.put('username', name);
await userBox.put('email', email);
await userBox.put('loggedInUser', email);



var workoutBox = await Hive.openBox('workoutBox');
var calorieBox = await Hive.openBox('calorieBox');



if (workoutBox.get(email) == null) {
await workoutBox.put(email, 0);

}

if (calorieBox.get(email) == null) {
await calorieBox.put(email, 0);
}


Get.off(() => DashboardScreen());
} else {
Get.snackbar(
"Missing Fields",
"Please fill in all the fields.",
snackPosition: SnackPosition.BOTTOM,
backgroundColor: Colors.green,
colorText: Colors.white,
);
}
}

InputDecoration _inputDecoration(String label, IconData icon) {
return InputDecoration(
labelText: label,
prefixIcon: Icon(icon, color: Colors.green),
border: const OutlineInputBorder(),
focusedBorder: const OutlineInputBorder(
borderSide: BorderSide(color: Colors.green),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
body: Center(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 24.0),
child: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
"Welcome to Fitness Tracker!",
style: TextStyle(
fontSize: 26,
fontWeight: FontWeight.bold,
color: Colors.green,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 40),

TextField(
controller: _nameController,
decoration: _inputDecoration("Name", Icons.person),
),
const SizedBox(height: 20),

TextField(
controller: _emailController,
decoration: _inputDecoration("Email", Icons.email),
keyboardType: TextInputType.emailAddress,
),
const SizedBox(height: 30),

SizedBox(
width: double.infinity,
height: 50,
child: ElevatedButton(
onPressed: _login,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
child: const Text(
"Login",
style: TextStyle(fontSize: 18, color: Colors.white),
),
),
),
],
),
),
),
),
);
}
}
