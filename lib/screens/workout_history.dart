import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/workout_controller.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  final WorkoutController controller = Get.find<WorkoutController>();

  WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Workout History"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'date') {
                controller.sortByDate();
              } else if (value == 'duration') {
                controller.sortByDuration();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'date', child: Text('Sort by Date')),
              const PopupMenuItem(value: 'duration', child: Text('Sort by Duration')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => DropdownButton<String>(
                  value: controller.selectedWorkoutType.value,
                  hint: const Text("Filter by Workout Type"),
                  isExpanded: true,
                  items: controller.workoutTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedWorkoutType.value = value;
                      controller.applyFilter();
                    }
                  },
                )),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredWorkouts.isEmpty) {
                return const Center(child: Text("No workouts found."));
              }

              return ListView.builder(
                itemCount: controller.filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = controller.filteredWorkouts[index];
                  final itemKey = Key('workout_$index${workout['date']}');
                  
                  return Dismissible(
                    key: itemKey,
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      controller.workoutList.removeAt(index);
                      controller.applyFilter();
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.fitness_center, color: Colors.green),
                        title: Text(workout['type'] ?? 'Unknown Type'),
                        subtitle: Text(
                            "${workout['duration']} min • ${workout['calories']} cal"),
                        trailing: Text(
                          workout['date'].toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}