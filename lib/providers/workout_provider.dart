import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_item.dart';

// StateNotifier holding a list of WorkoutLoggerItems
class WorkoutListNotifier extends StateNotifier<List<WorkoutLoggerItem>> {
  WorkoutListNotifier()
      : super([
          WorkoutLoggerItem(
            id: '1',
            exerciseName: 'Barbell Bench Press',
            category: 'Chest',
            targetSets: 4,
            completedSets: 3,
            weightLoad: 75.0,
            repetitions: 10,
            estimatedCalories: 145.0,
            notes: 'Pyramid set up to 80kg next session',
          ),
          WorkoutLoggerItem(
            id: '2',
            exerciseName: 'Incline Dumbbell Press',
            category: 'Chest',
            targetSets: 3,
            completedSets: 2,
            weightLoad: 28.0,
            repetitions: 12,
            estimatedCalories: 95.0,
            notes: 'Felt strong on the 3rd set',
          ),
          WorkoutLoggerItem(
            id: '3',
            exerciseName: 'Barbell Squats',
            category: 'Legs',
            targetSets: 5,
            completedSets: 5,
            weightLoad: 110.0,
            repetitions: 8,
            estimatedCalories: 220.0,
            notes: 'Deep depth, focus on knee stability',
          ),
          WorkoutLoggerItem(
            id: '4',
            exerciseName: 'Lat Pulldown',
            category: 'Back',
            targetSets: 4,
            completedSets: 4,
            weightLoad: 60.0,
            repetitions: 12,
            estimatedCalories: 110.0,
            notes: 'Wide grip pronated',
          ),
        ]);

  void addWorkout(WorkoutLoggerItem item) {
    state = [item, ...state];
  }

  void removeWorkout(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void updateWorkout(WorkoutLoggerItem updatedItem) {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item,
    ];
  }

  void incrementCompletedSet(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            completedSets: (item.completedSets < item.targetSets)
                ? item.completedSets + 1
                : item.completedSets,
          )
        else
          item,
    ];
  }
}

/// StateNotifierProvider exposing the workout list
final workoutListProvider =
    StateNotifierProvider<WorkoutListNotifier, List<WorkoutLoggerItem>>((ref) {
  return WorkoutListNotifier();
});

/// Provider to get a single item by id
final workoutItemProvider =
    Provider.family<WorkoutLoggerItem?, String>((ref, id) {
  final workouts = ref.watch(workoutListProvider);
  try {
    return workouts.firstWhere((item) => item.id == id);
  } catch (_) {
    return null;
  }
});
