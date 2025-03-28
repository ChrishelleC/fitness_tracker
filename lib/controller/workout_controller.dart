import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WorkoutController extends GetxController {
  var workoutList = <Map<String, dynamic>>[].obs;
  List<String> workoutTypes = ['Strength', 'Cardio', 'Flexibility', 'All'];
  late Box workoutBox;
  var selectedWorkoutType = 'All'.obs;
  var filteredWorkouts = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get workouts => workoutList;

  @override
  void onInit() {
    super.onInit();
    _initializeStorage().then((_) {
      loadWorkouts();
      Get.put(this, permanent: true);
    });
  }

  Future<void> _initializeStorage() async {
    try {
      workoutBox = await Hive.openBox('workoutBox');
    } catch (e) {}
  }

  void addWorkout(Map<String, dynamic> workout) {
    final newWorkout = {
      'date': workout['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      'duration': workout['duration'] ?? '0',
      'type': workout['type'] ?? 'Strength',
      'calories': workout['calories'] ?? '0',
    };
    workoutList.add(newWorkout);
    _saveWorkouts();
    applyFilter();
  }

  void loadWorkouts() {
    try {
      final savedWorkouts = workoutBox.get('workouts', defaultValue: []);
      
      if (savedWorkouts is List) {
        List<Map<String, dynamic>> validWorkouts = [];
        
        for (var item in savedWorkouts) {
          if (item is Map) {
            Map<String, dynamic> workout = {};
            
            item.forEach((key, value) {
              if (key is String) {
                workout[key] = value;
              }
            });
            
            if (!workout.containsKey('date')) {
              workout['date'] = DateTime.now().toIso8601String().split('T')[0];
            }
            if (!workout.containsKey('duration')) {
              workout['duration'] = '0';
            }
            if (!workout.containsKey('type')) {
              workout['type'] = 'Strength';
            }
            if (!workout.containsKey('calories')) {
              workout['calories'] = '0';
            }
            
            validWorkouts.add(workout);
          }
        }
        
        workoutList.assignAll(validWorkouts);
      } else {
        workoutList.clear();
      }
      
      if (workoutList.isNotEmpty) {
        _saveWorkouts();
      }
      
      applyFilter();
    } catch (e) {
      workoutList.clear();
    }
  }

  void _saveWorkouts() {
    try {
      final List<Map<String, dynamic>> serializableList = workoutList.map((workout) {
        return Map<String, dynamic>.from(workout);
      }).toList();
      
      workoutBox.put('workouts', serializableList);
    } catch (e) {}
  }

  void sortByDate() {
    workoutList.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return dateA.compareTo(dateB);
    });
    _saveWorkouts();
    applyFilter();
  }

  void sortByDuration() {
    workoutList.sort((a, b) {
      final durationA = int.parse(a['duration']);
      final durationB = int.parse(b['duration']);
      return durationA.compareTo(durationB);
    });
    _saveWorkouts();
    applyFilter();
  }

  void applyFilter() {
    if (selectedWorkoutType.value == 'All') {
      filteredWorkouts.assignAll(workoutList);
    } else {
      filteredWorkouts.assignAll(
        workoutList.where((workout) => workout['type'] == selectedWorkoutType.value).toList(),
      );
    }
  }

  @override
  void onClose() {
    _saveWorkouts();
    workoutBox.close();
    super.onClose();
  }
}