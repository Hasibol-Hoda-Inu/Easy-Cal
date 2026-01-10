class FoodNutrition {
  final String name;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;

  FoodNutrition({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory FoodNutrition.fromJson(Map<String, dynamic> json) {
    return FoodNutrition(
      name: json['food_name'] ?? "Unknown",
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? "0g",
      carbs: json['carbs'] ?? "0g",
      fat: json['fat'] ?? "0g",
    );
  }
}
