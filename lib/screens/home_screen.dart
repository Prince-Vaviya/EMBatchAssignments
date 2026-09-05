import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/workout_item.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

/// Dotted Line Painter for Y-Axis and Dynamic Projection
class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const DottedLinePainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashLength = 4.0,
    this.gapLength = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashLength, size.height / 2),
        paint,
      );
      startX += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant DottedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength;
}

/// Category Donut Ring Painter with vibrant color distribution
class CategoryRingPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double strokeWidth;

  const CategoryRingPainter({
    required this.values,
    required this.colors,
    this.strokeWidth = 13.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final total = values.fold<double>(0.0, (sum, val) => sum + val);

    // Empty background circle
    final bgPaint = Paint()
      ..color = AppTheme.surfaceVariant
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    if (total <= 0) return;

    double startAngle = -math.pi / 2;
    const double gapAngle = 0.08;

    for (int i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweepAngle =
          (values[i] / total) * (2 * math.pi) -
          (values.length > 1 ? gapAngle : 0);

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (sweepAngle > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + (gapAngle / 2),
          sweepAngle,
          false,
          paint,
        );
      }
      startAngle += (values[i] / total) * (2 * math.pi);
    }
  }

  @override
  bool shouldRepaint(covariant CategoryRingPainter oldDelegate) => true;
}

