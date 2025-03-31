import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/calorie_controller.dart';

class CalorieTrackerScreen extends StatefulWidget {
const CalorieTrackerScreen({super.key});

@override
State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> with SingleTickerProviderStateMixin {
final CalorieController controller = Get.put(CalorieController());
final TextEditingController foodController = TextEditingController();
final TextEditingController caloriesController = TextEditingController();
final TextEditingController proteinController = TextEditingController();
final TextEditingController carbsController = TextEditingController();
final TextEditingController fatController = TextEditingController();

late TabController _tabController;
String selectedMealType = 'Breakfast';

final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
final List<Map<String, dynamic>> quickMeals = [
{
'name': 'Protein Shake',
'calories': 180,
'protein': 25,
'carbs': 10,
'fat': 3
},
{
'name': 'Chicken Salad',
'calories': 350,
'protein': 30,
'carbs': 15,
'fat': 18
},
{
'name': 'Oatmeal with Berries',
'calories': 280,
'protein': 8,
'carbs': 45,
'fat': 6
},
{
'name': 'Greek Yogurt',
'calories': 150,
'protein': 15,
'carbs': 8,
'fat': 5
},
];

@override
void initState() {
super.initState();
_tabController = TabController(length: 2, vsync: this);
}

@override
void dispose() {
_tabController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
appBar: AppBar(
title: const Text("Calorie Tracker", style: TextStyle(color: Colors.white)),
backgroundColor: Colors.green,
bottom: TabBar(
controller: _tabController,
labelColor: Colors.white,
unselectedLabelColor: Colors.white70,
tabs: const [
Tab(text: "Log Food"),
Tab(text: "Summary"),
],
),
),
body: TabBarView(
controller: _tabController,
children: [
_buildFoodLogTab(),
_buildSummaryTab(),
],
),
);
}

Widget _buildFoodLogTab() {
return SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildDailyGoalCard(),
const SizedBox(height: 16),
const Text("Add New Food", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
_buildMealTypeSelector(),
const SizedBox(height: 10),
TextField(
controller: foodController,
decoration: const InputDecoration(
labelText: "Food Item",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.food_bank),
),
),
const SizedBox(height: 10),
Row(
children: [
Expanded(
child: TextField(
controller: caloriesController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Calories",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.local_fire_department),
),
),
),
],
),
const SizedBox(height: 10),
Row(
children: [
Expanded(
child: TextField(
controller: proteinController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Protein (g)",
border: OutlineInputBorder(),
),
),
),
const SizedBox(width: 10),
Expanded(
child: TextField(
controller: carbsController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Carbs (g)",
border: OutlineInputBorder(),
),
),
),
const SizedBox(width: 10),
Expanded(
child: TextField(
controller: fatController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Fat (g)",
border: OutlineInputBorder(),
),
),
),
],
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: _addMeal,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
minimumSize: const Size(double.infinity, 50),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
child: const Text("Add Food", style: TextStyle(fontSize: 16)),
),
const SizedBox(height: 20),
const Text("Quick Add Favorites", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
_buildQuickMealGrid(),
const SizedBox(height: 20),
const Text("Today's Log", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
_buildTodaysMealsList(),
],
),
),
);
}

Widget _buildMealTypeSelector() {
return SizedBox(
height: 40,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: mealTypes.length,
itemBuilder: (context, index) {
return Padding(
padding: const EdgeInsets.only(right: 8.0),
child: ChoiceChip(
label: Text(mealTypes[index]),
selected: selectedMealType == mealTypes[index],
onSelected: (selected) {
setState(() {
selectedMealType = mealTypes[index];
});
},
selectedColor: Colors.green,
labelStyle: TextStyle(
color: selectedMealType == mealTypes[index] ? Colors.white : Colors.black,
),
),
);
},
),
);
}

Widget _buildQuickMealGrid() {
return GridView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
childAspectRatio: 1.5,
crossAxisSpacing: 10,
mainAxisSpacing: 10,
),
itemCount: quickMeals.length,
itemBuilder: (context, index) {
final meal = quickMeals[index];
return InkWell(
onTap: () => _quickAddMeal(meal),
child: Card(
elevation: 2,
child: Padding(
padding: const EdgeInsets.all(8.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
meal['name'],
style: const TextStyle(fontWeight: FontWeight.bold),
textAlign: TextAlign.center,
),
const SizedBox(height: 4),
Text(
"${meal['calories']} cal",
style: const TextStyle(color: Colors.grey),
),
const SizedBox(height: 4),
Text(
"P: ${meal['protein']}g • C: ${meal['carbs']}g • F: ${meal['fat']}g",
style: const TextStyle(fontSize: 12),
),
],
),
),
),
);
},
);
}

void _quickAddMeal(Map<String, dynamic> meal) {
controller.addMeal(
meal['name'],
meal['calories'],
selectedMealType,
meal['protein'],
meal['carbs'],
meal['fat'],
);

Get.snackbar(
"Added",
"${meal['name']} added to $selectedMealType",
snackPosition: SnackPosition.BOTTOM,
backgroundColor: Colors.green,
colorText: Colors.white,
);
}

