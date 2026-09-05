import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/workout_item.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class WorkoutLoggerScreen extends ConsumerStatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  ConsumerState<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends ConsumerState<WorkoutLoggerScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutListProvider);

    final filteredWorkouts = _selectedCategory == 'All'
        ? workouts
        : workouts.where((w) => w.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Workout Logger',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${filteredWorkouts.length} logged',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Track your sets, loads, and exercise progress',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'All',
                        'Chest',
                        'Back',
                        'Legs',
                        'Shoulders',
                        'Arms',
                        'Core',
                        'Cardio',
                      ].map((cat) {
                        final isSelected = _selectedCategory == cat;
                        final catColor = cat == 'All' ? AppTheme.primary : AppTheme.getCategoryColor(cat);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                            selectedColor: catColor,
                            checkmarkColor: const Color(0xFF000000),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF000000)
                                  : AppTheme.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                            backgroundColor: AppTheme.surfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected ? catColor : AppTheme.border,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Workout Items List
          if (filteredWorkouts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fitness_center_outlined,
                      size: 56,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No workout entries found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/add'),
                      icon: const Icon(Icons.add),
                      label: const Text('Log First Exercise'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filteredWorkouts[index];
                    return _buildWorkoutCard(context, item);
                  },
                  childCount: filteredWorkouts.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        backgroundColor: AppTheme.primary,
        foregroundColor: const Color(0xFF000000),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Log Workout',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, WorkoutLoggerItem item) {
    final progress = item.targetSets > 0
        ? (item.completedSets / item.targetSets).clamp(0.0, 1.0)
        : 0.0;
    final catColor = AppTheme.getCategoryColor(item.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/details/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Category tag + Calories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: catColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      item.category.toUpperCase(),
                      style: TextStyle(
                        color: catColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppTheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.calculatedCalories.toInt()} kcal',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Exercise Name
              Text(
                item.exerciseName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // Metrics row (Sets, Reps, Weight load)
              Row(
                children: [
                  _buildCardBadge(Icons.repeat, '${item.targetSets} Sets'),
                  const SizedBox(width: 8),
                  _buildCardBadge(Icons.numbers, '${item.repetitions} Reps'),
                  const SizedBox(width: 8),
                  _buildCardBadge(
                    Icons.fitness_center,
                    '${item.weightLoad} kg',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppTheme.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${item.completedSets}/${item.targetSets} sets done',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
