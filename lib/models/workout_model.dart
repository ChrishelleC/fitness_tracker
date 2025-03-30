class Workout {
  String exercise;
  int reps;
  int sets;

  Workout({required this.exercise, required this.reps, required this.sets});

  Map<String, dynamic> toMap() {
    return {'exercise': exercise, 'reps': reps, 'sets': sets};
  }
}