void _addMeal() {
final food = foodController.text.trim();
final calories = int.tryParse(caloriesController.text.trim()) ?? 0;
final protein = int.tryParse(proteinController.text.trim()) ?? 0;
final carbs = int.tryParse(carbsController.text.trim()) ?? 0;
final fat = int.tryParse(fatController.text.trim()) ?? 0;

if (food.isNotEmpty && calories > 0) {
controller.addMeal(food, calories, selectedMealType, protein, carbs, fat);

foodController.clear();
caloriesController.clear();
proteinController.clear();
carbsController.clear();
fatController.clear();
} else {
Get.snackbar(
"Error",
"Please enter food name and calories",
snackPosition: SnackPosition.BOTTOM,
backgroundColor: Colors.red,
colorText: Colors.white,
);
}
}

Widget _buildDailyGoalCard() {
return Obx(() {
final calorieGoal = controller.calorieGoal.value;
final consumedCalories = controller.totalCalories.value;
final remaining = calorieGoal - consumedCalories;
final progressPercent = calorieGoal > 0 ? (consumedCalories / calorieGoal) * 100 : 0.0;

return Card(
elevation: 3,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
"Daily Goal",
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
InkWell(
onTap: _showGoalDialog,
child: Row(
children: [
Text(
"${controller.calorieGoal} cal",
style: const TextStyle(fontWeight: FontWeight.bold),
),
const Icon(Icons.edit, size: 16),
],
),
),
],
),
const SizedBox(height: 12),
// Simple progress bar
Container(
width: double.infinity,
height: 15,
decoration: BoxDecoration(
color: Colors.green.withOpacity(0.2),
borderRadius: BorderRadius.circular(8),
),
child: FractionallySizedBox(
alignment: Alignment.centerLeft,
widthFactor: (progressPercent / 100).clamp(0.0, 1.0),
child: Container(
decoration: BoxDecoration(
color: progressPercent > 100 ? Colors.red : Colors.green,
borderRadius: BorderRadius.circular(8),
),
),
),
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildNutritionStat("Consumed", consumedCalories, Colors.green),
_buildNutritionStat("Remaining", remaining, remaining < 0 ? Colors.red : Colors.blue),
],
),
],
),
),
);
});
}

Widget _buildNutritionStat(String label, int value, Color color) {
return Column(
children: [
Text(
label,
style: const TextStyle(fontSize: 14, color: Colors.grey),
),
Text(
"$value",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: color,
),
),
Text(
"cal",
style: TextStyle(fontSize: 14, color: color),
),
],
);
}

void _showGoalDialog() {
final TextEditingController goalController = TextEditingController(
text: controller.calorieGoal.toString(),
);

Get.dialog(
AlertDialog(
title: const Text("Set Calorie Goal"),
content: TextField(
controller: goalController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Daily Calorie Goal",
border: OutlineInputBorder(),
),
),
actions: [
TextButton(
onPressed: () => Get.back(),
child: const Text("Cancel"),
),
ElevatedButton(
onPressed: () {
final goal = int.tryParse(goalController.text.trim());
if (goal != null && goal > 0) {
controller.setCalorieGoal(goal);
Get.back();
}
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
),
child: const Text("Save"),
),
],
),
);
}

Widget _buildTodaysMealsList() {
return Obx(() {
final meals = controller.meals;
if (meals.isEmpty) {
return const Center(
child: Text(
"No meals logged today",
style: TextStyle(color: Colors.grey),
),
);
}

final mealsByType = _groupMealsByType(meals);
return ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: mealTypes.length,
itemBuilder: (context, index) {
final type = mealTypes[index];
final typeMeals = mealsByType[type] ?? [];

if (typeMeals.isEmpty) {
return const SizedBox.shrink();
}

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Padding(
padding: const EdgeInsets.symmetric(vertical: 8.0),
child: Text(
type,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: typeMeals.length,
itemBuilder: (context, mealIndex) {
final meal = typeMeals[mealIndex];
return Card(
margin: const EdgeInsets.only(bottom: 8),
child: ListTile(
title: Text(meal['food']),
subtitle: Text(
"P: ${meal['protein']}g • C: ${meal['carbs']}g • F: ${meal['fat']}g",
),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
Text(
"${meal['calories']} cal",
style: const TextStyle(fontWeight: FontWeight.bold),
),
IconButton(
icon: const Icon(Icons.delete, color: Colors.red),
onPressed: () => controller.deleteMeal(meal['index']),
),
],
),
),
);
},
),
],
);
},
);
});
}

