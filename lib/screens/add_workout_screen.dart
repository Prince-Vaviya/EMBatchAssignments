import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/workout_item.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class AddWorkoutLoggerScreen extends ConsumerStatefulWidget {
  const AddWorkoutLoggerScreen({super.key});

  @override
  ConsumerState<AddWorkoutLoggerScreen> createState() =>
      _AddWorkoutLoggerScreenState();
}

class _AddWorkoutLoggerScreenState extends ConsumerState<AddWorkoutLoggerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _exerciseNameController = TextEditingController();
  final _targetSetsController = TextEditingController(text: '3');
  final _weightLoadController = TextEditingController(text: '40');
  final _repetitionsController = TextEditingController(text: '10');
  final _notesController = TextEditingController();

  String _selectedCategory = 'Chest';
  final List<String> _categories = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Cardio',
  ];

  double _calculatedCaloriesPreview = 0.0;

  @override
  void initState() {
    super.initState();
    _recalculateCalories();
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _targetSetsController.dispose();
    _weightLoadController.dispose();
    _repetitionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _recalculateCalories() {
    final int sets = int.tryParse(_targetSetsController.text) ?? 0;
    final int reps = int.tryParse(_repetitionsController.text) ?? 0;
    final double weight = double.tryParse(_weightLoadController.text) ?? 0;

    final temp = WorkoutLoggerItem(
      id: 'temp',
      exerciseName: _exerciseNameController.text.trim(),
      category: _selectedCategory,
      targetSets: sets,
      weightLoad: weight,
      repetitions: reps,
    );

    setState(() {
      _calculatedCaloriesPreview = temp.calculatedCalories;
    });
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final newItem = WorkoutLoggerItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        exerciseName: _exerciseNameController.text.trim(),
        category: _selectedCategory,
        targetSets: int.parse(_targetSetsController.text.trim()),
        completedSets: 0,
        weightLoad: double.parse(_weightLoadController.text.trim()),
        repetitions: int.parse(_repetitionsController.text.trim()),
        estimatedCalories: _calculatedCaloriesPreview,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      ref.read(workoutListProvider.notifier).addWorkout(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppTheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Logged ${newItem.exerciseName} successfully!'),
              ),
            ],
          ),
          backgroundColor: AppTheme.surfaceVariant,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Add Workout Log'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Name Field (Primary field with validation)
              const Text(
                'Exercise Name *',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _exerciseNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Incline Bench Press, Deadlift...',
                  prefixIcon: Icon(Icons.fitness_center_rounded, color: AppTheme.primary),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  if (value.trim().length < 2) {
                    return 'Exercise name must be at least 2 characters';
                  }
                  return null;
                },
                onChanged: (_) => _recalculateCalories(),
              ),

              const SizedBox(height: 20),

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    final catColor = AppTheme.getCategoryColor(category);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        avatar: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: catColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          }
                        },
                        selectedColor: catColor,
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF000000) : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
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

              const SizedBox(height: 20),

              // Target Sets & Repetitions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Target Sets *',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _targetSetsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '3',
                            prefixIcon: Icon(Icons.repeat_rounded, color: AppTheme.primary),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final intVal = int.tryParse(value);
                            if (intVal == null || intVal <= 0) {
                              return 'Must be > 0';
                            }
                            return null;
                          },
                          onChanged: (_) => _recalculateCalories(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reps / Set *',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _repetitionsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '10',
                            prefixIcon: Icon(Icons.numbers_rounded, color: AppTheme.primary),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final intVal = int.tryParse(value);
                            if (intVal == null || intVal <= 0) {
                              return 'Must be > 0';
                            }
                            return null;
                          },
                          onChanged: (_) => _recalculateCalories(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Weight Load (kg)
              const Text(
                'Weight Load (kg) *',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightLoadController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'e.g. 50.0',
                  prefixIcon: Icon(Icons.monitor_weight_outlined, color: AppTheme.primary),
                  suffixText: 'kg',
                  suffixStyle: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter weight load';
                  }
                  final numVal = double.tryParse(value);
                  if (numVal == null || numVal < 0) {
                    return 'Invalid weight';
                  }
                  return null;
                },
                onChanged: (_) => _recalculateCalories(),
              ),

              const SizedBox(height: 20),

              // Feature Enhancement: Calorie Estimator Live Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppTheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Calorie Estimator (Enhancement)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '≈ ${_calculatedCaloriesPreview.toStringAsFixed(1)} kcal burned',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Notes / Instructions Field
              const Text(
                'Notes (Optional)',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tempo, rest time preferences, seat positions...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.edit_note_rounded, color: AppTheme.primary),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _saveWorkout,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Workout Entry'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
