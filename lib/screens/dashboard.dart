import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controller/calorie_controller.dart';
import '../controller/workout_controller.dart';
import 'calorie_tracker.dart';
import 'preset_routines.dart';
import 'progress_chart.dart';
import 'workout_history.dart';
import 'workout_log.dart';

class DashboardScreen extends StatefulWidget {
const DashboardScreen({super.key});

@override
_DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
final WorkoutController workoutController = Get.put(WorkoutController());
final CalorieController calorieController = Get.put(CalorieController());

final RxInt _workoutCount = 0.obs;
final RxInt _totalCaloriesBurned = 0.obs;
final RxInt _totalWorkoutDuration = 0.obs;
final RxInt _consumedCalories = 0.obs;
final RxInt _calorieGoal = 2000.obs;

@override
void initState() {
super.initState();

ever(workoutController.workoutList, (_) {
_calculateWorkoutStats();
});

ever(calorieController.totalCalories, (_) {
_calculateCalorieStats();
});

ever(calorieController.calorieGoal, (_) {
_calculateCalorieStats();
});

_calculateWorkoutStats();
_calculateCalorieStats();
}

void _calculateWorkoutStats() {
final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);

final todaysWorkouts = workoutController.workoutList.where((workout) {
try {
final workoutDate = DateTime.parse(workout['date']);
final workoutDateOnly = DateTime(workoutDate.year, workoutDate.month, workoutDate.day);
return workoutDateOnly.isAtSameMomentAs(today);
} catch (e) {
return false;
}
}).toList();

_workoutCount.value = todaysWorkouts.length;

_totalCaloriesBurned.value = todaysWorkouts.fold<int>(0, (sum, workout) {
final calories = workout['calories'] ?? '0';
final caloriesInt = int.tryParse(calories.toString()) ?? 0;
return sum + caloriesInt;
});

_totalWorkoutDuration.value = todaysWorkouts.fold<int>(0, (sum, workout) {
final duration = workout['duration'] ?? '0';
final durationInt = int.tryParse(duration.toString()) ?? 0;
return sum + durationInt;
});
}

void _calculateCalorieStats() {
_consumedCalories.value = calorieController.totalCalories.value;
_calorieGoal.value = calorieController.calorieGoal.value;
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey[100],
appBar: AppBar(
title: FutureBuilder<String>(
future: _loadUserName(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Text("Loading...", style: TextStyle(color: Colors.white));
} else if (snapshot.hasError) {
return const Text("Error", style: TextStyle(color: Colors.white));
} else if (snapshot.hasData) {
return Text("Hi, ${snapshot.data}!", style: const TextStyle(color: Colors.white));
} else {
return const Text("Hello, User!", style: TextStyle(color: Colors.white));
}
},
),
backgroundColor: Colors.green,
actions: [
IconButton(
icon: const Icon(Icons.logout, color: Colors.white),
onPressed: _logout,
),
],
),
body: RefreshIndicator(
onRefresh: () async {
workoutController.loadWorkouts();
},
child: SingleChildScrollView(
physics: const AlwaysScrollableScrollPhysics(),
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Obx(() => _buildTodaySummaryCard()),
const SizedBox(height: 20),
Obx(() => _buildCalorieProgressCard()),
const SizedBox(height: 20),
const Text(
"Quick Access",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
GridView.count(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
crossAxisCount: 2,
crossAxisSpacing: 10,
mainAxisSpacing: 10,
children: [
_buildFeatureCard("Log Workout", Icons.fitness_center, Colors.blue, () {
Get.to(() => const WorkoutLogScreen());
}),
_buildFeatureCard("Track Calories", Icons.fastfood, Colors.orange, () {
Get.to(() => const CalorieTrackerScreen());
}),
_buildFeatureCard("Workout Routines", Icons.list, Colors.purple, () {
Get.to(() => const PresetRoutinesScreen());
}),
_buildFeatureCard("Progress Charts", Icons.bar_chart, Colors.teal, () {
Get.to(() => const ProgressChartsScreen());
}),
_buildFeatureCard("Workout History", Icons.history, Colors.brown, () {
Get.to(() => WorkoutHistoryScreen());
}),
],
),
],
),
),
),
);
}

Widget _buildTodaySummaryCard() {
DateTime now = DateTime.now();
String todayDate = "${now.day} ${_getMonthName(now.month)} ${now.year}";

return Card(
elevation: 3,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
"Today's Summary",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
Text(
todayDate,
style: TextStyle(
color: Colors.grey[600],
),
),
],
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildStatusItem(
"Workouts",
"${_workoutCount.value}",
Icons.fitness_center,
Colors.blue,
),
_buildStatusItem(
"Calories",
"${_totalCaloriesBurned.value}",
Icons.local_fire_department,
Colors.orange,
),
_buildStatusItem(
"Active Time",
"${_totalWorkoutDuration.value} mins",
Icons.timer,
Colors.green,
),
],
),
],
),
),
);
}

Widget _buildCalorieProgressCard() {
final remaining = _calorieGoal.value - _consumedCalories.value;
final progressValue = _calorieGoal.value > 0
? (_consumedCalories.value / _calorieGoal.value).clamp(0.0, 1.0)
: 0.0;

return Card(
elevation: 3,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
"Calorie Goal",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
Text(
"${_consumedCalories.value} / ${_calorieGoal.value} kcal",
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
],
),
const SizedBox(height: 12),
LinearProgressIndicator(
value: progressValue,
backgroundColor: Colors.grey[300],
color: progressValue >= 1 ? Colors.red : Colors.green,
minHeight: 10,
borderRadius: BorderRadius.circular(5),
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
"Remaining: $remaining kcal",
style: TextStyle(
color: remaining < 0 ? Colors.red : Colors.grey[600],
),
),
ElevatedButton.icon(
onPressed: () {
Get.to(() => const CalorieTrackerScreen());
},
icon: const Icon(Icons.add, size: 18),
label: const Text("Add Food"),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
),
),
],
),
],
),
),
);
}

Widget _buildStatusItem(String label, String value, IconData icon, Color color) {
return Column(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
shape: BoxShape.circle,
),
child: Icon(
icon,
color: color,
size: 24,
),
),
const SizedBox(height: 8),
Text(
value,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
Text(
label,
style: TextStyle(
color: Colors.grey[600],
fontSize: 12,
),
),
],
);
}

Widget _buildFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
return InkWell(
onTap: onTap,
child: Card(
elevation: 2,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
shape: BoxShape.circle,
),
child: Icon(
icon,
color: color,
size: 28,
),
),
const SizedBox(height: 12),
Text(
title,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 14,
),
textAlign: TextAlign.center,
),
],
),
),
),
);
}

Future<String> _loadUserName() async {
try {
var userBox = await Hive.openBox('userBox');
String username = userBox.get('username', defaultValue: "User");
return username;
} catch (e) {
return "User";
}
}

void _logout() async {
var userBox = Hive.box('userBox');
await userBox.delete('loggedInUser');
Get.offAllNamed('/login');
}

String _getMonthName(int month) {
const months = [
"Jan", "Feb", "Mar", "Apr", "May", "Jun",
"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];
return months[month - 1];
}
}