/// Responsive Multi-Section Dashboard Screen
/// Demonstrating: ListView, GridView, MediaQuery, and Flexible/Expanded
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedDayIndex = -1; // Defaults to current day

  static const List<String> _days = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  static const List<double> _baseCalories = [
    320.0,
    480.0,
    560.0,
    410.0,
    620.0,
    510.0,
    390.0,
  ];

  // Routine card items for horizontal ListView
  static const List<Map<String, dynamic>> _featuredRoutines = [
    {
      'title': 'Upper Body Hypertrophy',
      'category': 'Chest & Arms',
      'duration': '45 min',
      'intensity': 'High',
      'calories': '420 kcal',
      'icon': Icons.fitness_center_rounded,
      'color': Color(0xFF38BDF8),
    },
    {
      'title': 'High Intensity HIIT',
      'category': 'Cardio & Core',
      'duration': '30 min',
      'intensity': 'Extreme',
      'calories': '380 kcal',
      'icon': Icons.flash_on_rounded,
      'color': Color(0xFFF97316),
    },
    {
      'title': 'Leg Power & Squats',
      'category': 'Legs & Glutes',
      'duration': '50 min',
      'intensity': 'Intense',
      'calories': '510 kcal',
      'icon': Icons.directions_run_rounded,
      'color': Color(0xFFF43F5E),
    },
    {
      'title': 'Back Wings & Pulls',
      'category': 'Back & Shoulders',
      'duration': '40 min',
      'intensity': 'Medium',
      'calories': '350 kcal',
      'icon': Icons.sports_gymnastics_rounded,
      'color': Color(0xFF8B5CF6),
    },
  ];

  // Category items for GridView
  static const List<Map<String, dynamic>> _categories = [
    {
      'name': 'Chest',
      'exercises': 12,
      'icon': Icons.fitness_center_rounded,
      'color': Color(0xFF38BDF8),
    },
    {
      'name': 'Back',
      'exercises': 14,
      'icon': Icons.sports_gymnastics_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'name': 'Legs',
      'exercises': 16,
      'icon': Icons.directions_run_rounded,
      'color': Color(0xFFF43F5E),
    },
    {
      'name': 'Shoulders',
      'exercises': 10,
      'icon': Icons.accessibility_new_rounded,
      'color': Color(0xFFD946EF),
    },
    {
      'name': 'Arms',
      'exercises': 15,
      'icon': Icons.sports_mma_rounded,
      'color': Color(0xFFF97316),
    },
    {
      'name': 'Cardio',
      'exercises': 8,
      'icon': Icons.speed_rounded,
      'color': Color(0xFFE2F163),
    },
  ];

  int _getTodayDayIndex() {
    final weekday = DateTime.now().weekday;
    return weekday == 7 ? 0 : weekday; // 0=Sun, 1=Mon, ..., 6=Sat
  }

  Map<String, int> _getCategorySplitForDay(
    int dayIndex,
    int todayIndex,
    List<WorkoutLoggerItem> workouts,
  ) {
    if (dayIndex > todayIndex) {
      return {}; // Future days have no workout data
    }

    if (dayIndex == todayIndex) {
      if (workouts.isNotEmpty) {
        final Map<String, int> split = {};
        for (final w in workouts) {
          split[w.category] = (split[w.category] ?? 0) + w.targetSets;
        }
        return split;
      }
      return {'Chest': 7, 'Back': 4, 'Legs': 5};
    }

    // Historical day splits
    switch (dayIndex) {
      case 0:
        return {'Legs': 8, 'Core': 4, 'Cardio': 3};
      case 1:
        return {'Chest': 9, 'Shoulders': 5, 'Arms': 4};
      case 2:
        return {'Back': 8, 'Arms': 5, 'Core': 3};
      default:
        return {'Chest': 6, 'Back': 5, 'Legs': 4};
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDayIndex = _getTodayDayIndex();
  }

  @override
  Widget build(BuildContext context) {
    // 1. MediaQuery: Query screen dimensions and responsive layout flags
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isWideScreen = screenWidth >= 800; // Tablet & Desktop split breakpoint
    final isTablet = screenWidth >= 550;

    final workouts = ref.watch(workoutListProvider);
    final userProfile = ref.watch(userProfileProvider);

    // Summary calculations
    final todayLiveCalories = workouts.fold<double>(
      0.0,
      (sum, item) => sum + item.calculatedCalories,
    );
    final totalSets = workouts.fold<int>(
      0,
      (sum, item) => sum + item.targetSets,
    );
    final completedSets = workouts.fold<int>(
      0,
      (sum, item) => sum + item.completedSets,
    );

    final todayIndex = _getTodayDayIndex();
    final currentSelectedDay = (_selectedDayIndex >= 0 && _selectedDayIndex < 7)
        ? _selectedDayIndex
        : todayIndex;

    // Compute weekly calories array
    final List<double> weeklyData = List.generate(7, (i) {
      if (i < todayIndex) {
        return _baseCalories[i];
      } else if (i == todayIndex) {
        return _baseCalories[i] + todayLiveCalories;
      } else {
        return 0.0;
      }
    });

    final double totalWeeklyBurn = weeklyData
        .take(todayIndex + 1)
        .fold(0.0, (a, b) => a + b);
    final double maxCalorie = weeklyData
        .reduce((a, b) => a > b ? a : b)
        .clamp(600.0, 2000.0);

    final categorySplit = _getCategorySplitForDay(
      currentSelectedDay,
      todayIndex,
      workouts,
    );

    final double horizontalPadding = screenWidth > 600 ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          16,
          horizontalPadding,
          36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // SECTION 1: ATHLETE GREETING & STATUS BANNER
            // ==========================================
            _buildHeroHeader(userProfile.name, screenWidth),

            const SizedBox(height: 18),

            // ==========================================
            // SECTION 2: RESPONSIVE METRIC STATS GRID (GridView + MediaQuery + Flexible/Expanded)
            // ==========================================
            _buildResponsiveStatsGrid(
              todayCalories:
                  (todayLiveCalories + _baseCalories[todayIndex]).toInt(),
              completedSets: completedSets,
              totalSets: totalSets,
              exerciseCount: workouts.length,
              isTablet: isTablet,
              isWideScreen: isWideScreen,
              screenWidth: screenWidth,
            ),

            const SizedBox(height: 22),

            // ==========================================
            // SECTION 3: ANALYTICS & MUSCLE SPLIT (Adaptive Row / Column with Expanded)
            // ==========================================
            if (isWideScreen)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Weekly Calorie Graph (Expanded)
                  Expanded(
                    flex: 6,
                    child: _buildWeeklyCalorieGraph(
                      weeklyData: weeklyData,
                      maxCalorie: maxCalorie,
                      todayIndex: todayIndex,
                      totalWeeklyBurn: totalWeeklyBurn,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right: Muscle Group Donut Ring Chart (Expanded)
                  Expanded(
                    flex: 5,
                    child: _buildCategoryRingChart(
                      selectedDayName: _days[currentSelectedDay],
                      categorySplit: categorySplit,
                      isFuture: currentSelectedDay > todayIndex,
                    ),
                  ),
                ],
              )
            else ...[
              _buildWeeklyCalorieGraph(
                weeklyData: weeklyData,
                maxCalorie: maxCalorie,
                todayIndex: todayIndex,
                totalWeeklyBurn: totalWeeklyBurn,
              ),
              const SizedBox(height: 16),
              _buildCategoryRingChart(
                selectedDayName: _days[currentSelectedDay],
                categorySplit: categorySplit,
                isFuture: currentSelectedDay > todayIndex,
              ),
            ],

            const SizedBox(height: 26),

            // ==========================================
            // SECTION 4: FEATURED ROUTINES CAROUSEL (Horizontal ListView.builder + Flexible)
            // ==========================================
            _buildSectionHeader(
              title: 'Featured Daily Routines',
              subtitle: 'Curated programs for optimal gains',
              actionLabel: 'Explore All',
              onActionTap: () => context.push('/add'),
            ),
            const SizedBox(height: 12),
            _buildFeaturedRoutinesList(screenWidth),

            const SizedBox(height: 26),

            // ==========================================
            // SECTION 5: MUSCLE GROUP EXPLORER (GridView.builder + MediaQuery + Expanded)
            // ==========================================
            _buildSectionHeader(
              title: 'Target Muscle Groups',
              subtitle: 'Focus your training split today',
              actionLabel: '+ Custom Log',
              onActionTap: () => context.push('/add'),
            ),
            const SizedBox(height: 12),
            _buildCategoryGrid(screenWidth),

            const SizedBox(height: 26),

            // ==========================================
            // SECTION 6: TODAY'S ACTIVE WORKOUT CHECKLIST (ListView.separated / Dynamic Column)
            // ==========================================
            _buildSectionHeader(
              title: "Today's Logged Plan",
              subtitle: '${workouts.length} active movements scheduled',
              actionLabel: 'Log New',
              onActionTap: () => context.push('/add'),
            ),
            const SizedBox(height: 12),
            _buildTodayWorkoutsList(workouts),
          ],
        ),
      ),
    );
  }

  // Section Header with title and quick action link
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Flexible text block
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Hero greeting component
  Widget _buildHeroHeader(String userName, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth > 600 ? 20 : 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Expanded text greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isNotEmpty ? 'Hey, $userName 👋' : 'Hey, Athlete 👋',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 24 : 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's crush today's fitness goals & track your progress",
                  style: TextStyle(
                    color: AppTheme.textSecondary.withValues(alpha: 0.85),
                    fontSize: screenWidth > 600 ? 14 : 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Readiness badge with Flexible
          Flexible(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: AppTheme.primary, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Ready 100%',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section 2: Responsive Metrics Grid (GridView.builder + MediaQuery + Flexible/Expanded)
  Widget _buildResponsiveStatsGrid({
    required int todayCalories,
    required int completedSets,
    required int totalSets,
    required int exerciseCount,
    required bool isTablet,
    required bool isWideScreen,
    required double screenWidth,
  }) {
    final int crossAxisCount = isWideScreen ? 4 : (isTablet ? 4 : 2);
    final double childAspectRatio = isWideScreen
        ? 1.55
        : (isTablet ? 1.45 : (screenWidth < 360 ? 1.3 : 1.45));

    final stats = [
      {
        'icon': Icons.local_fire_department_rounded,
        'iconColor': AppTheme.primary,
        'label': "Today's Burn",
        'value': '$todayCalories kcal',
        'sublabel': "You're on fire 🔥",
      },
      {
        'icon': Icons.checklist_rounded,
        'iconColor': const Color(0xFF38BDF8),
        'label': 'Sets Progress',
        'value': '$completedSets / $totalSets',
        'sublabel': '$exerciseCount active exercises',
      },
      {
        'icon': Icons.timer_outlined,
        'iconColor': const Color(0xFFF97316),
        'label': 'Training Time',
        'value': '${(completedSets * 3.5).toInt()} mins',
        'sublabel': 'Rest avg 60s/set',
      },
      {
        'icon': Icons.insights_rounded,
        'iconColor': const Color(0xFFD946EF),
        'label': 'Weekly Target',
        'value': '${((completedSets / (totalSets > 0 ? totalSets : 1)) * 100).toInt()}%',
        'sublabel': 'Consistent streak ⚡',
      },
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final item = stats[index];
        return _buildStatCard(
          icon: item['icon'] as IconData,
          iconColor: item['iconColor'] as Color,
          label: item['label'] as String,
          value: item['value'] as String,
          sublabel: item['sublabel'] as String,
        );
      },
    );
  }

  // Stat Card Widget using Flexible/Expanded
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String sublabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            sublabel,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Section 4: Featured Routines Horizontal ListView
  Widget _buildFeaturedRoutinesList(double screenWidth) {
    return SizedBox(
      height: 136,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _featuredRoutines.length,
        itemBuilder: (context, index) {
          final item = _featuredRoutines[index];
          final Color accentColor = item['color'] as Color;

          return Container(
            width: screenWidth > 600 ? 250 : 220,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['category'] as String,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(item['icon'] as IconData, color: accentColor, size: 18),
                  ],
                ),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['duration'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 13,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      item['calories'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Section 5: Muscle Group GridView (GridView.builder + MediaQuery + Expanded)
  Widget _buildCategoryGrid(double screenWidth) {
    final int crossAxisCount = screenWidth >= 800 ? 6 : (screenWidth >= 500 ? 3 : 2);

    return GridView.builder(
      itemCount: _categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        final item = _categories[index];
        final Color catColor = item['color'] as Color;

        return InkWell(
          onTap: () => context.push('/add'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item['icon'] as IconData, color: catColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item['exercises']} exercises',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Section 6: Today's Logged Plan List
  Widget _buildTodayWorkoutsList(List<WorkoutLoggerItem> workouts) {
    if (workouts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.fitness_center_rounded,
              size: 38,
              color: AppTheme.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 8),
            const Text(
              'No workouts logged for today yet',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start logging your movements to build your streak',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Exercise'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final workout = workouts[index];
        final categoryColor = AppTheme.getCategoryColor(workout.category);
        final bool isDone = workout.completedSets >= workout.targetSets;

        return InkWell(
          onTap: () => context.push('/details/${workout.id}'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDone
                    ? AppTheme.primary.withValues(alpha: 0.4)
                    : AppTheme.border,
              ),
            ),
            child: Row(
              children: [
                // Category color pill
                Container(
                  width: 4,
                  height: 38,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Exercise details using Expanded
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.exerciseName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            workout.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: categoryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•  ${workout.weightLoad} kg × ${workout.repetitions} reps',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Set progress badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDone
                          ? AppTheme.primary.withValues(alpha: 0.4)
                          : AppTheme.border,
                    ),
                  ),
                  child: Text(
                    '${workout.completedSets}/${workout.targetSets} Sets',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isDone ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Weekly Calorie Burn Bar Graph Component with Y-axis & Dotted lines
  Widget _buildWeeklyCalorieGraph({
    required List<double> weeklyData,
    required double maxCalorie,
    required int todayIndex,
    required double totalWeeklyBurn,
  }) {
    final currentSelected = (_selectedDayIndex >= 0 && _selectedDayIndex < 7)
        ? _selectedDayIndex
        : todayIndex;
    final selectedCal = weeklyData[currentSelected];
    final selectedDayName = _days[currentSelected];
    final isFutureSelected = currentSelected > todayIndex;

    final double yCeiling = (((maxCalorie / 200).ceil() * 200).toDouble())
        .clamp(600.0, 1600.0);
    final List<int> yLabels = [
      yCeiling.toInt(),
      (yCeiling * 0.75).toInt(),
      (yCeiling * 0.50).toInt(),
      (yCeiling * 0.25).toInt(),
      0,
    ];

    const double chartBarHeight = 110.0;
    final double selectedRatio = isFutureSelected
        ? 0.0
        : (selectedCal / yCeiling).clamp(0.0, 1.0);
    final double activeLineTop = (chartBarHeight * (1.0 - selectedRatio)).clamp(
      0.0,
      chartBarHeight,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graph Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Calorie Burn',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${totalWeeklyBurn.toInt()} kcal total this week',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$selectedDayName: ',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      isFutureSelected
                          ? 'Upcoming'
                          : '${selectedCal.toInt()} kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: isFutureSelected
                            ? AppTheme.textSecondary
                            : AppTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Chart Body: Y-Axis Labels + Dotted Grid Lines + Bar Columns
          SizedBox(
            height: 145,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-Axis Labels Column
                SizedBox(
                  width: 34,
                  height: chartBarHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: yLabels.map((val) {
                      return Text(
                        '$val',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary.withValues(alpha: 0.65),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(width: 8),

                // Main Graph Area
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Dotted Grid Lines
                      Positioned.fill(
                        bottom: 35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (index) {
                            return CustomPaint(
                              size: const Size(double.infinity, 1),
                              painter: DottedLinePainter(
                                color: AppTheme.border.withValues(alpha: 0.7),
                                dashLength: 3.0,
                                gapLength: 3.0,
                              ),
                            );
                          }),
                        ),
                      ),

                      // Active Dynamic Dotted Projection Line
                      if (!isFutureSelected && selectedCal > 0)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          top: activeLineTop,
                          left: 0,
                          right: 0,
                          child: const Row(
                            children: [
                              Expanded(
                                child: CustomPaint(
                                  size: Size(double.infinity, 2),
                                  painter: DottedLinePainter(
                                    color: AppTheme.primary,
                                    strokeWidth: 1.5,
                                    dashLength: 4.0,
                                    gapLength: 3.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // 7 Day Bars (Sun - Sat) using Expanded
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(7, (index) {
                            final dayCal = weeklyData[index];
                            final isToday = index == todayIndex;
                            final isFuture = index > todayIndex;
                            final isSelected = index == currentSelected;
                            final double barRatio = isFuture
                                ? 0.0
                                : (dayCal / yCeiling).clamp(0.08, 1.0);

                            return Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDayIndex = index;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Vertical Bar Container Track
                                    Container(
                                      height: chartBarHeight,
                                      alignment: Alignment.bottomCenter,
                                      child: isFuture
                                          ? Container(
                                              width: 14,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: AppTheme.surfaceVariant,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            )
                                          : AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              curve: Curves.easeOutCubic,
                                              height: chartBarHeight * barRatio,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                color: isSelected || isToday
                                                    ? AppTheme.primary
                                                    : AppTheme.primary
                                                          .withValues(
                                                            alpha: 0.35,
                                                          ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow:
                                                    (isSelected || isToday)
                                                    ? [
                                                        BoxShadow(
                                                          color: AppTheme
                                                              .primary
                                                              .withValues(
                                                                alpha: 0.45,
                                                              ),
                                                          blurRadius: 8,
                                                          spreadRadius: 1,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Day Name Label
                                    Text(
                                      _days[index],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isToday || isSelected
                                            ? FontWeight.w900
                                            : FontWeight.w600,
                                        color:
                                            isToday || (isSelected && !isFuture)
                                            ? AppTheme.primary
                                            : isFuture
                                            ? AppTheme.textSecondary.withValues(
                                                alpha: 0.35,
                                              )
                                            : AppTheme.textSecondary,
                                      ),
                                    ),

                                    // Active Day Indicator Dot
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isToday
                                            ? AppTheme.primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Category Muscle Group Ring Chart Component
  Widget _buildCategoryRingChart({
    required String selectedDayName,
    required Map<String, int> categorySplit,
    required bool isFuture,
  }) {
    final totalSets = categorySplit.values.fold<int>(
      0,
      (sum, val) => sum + val,
    );

    final sortedEntries = categorySplit.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = sortedEntries.isNotEmpty
        ? sortedEntries.first.key
        : 'None';
    final topPercentage = totalSets > 0 && sortedEntries.isNotEmpty
        ? ((sortedEntries.first.value / totalSets) * 100).toInt()
        : 0;

    final values = sortedEntries.map((e) => e.value.toDouble()).toList();
    final colors = sortedEntries
        .map((e) => AppTheme.getCategoryColor(e.key))
        .toList();
    final topCategoryColor = sortedEntries.isNotEmpty
        ? AppTheme.getCategoryColor(sortedEntries.first.key)
        : AppTheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: topCategoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.donut_large_rounded,
                      color: topCategoryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Muscle Group Focus',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        isFuture
                            ? '$selectedDayName • Rest / Scheduled'
                            : '$selectedDayName • $totalSets total sets completed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!isFuture && topPercentage > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: topCategoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: topCategoryColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    '🔥 $topCategory Focus',
                    style: TextStyle(
                      color: topCategoryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Body: Ring Chart + Legend
          if (isFuture || totalSets == 0)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.bed_outlined,
                    size: 38,
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No exercises logged for $selectedDayName yet',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                // Left: Custom Ring Chart
                SizedBox(
                  width: 115,
                  height: 115,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(115, 115),
                        painter: CategoryRingPainter(
                          values: values,
                          colors: colors,
                          strokeWidth: 12.0,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$topPercentage%',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            topCategory,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: topCategoryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Right: Categories Legend Breakdown with Expanded
                Expanded(
                  child: Column(
                    children: List.generate(sortedEntries.length, (index) {
                      final entry = sortedEntries[index];
                      final color = AppTheme.getCategoryColor(entry.key);
                      final pct = ((entry.value / totalSets) * 100).toInt();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.value} sets ($pct%)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
