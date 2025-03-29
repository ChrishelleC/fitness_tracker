import 'package:get/get.dart';
import 'package:hive/hive.dart';

class CalorieController extends GetxController {
var meals = <Map<String, dynamic>>[].obs;
var totalCalories = 0.obs;
var totalProtein = 0.obs;
var totalCarbs = 0.obs;
var totalFat = 0.obs;
var calorieGoal = 2000.obs;

late Box calorieBox;

@override
void onInit() {
super.onInit();
calorieBox = Hive.box('calorieBox');
loadStoredData();
}

void loadStoredData() {
final storedMeals = calorieBox.get('meals', defaultValue: []) as List<dynamic>;
meals.assignAll(
storedMeals.map((meal) => Map<String, dynamic>.from(meal as Map)).toList(),
);

calorieGoal.value = calorieBox.get('calorieGoal', defaultValue: 2000) as int;

_recalculateTotals();
}

void _saveData() {
calorieBox.put('meals', meals.toList());
calorieBox.put('calorieGoal', calorieGoal.value);
}

void addMeal(String food, int calories, String mealType, int protein, int carbs, int fat) {
meals.add({
'food': food,
'calories': calories,
'mealType': mealType,
'protein': protein,
'carbs': carbs,
'fat': fat,
'timestamp': DateTime.now().millisecondsSinceEpoch,
});

totalCalories.value += calories;
totalProtein.value += protein;
totalCarbs.value += carbs;
totalFat.value += fat;

_saveData();
}

void deleteMeal(int index) {
if (index >= 0 && index < meals.length) {
final removedMeal = meals[index];
meals.removeAt(index);

totalCalories.value -= removedMeal['calories'] as int;
totalProtein.value -= removedMeal['protein'] as int;
totalCarbs.value -= removedMeal['carbs'] as int;
totalFat.value -= removedMeal['fat'] as int;

_saveData();
}
}

void setCalorieGoal(int goal) {
calorieGoal.value = goal;
_saveData();
}

void _recalculateTotals() {
int calories = 0;
int protein = 0;
int carbs = 0;
int fat = 0;

for (var meal in meals) {
calories += meal['calories'] as int;
protein += meal['protein'] as int? ?? 0;
carbs += meal['carbs'] as int? ?? 0;
fat += meal['fat'] as int? ?? 0;
}

totalCalories.value = calories;
totalProtein.value = protein;
totalCarbs.value = carbs;
totalFat.value = fat;
}

List<Map<String, dynamic>> getMealsByType(String mealType) {
return meals.where((meal) => meal['mealType'] == mealType).toList();
}

Map<String, dynamic> getDailyNutrition() {
return {
'calories': totalCalories.value,
'protein': totalProtein.value,
'carbs': totalCarbs.value,
'fat': totalFat.value,
'calorieGoal': calorieGoal.value,
'remaining': calorieGoal.value - totalCalories.value,
};
}

int getCaloriesByMealType(String mealType) {
return meals
.where((meal) => meal['mealType'] == mealType)
.fold(0, (sum, meal) => sum + (meal['calories'] as int));
}

void clearDailyData() {
meals.clear();
totalCalories.value = 0;
totalProtein.value = 0;
totalCarbs.value = 0;
totalFat.value = 0;
_saveData();
}

bool isBelowCalorieGoal() {
return totalCalories.value <= calorieGoal.value;
}

double getProgressPercentage() {
if (calorieGoal.value <= 0) return 0.0;
return (totalCalories.value / calorieGoal.value).clamp(0.0, 2.0);
}
}