Map<String, List<Map<String, dynamic>>> _groupMealsByType(List<Map<String, dynamic>> meals) {
final result = <String, List<Map<String, dynamic>>>{};

for (var i = 0; i < meals.length; i++) {
final meal = meals[i];
final type = meal['mealType'] ?? 'Other';

if (!result.containsKey(type)) {
result[type] = [];
}

final mealWithIndex = Map<String, dynamic>.from(meal);
mealWithIndex['index'] = i;
result[type]!.add(mealWithIndex);
}

return result;
}

Widget _buildSummaryTab() {
return SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildDailyGoalCard(),
const SizedBox(height: 20),
_buildMacronutrientSummary(),
const SizedBox(height: 20),
_buildMealTypeSummary(),
],
),
),
);
}

Widget _buildMacronutrientSummary() {
return Obx(() {
final protein = controller.totalProtein.value;
final carbs = controller.totalCarbs.value;
final fat = controller.totalFat.value;
final total = protein + carbs + fat;

final proteinPercent = total > 0 ? protein / total : 0.0;
final carbsPercent = total > 0 ? carbs / total : 0.0;
final fatPercent = total > 0 ? fat / total : 0.0;

return Card(
elevation: 3,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"Macronutrient Distribution",
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
const SizedBox(height: 16),
// Simple macro distribution bar
Container(
height: 24,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(12),
),
child: Row(
children: [
Expanded(
flex: (proteinPercent * 100).round(),
child: Container(
decoration: BoxDecoration(
color: Colors.red.shade300,
borderRadius: BorderRadius.horizontal(
left: const Radius.circular(12),
right: (carbsPercent == 0 && fatPercent == 0)
? const Radius.circular(12)
: Radius.zero,
),
),
),
),
Expanded(
flex: (carbsPercent * 100).round(),
child: Container(
decoration: BoxDecoration(
color: Colors.blue.shade300,
borderRadius: BorderRadius.horizontal(
left: proteinPercent == 0 ? const Radius.circular(12) : Radius.zero,
right: fatPercent == 0 ? const Radius.circular(12) : Radius.zero,
),
),
),
),
Expanded(
flex: (fatPercent * 100).round(),
child: Container(
decoration: BoxDecoration(
color: Colors.yellow.shade300,
borderRadius: BorderRadius.horizontal(
left: (proteinPercent == 0 && carbsPercent == 0)
? const Radius.circular(12)
: Radius.zero,
right: const Radius.circular(12),
),
),
),
),
],
),
),
const SizedBox(height: 12),
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildMacroStat("Protein", protein, proteinPercent, Colors.red.shade300),
_buildMacroStat("Carbs", carbs, carbsPercent, Colors.blue.shade300),
_buildMacroStat("Fat", fat, fatPercent, Colors.yellow.shade300),
],
),
const SizedBox(height: 8),
const Divider(),
const SizedBox(height: 8),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text("Total Calories from Macros"),
Text(
"${(protein * 4) + (carbs * 4) + (fat * 9)} cal",
style: const TextStyle(fontWeight: FontWeight.bold),
),
],
),
],
),
),
);
});
}

Widget _buildMacroStat(String label, int value, double percent, Color color) {
return Column(
children: [
Container(
width: 12,
height: 12,
decoration: BoxDecoration(
color: color,
shape: BoxShape.circle,
),
),
const SizedBox(height: 4),
Text(
label,
style: const TextStyle(fontSize: 14),
),
Text(
"$value g",
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
Text(
"${(percent * 100).round()}%",
style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
),
],
);
}

Widget _buildMealTypeSummary() {
return Obx(() {
final meals = controller.meals;
final mealsByType = _groupMealsByType(meals);

return Card(
elevation: 3,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"Calories by Meal",
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
const SizedBox(height: 16),
ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: mealTypes.length,
itemBuilder: (context, index) {
final type = mealTypes[index];
final typeMeals = mealsByType[type] ?? [];

final caloriesForType = typeMeals.fold<int>(
0,
(sum, meal) => sum + (meal['calories'] as int),
);

final macrosForType = typeMeals.fold<Map<String, int>>(
{'protein': 0, 'carbs': 0, 'fat': 0},
(result, meal) {
result['protein'] = (result['protein'] ?? 0) + (meal['protein'] as int);
result['carbs'] = (result['carbs'] ?? 0) + (meal['carbs'] as int);
result['fat'] = (result['fat'] ?? 0) + (meal['fat'] as int);
return result;
},
);

return Column(
children: [
if (index > 0) const Divider(),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
type,
style: const TextStyle(fontWeight: FontWeight.bold),
),
Text(
"$caloriesForType cal",
style: const TextStyle(fontWeight: FontWeight.bold),
),
],
),
const SizedBox(height: 4),
if (typeMeals.isNotEmpty)
Text(
"P: ${macrosForType['protein']}g • C: ${macrosForType['carbs']}g • F: ${macrosForType['fat']}g",
style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
),
if (typeMeals.isEmpty)
Text(
"No meals logged",
style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
),
const SizedBox(height: 8),
],
);
},
),
],
),
),
);
});
}
}
