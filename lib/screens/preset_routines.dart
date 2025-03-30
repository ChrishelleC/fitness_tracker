import 'package:flutter/material.dart';

class PresetRoutinesScreen extends StatefulWidget {
  const PresetRoutinesScreen({super.key});

  @override
  State<PresetRoutinesScreen> createState() => _PresetRoutinesScreenState();
}

class _PresetRoutinesScreenState extends State<PresetRoutinesScreen> {
  String selectedDifficulty = 'All';
  String selectedRoutineType = 'All';

  final List<Map<String, dynamic>> routines = [
    // Beginner Routines
    {
      "title": "Beginner Day 1: Full Body",
      "description": "Complete full body workout for beginners focusing on building strength foundations.",
      "difficulty": "Beginner",
      "type": "Full Body",
      "duration": "45-60 min",
      "exercises": [
        {"name": "Barbell Back Squats", "reps": "3 sets of 5 reps"},
        {"name": "Flat Barbell Bench Press", "reps": "3 sets of 5 reps"},
        {"name": "Seated Cable Rows", "reps": "3 sets of 6-8 reps"},
        {"name": "Seated Dumbbell Shoulder Press", "reps": "3 sets of 6-8 reps"},
        {"name": "Cable Rope Triceps Pushdowns", "reps": "3 sets of 8-10 reps"},
        {"name": "Lateral Raises", "reps": "3 sets of 10-12 reps"},
        {"name": "Seated Calf Raises", "reps": "3 sets of 10-12 reps"},
        {"name": "Planks", "reps": "3 sets of 30-second holds"}
      ]
    },
    {
      "title": "Beginner Day 2: Full Body",
      "description": "Second full body workout for beginners focusing on compound movements.",
      "difficulty": "Beginner",
      "type": "Full Body",
      "duration": "45-60 min",
      "exercises": [
        {"name": "Barbell/Trap Bar Deadlifts", "reps": "3 sets of 5 reps"},
        {"name": "Pullups or Lat Pulldowns", "reps": "3 sets of 6-8 reps"},
        {"name": "Barbell/Dumbbell Incline Press", "reps": "3 sets of 6-8 reps"},
        {"name": "Machine Shoulder Press", "reps": "3 sets of 6-8 reps"},
        {"name": "Barbell/Dumbbell Biceps Curls", "reps": "3 sets of 8-10 reps"},
        {"name": "Reverse Machine Fly", "reps": "3 sets of 10-12 reps"},
        {"name": "Standing Calf Raises", "reps": "3 sets of 10-12 reps"}
      ]
    },
    {
      "title": "Beginner Day 3: Full Body",
      "description": "Final full body workout to complete beginner's weekly rotation.",
      "difficulty": "Beginner",
      "type": "Full Body",
      "duration": "45-60 min",
      "exercises": [
        {"name": "Leg Press", "reps": "3 sets of 5 reps"},
        {"name": "T-bar Rows", "reps": "3 sets of 6-8 reps"},
        {"name": "Machine/Dumbbell Chest Fly", "reps": "3 sets of 6-8 reps"},
        {"name": "One-arm Dumbbell Shoulder Press", "reps": "3 sets of 6-8 reps"},
        {"name": "Dumbbell/Machine Triceps Extensions", "reps": "3 sets of 8-10 reps"},
        {"name": "Cable/Dumbbell Front Raises", "reps": "3 sets of 10-12 reps"},
        {"name": "Seated Calf Raises", "reps": "3 sets of 10-12 reps"},
        {"name": "Decline Crunches", "reps": "3 sets of 10-12 reps"}
      ]
    },
    
    // Intermediate Routines
    {
      "title": "Intermediate Day 1: Upper Body",
      "description": "Upper body focused workout for intermediate lifters with emphasis on chest and back.",
      "difficulty": "Intermediate",
      "type": "Upper Body",
      "duration": "60-75 min",
      "exercises": [
        {"name": "Flat Barbell Bench Press", "reps": "4 sets of 6-8 reps"},
        {"name": "Bent-over Barbell Rows", "reps": "3 sets of 6-8 reps"},
        {"name": "Seated Dumbbell Press", "reps": "3 sets of 8-10 reps"},
        {"name": "Dips", "reps": "3 sets of 8-10 reps"},
        {"name": "Pullups or Lat Pulldowns", "reps": "3 sets of 8-10 reps"},
        {"name": "Lying Dumbbell Triceps Extensions", "reps": "3 sets of 10-12 reps"},
        {"name": "Incline Dumbbell Curls", "reps": "3 sets of 10-12 reps"}
      ]
    },
    {
      "title": "Intermediate Day 2: Lower Body",
      "description": "Leg-focused workout for intermediate lifters targeting all lower body muscles.",
      "difficulty": "Intermediate",
      "type": "Lower Body",
      "duration": "60-75 min",
      "exercises": [
        {"name": "Barbell Back Squats", "reps": "4 sets of 6-8 reps"},
        {"name": "Leg Press", "reps": "3 sets of 8-10 reps"},
        {"name": "Seated Leg Extensions", "reps": "3 sets of 10-12 reps"},
        {"name": "Dumbbell/Barbell Walking Lunges", "reps": "3 sets of 10-12 reps"},
        {"name": "Calf Press on Leg Press", "reps": "4 sets of 12-15 reps"},
        {"name": "Decline Crunches", "reps": "4 sets of 12-15 reps"}
      ]
    },
    {
      "title": "Intermediate Day 3: Upper Body",
      "description": "Second upper body day focusing on shoulders and arms for intermediate lifters.",
      "difficulty": "Intermediate",
      "type": "Upper Body",
      "duration": "60-75 min",
      "exercises": [
        {"name": "Overhead Press", "reps": "4 sets of 6-8 reps"},
        {"name": "Incline Dumbbell Bench Press", "reps": "3 sets of 8-10 reps"},
        {"name": "One-arm Cable Rows", "reps": "3 sets of 10-12 reps"},
        {"name": "Cable Lateral Raises", "reps": "3 sets of 10-12 reps"},
        {"name": "Face Pulls", "reps": "3 sets of 10-12 reps"},
        {"name": "Dumbbell Shrugs", "reps": "3 sets of 10-12 reps"},
        {"name": "Seated Overhead Triceps Extensions", "reps": "3 sets of 10-12 reps"},
        {"name": "Machine Preacher Curls", "reps": "3 sets of 12-15 reps"}
      ]
    },
    {
      "title": "Intermediate Day 4: Lower Body",
      "description": "Second lower body day focusing on posterior chain for intermediate lifters.",
      "difficulty": "Intermediate",
      "type": "Lower Body",
      "duration": "60-75 min",
      "exercises": [
        {"name": "Barbell Deadlift", "reps": "4 sets of 6 reps"},
        {"name": "Barbell Hip Thrusts", "reps": "3 sets of 8-10 reps"},
        {"name": "Dumbbell Romanian Deadlift", "reps": "3 sets of 10-12 reps"},
        {"name": "Lying Leg Curls", "reps": "3 sets of 10-12 reps"},
        {"name": "Seated Calf Raises", "reps": "4 sets of 12-15 reps"},
        {"name": "Leg Raises on Roman Chair", "reps": "4 sets of 12-15 reps"}
      ]
    },
    
    // Advanced Routines
    {
      "title": "Advanced: Pull A",
      "description": "Advanced back and biceps workout for experienced lifters following PPL split.",
      "difficulty": "Advanced",
      "type": "Pull",
      "duration": "75-90 min",
      "exercises": [
        {"name": "Barbell Deadlift", "reps": "5 sets of 5 reps"},
        {"name": "Pullups or Lat Pulldowns", "reps": "3 sets of 10-12 reps"},
        {"name": "T-bar Rows or Seated Cable Rows", "reps": "3 sets of 10-12 reps"},
        {"name": "Face Pulls", "reps": "4 sets of 12-15 reps"},
        {"name": "Hammer Curls", "reps": "4 sets of 10-12 reps (superset with Dumbbell Shrugs)"},
        {"name": "Dumbbell Shrugs", "reps": "4 sets of 10-12 reps (superset with Hammer Curls)"},
        {"name": "Standing Cable Curls", "reps": "4 sets of 10-12 reps"}
      ]
    },
    {
      "title": "Advanced: Push A",
      "description": "Advanced chest, shoulders and triceps workout for the PPL split.",
      "difficulty": "Advanced",
      "type": "Push",
      "duration": "75-90 min",
      "exercises": [
        {"name": "Flat Barbell Bench Press", "reps": "5 sets of 5 reps"},
        {"name": "Seated Dumbbell Press", "reps": "3 sets of 6-8 reps"},
        {"name": "Incline Dumbbell Bench Press", "reps": "3 sets of 10-12 reps"},
        {"name": "Triceps Pushdowns", "reps": "4 sets of 10-12 reps (superset with Lateral Raises)"},
        {"name": "Lateral Raises", "reps": "4 sets of 10-12 reps (superset with Triceps Pushdowns)"},
        {"name": "Cable Crossovers", "reps": "4 sets of 10-12 reps"}
      ]
    },
    {
      "title": "Advanced: Legs A",
      "description": "Advanced leg workout focusing on quad development for the PPL split.",
      "difficulty": "Advanced",
      "type": "Legs",
      "duration": "75-90 min",
      "exercises": [
        {"name": "Barbell Back Squats", "reps": "5 sets of 5 reps"},
        {"name": "Dumbbell Romanian Deadlift", "reps": "3 sets of 6-8 reps"},
        {"name": "Leg Press", "reps": "3 sets of 8-10 reps"},
        {"name": "Lying Leg Curls", "reps": "4 sets of 10-12 reps"},
        {"name": "Seated Calf Raises", "reps": "4 sets of 12-15 reps"},
        {"name": "Decline Crunches", "reps": "4 sets of 12-15 reps"}
      ]
    },
    {
      "title": "Advanced: Pull B",
      "description": "Second advanced pull day with focus on back thickness for the PPL split.",
      "difficulty": "Advanced",
      "type": "Pull",
      "duration": "75-90 min",
      "exercises": [
        {"name": "Bent-over Barbell Rows", "reps": "3 sets of 6-8 reps"},
        {"name": "Pull-ups (weighted if needed)", "reps": "3 sets of 8-10 reps"},
        {"name": "One-arm Rows", "reps": "3 sets of 8-10 reps"},
        {"name": "Hyperextensions", "reps": "4 sets of 10-12 reps (superset with Machine Preacher Curls)"},
        {"name": "Machine Preacher Curls", "reps": "4 sets of 10-12 reps (superset with Hyperextensions)"},
        {"name": "Barbell Shrugs", "reps": "4 sets of 10-12 reps"},
        {"name": "Standing Dumbbell Curls", "reps": "4 sets of 10-12 reps"}
      ]
    },
    {
      "title": "Advanced: Push B",
      "description": "Second advanced push day with focus on shoulder development.",
      "difficulty": "Advanced",
      "type": "Push",
      "duration": "75-90 min",
      "exercises": [
        {"name": "Overhead Press", "reps": "5 sets of 5 reps"},
        {"name": "Dumbbell Bench Press (incline or flat)", "reps": "3 sets of 8-10 reps"},
        {"name": "Dips (weighted if needed)", "reps": "4 sets of 10-12 reps"},
        {"name": "Single-arm Cable Lateral Raises", "reps": "4 sets of 10-12 reps"},
        {"name": "Machine Fly", "reps": "4 sets of 10-12 reps"},
        {"name": "Overhead Extensions with Rope", "reps": "4 sets of 10-12 reps"}
      ]
    },
    {
      "title": "Advanced: Legs B",
      "description": "Second advanced leg day with front squat emphasis for complete leg development.",
      "difficulty": "Advanced",
      "type": "Legs",
      "duration": "75-90 min",
      "exercises": [
        {"name": "Barbell Front Squats", "reps": "5 sets of 5 reps"},
        {"name": "Glute Ham Raises", "reps": "3 sets of 8-10 reps"},
        {"name": "Walking Dumbbell Lunges", "reps": "3 sets of 10-12 reps per leg"},
        {"name": "Seated Leg Extensions", "reps": "4 sets of 10-12 reps (superset with Standing Calf Raises)"},
        {"name": "Standing Calf Raises", "reps": "4 sets of 12-15 reps (superset with Seated Leg Extensions)"},
        {"name": "Hanging Leg Raises", "reps": "4 sets of 12-15 reps"}
      ]
    }
  ];

