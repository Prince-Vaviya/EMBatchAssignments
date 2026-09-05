import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class WorkoutDetailsScreen extends ConsumerStatefulWidget {
  final String workoutId;

  const WorkoutDetailsScreen({
    super.key,
    required this.workoutId,
  });

  @override
  ConsumerState<WorkoutDetailsScreen> createState() =>
      _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends ConsumerState<WorkoutDetailsScreen> {
  Timer? _timer;
  int _timerSeconds = 60;
  int _initialSeconds = 60;
  bool _isTimerRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🔔 Rest time is over! Ready for the next set!'),
              backgroundColor: AppTheme.primaryDark,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer([int seconds = 60]) {
    _timer?.cancel();
    setState(() {
      _initialSeconds = seconds;
      _timerSeconds = seconds;
      _isTimerRunning = false;
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(workoutItemProvider(widget.workoutId));

    if (workout == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Workout Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 64, color: AppTheme.textSecondary),
              const SizedBox(height: 16),
              const Text(
                'Workout Entry Not Found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(workout.exerciseName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.error),
            onPressed: () {
              ref.read(workoutListProvider.notifier).removeWorkout(workout.id);
              context.pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          final catColor = AppTheme.getCategoryColor(workout.category);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: catColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: catColor.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              workout.category.toUpperCase(),
                              style: TextStyle(
                                color: catColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        'ID: ${workout.id.length > 6 ? workout.id.substring(workout.id.length - 6) : workout.id}',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    workout.exerciseName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (workout.notes != null && workout.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      workout.notes!,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                  const Divider(height: 32, color: AppTheme.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('Target Sets', '${workout.targetSets}', Icons.repeat),
                      _buildMetric('Reps/Set', '${workout.repetitions}', Icons.fitness_center),
                      _buildMetric('Weight', '${workout.weightLoad} kg', Icons.monitor_weight),
                      _buildMetric('Burn', '${workout.calculatedCalories.toInt()} kcal', Icons.local_fire_department),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feature Enhancement: Rest Timer Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.timer_rounded, color: AppTheme.primary),
                      SizedBox(width: 8),
                      Text(
                        'Rest Timer (Enhancement)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _formatTimer(_timerSeconds),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isTimerRunning ? _pauseTimer : _startTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isTimerRunning
                                    ? AppTheme.warning
                                    : AppTheme.primary,
                                foregroundColor: const Color(0xFF000000),
                              ),
                              icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                              label: Text(_isTimerRunning ? 'Pause' : 'Start Rest'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => _resetTimer(_initialSeconds),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.textSecondary,
                                side: const BorderSide(color: AppTheme.borderLight),
                              ),
                              icon: const Icon(Icons.restart_alt_rounded),
                              label: const Text('Reset'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          children: [30, 60, 90, 120].map((sec) {
                            return ActionChip(
                              label: Text('${sec}s'),
                              backgroundColor: AppTheme.surfaceVariant,
                              side: BorderSide(
                                color: _initialSeconds == sec ? AppTheme.primary : AppTheme.border,
                              ),
                              labelStyle: TextStyle(
                                color: _initialSeconds == sec ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                              onPressed: () => _resetTimer(sec),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sets Completion Tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sets Logged',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${workout.completedSets} / ${workout.targetSets} completed',
                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(workout.targetSets, (index) {
              final isDone = index < workout.completedSets;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.primary.withValues(alpha: 0.1)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDone ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isDone ? AppTheme.primary : AppTheme.surfaceVariant,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isDone ? const Color(0xFF000000) : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Set ${index + 1}: ${workout.weightLoad} kg × ${workout.repetitions} reps',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isDone ? AppTheme.textPrimary : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: isDone ? AppTheme.primary : AppTheme.textSecondary,
                      ),
                      onPressed: () {
                        ref.read(workoutListProvider.notifier).incrementCompletedSet(workout.id);
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
