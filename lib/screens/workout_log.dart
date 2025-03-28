import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/workout_controller.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final WorkoutController controller = Get.put(WorkoutController());

  final TextEditingController exerciseController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  final RxString selectedType = 'Strength'.obs;
  final RxString selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  
  final List<Map<String, dynamic>> quickExercises = [
    {'name': 'Bench Press', 'type': 'Strength', 'muscle': 'Chest'},
    {'name': 'Squat', 'type': 'Strength', 'muscle': 'Legs'},
    {'name': 'Deadlift', 'type': 'Strength', 'muscle': 'Back'},
    {'name': 'Pull-ups', 'type': 'Strength', 'muscle': 'Back'},
    {'name': 'Push-ups', 'type': 'Strength', 'muscle': 'Chest'},
    {'name': 'Lat Pulldown', 'type': 'Strength', 'muscle': 'Back'},
    {'name': 'Shoulder Press', 'type': 'Strength', 'muscle': 'Shoulders'},
    {'name': 'Leg Press', 'type': 'Strength', 'muscle': 'Legs'},
    {'name': 'Bicep Curls', 'type': 'Strength', 'muscle': 'Arms'},
    {'name': 'Tricep Extensions', 'type': 'Strength', 'muscle': 'Arms'},
    {'name': 'Running', 'type': 'Cardio', 'muscle': 'Full Body'},
    {'name': 'Cycling', 'type': 'Cardio', 'muscle': 'Legs'},
    {'name': 'Jump Rope', 'type': 'Cardio', 'muscle': 'Full Body'},
    {'name': 'Yoga', 'type': 'Flexibility', 'muscle': 'Full Body'},
    {'name': 'Plank', 'type': 'Strength', 'muscle': 'Core'},
  ];

  List<Map<String, dynamic>> get filteredExercises {
    return quickExercises.where((exercise) => exercise['type'] == selectedType.value).toList();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(selectedDate.value),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _submitWorkout() {
    if (exerciseController.text.isEmpty ||
        repsController.text.isEmpty ||
        setsController.text.isEmpty ||
        weightController.text.isEmpty ||
        durationController.text.isEmpty ||
        caloriesController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    controller.addWorkout({
      'exercise': exerciseController.text,
      'type': selectedType.value,
      'reps': repsController.text,
      'sets': setsController.text,
      'weight': weightController.text,
      'duration': durationController.text,
      'calories': caloriesController.text,
      'date': selectedDate.value,
    });

    exerciseController.clear();
    repsController.clear();
    setsController.clear();
    weightController.clear();
    durationController.clear();
    caloriesController.clear();

    Get.back();
    Get.snackbar('Success', 'Workout Logged');
  }

  void _quickAddExercise(String exerciseName) {
    exerciseController.text = exerciseName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Workout", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Add Exercise",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => Row(
              children: [
                for (final type in controller.workoutTypes.where((t) => t != 'All'))
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: selectedType.value == type,
                      onSelected: (selected) {
                        selectedType.value = type;
                      },
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                        color: selectedType.value == type ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return Card(
                    margin: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => _quickAddExercise(exercise['name']),
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconForMuscle(exercise['muscle']),
                              size: 32,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exercise['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              exercise['muscle'],
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
            const Divider(height: 32),
            _buildTextField(exerciseController, 'Exercise Name', Icons.fitness_center),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    setsController, 
                    'Sets', 
                    Icons.format_list_numbered,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    repsController, 
                    'Reps', 
                    Icons.repeat,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    weightController, 
                    'Weight (lbs)', 
                    Icons.fitness_center,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    durationController, 
                    'Duration (min)', 
                    Icons.timer,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              caloriesController, 
              'Calories Burned', 
              Icons.local_fire_department,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Text("Date: ${selectedDate.value}"),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Change Date"),
                ),
              ],
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("LOG WORKOUT", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text}
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
  
  IconData _getIconForMuscle(String muscle) {
    switch (muscle) {
      case 'Chest':
        return Icons.accessibility_new;
      case 'Back':
        return Icons.airline_seat_flat;
      case 'Legs':
        return Icons.directions_walk;
      case 'Shoulders':
        return Icons.person;
      case 'Arms':
        return Icons.sports_martial_arts;
      case 'Core':
        return Icons.circle;
      case 'Full Body':
        return Icons.accessibility;
      default:
        return Icons.fitness_center;
    }
  }
}