  List<String> get routineTypes {
    final List<String> result = ['All'];
    for (var routine in routines) {
      if (!result.contains(routine['type'])) {
        result.add(routine['type'] as String);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoutines = routines
        .where((routine) =>
            (selectedDifficulty == 'All' || routine["difficulty"] == selectedDifficulty) &&
            (selectedRoutineType == 'All' || routine["type"] == selectedRoutineType))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gym Workout Routines", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Experience Level:", style: TextStyle(fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Beginner', 'Intermediate', 'Advanced']
                        .map((level) => Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 8.0),
                              child: ChoiceChip(
                                label: Text(level),
                                selected: selectedDifficulty == level,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedDifficulty = level;
                                  });
                                },
                                selectedColor: Colors.green,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: selectedDifficulty == level ? Colors.white : Colors.green,
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(color: Colors.green.shade700, width: 1),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Workout Type:", style: TextStyle(fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: routineTypes
                        .map((type) => Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 8.0),
                              child: ChoiceChip(
                                label: Text(type),
                                selected: selectedRoutineType == type,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedRoutineType = type;
                                  });
                                },
                                selectedColor: Colors.green,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: selectedRoutineType == type ? Colors.white : Colors.green,
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(color: Colors.green.shade700, width: 1),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredRoutines.isEmpty
                ? const Center(child: Text("No routines found for your selection."))
                : ListView.builder(
                    itemCount: filteredRoutines.length,
                    itemBuilder: (context, index) {
                      final routine = filteredRoutines[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RoutineDetailsScreen(
                                  title: routine["title"]!,
                                  description: routine["description"]!,
                                  exercises: routine["exercises"],
                                  difficulty: routine["difficulty"]!,
                                  routineType: routine["type"]!,
                                  duration: routine["duration"]!,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routine["title"]!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(routine["description"]!),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(routine["difficulty"]!, style: const TextStyle(fontSize: 12)),
                                      backgroundColor: _getDifficultyColor(routine["difficulty"]!),
                                      side: BorderSide.none,
                                      padding: EdgeInsets.zero,
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(routine["type"]!, style: const TextStyle(fontSize: 12)),
                                      backgroundColor: Colors.blue.withOpacity(0.1),
                                      side: BorderSide.none,
                                      padding: EdgeInsets.zero,
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(routine["duration"]!, style: const TextStyle(fontSize: 12)),
                                      backgroundColor: Colors.orange.withOpacity(0.1),
                                      side: BorderSide.none,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green.withOpacity(0.1);
      case 'Intermediate':
        return Colors.orange.withOpacity(0.1);
      case 'Advanced':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}

class RoutineDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final List<dynamic> exercises;
  final String difficulty;
  final String routineType;
  final String duration;

  const RoutineDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.exercises,
    required this.difficulty,
    required this.routineType,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: _getDifficultyColor(difficulty),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoItem(Icons.fitness_center, 'Level', difficulty),
                      _buildInfoItem(Icons.category, 'Type', routineType),
                      _buildInfoItem(Icons.timer, 'Time', duration),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Exercises",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      exercise["name"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: exercise["reps"]!.isNotEmpty ? Text(exercise["reps"]!) : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
  
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green.withOpacity(0.1);
      case 'Intermediate':
        return Colors.orange.withOpacity(0.1);
      case 'Advanced':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}