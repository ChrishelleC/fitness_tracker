class Food {
String name;
int calories;

Food({required this.name, required this.calories});

Map<String, dynamic> toMap() {
return {'name': name, 'calories': calories};
}
}