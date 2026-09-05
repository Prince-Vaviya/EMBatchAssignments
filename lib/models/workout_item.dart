/// Case Study 02: Workout Logger Item Model
/// Demonstrating Dart null safety rules (?, !, late, ??)
class WorkoutLoggerItem {
  final String id;
  final String exerciseName;
  final String category; // e.g., Chest, Back, Legs, Arms, Core, Cardio
  final int targetSets;
  final int completedSets;
  final double weightLoad; // in kg
  final int repetitions;
  final double? estimatedCalories; // Nullable demonstration (?)
  final DateTime createdAt;
  final String? notes; // Nullable demonstration (?)

  WorkoutLoggerItem({
    required this.id,
    required this.exerciseName,
    required this.category,
    required this.targetSets,
    this.completedSets = 0,
    required this.weightLoad,
    required this.repetitions,
    this.estimatedCalories,
    DateTime? createdAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now(); // Null-coalescing (??)

  /// Feature Enhancement: Calculate estimated calories burned
  /// Formula based on MET value approximation for strength training:
  /// Calories = MET * weight_factor * duration/reps factor
  double get calculatedCalories {
    if (estimatedCalories != null) {
      return estimatedCalories!; // Bang operator demonstration (!)
    }
    // Default dynamic formula: (sets * reps * weight * 0.04) + 15 base cal
    final double calc = (targetSets * repetitions * (weightLoad > 0 ? weightLoad : 50) * 0.0035) + (targetSets * 8.0);
    return double.parse(calc.toStringAsFixed(1));
  }

  WorkoutLoggerItem copyWith({
    String? id,
    String? exerciseName,
    String? category,
    int? targetSets,
    int? completedSets,
    double? weightLoad,
    int? repetitions,
    double? estimatedCalories,
    DateTime? createdAt,
    String? notes,
  }) {
    return WorkoutLoggerItem(
      id: id ?? this.id,
      exerciseName: exerciseName ?? this.exerciseName,
      category: category ?? this.category,
      targetSets: targetSets ?? this.targetSets,
      completedSets: completedSets ?? this.completedSets,
      weightLoad: weightLoad ?? this.weightLoad,
      repetitions: repetitions ?? this.repetitions,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseName': exerciseName,
      'category': category,
      'targetSets': targetSets,
      'completedSets': completedSets,
      'weightLoad': weightLoad,
      'repetitions': repetitions,
      'estimatedCalories': estimatedCalories,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory WorkoutLoggerItem.fromMap(Map<String, dynamic> map) {
    return WorkoutLoggerItem(
      id: map['id'] as String,
      exerciseName: map['exerciseName'] as String,
      category: map['category'] as String,
      targetSets: map['targetSets'] as int,
      completedSets: (map['completedSets'] as int?) ?? 0,
      weightLoad: (map['weightLoad'] as num).toDouble(),
      repetitions: map['repetitions'] as int,
      estimatedCalories: (map['estimatedCalories'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      notes: map['notes'] as String?,
    );
  }
}
