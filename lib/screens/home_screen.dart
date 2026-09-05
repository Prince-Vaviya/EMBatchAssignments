import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_item.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

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
      final sweepAngle = (values[i] / total) * (2 * math.pi) - (values.length > 1 ? gapAngle : 0);

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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedDayIndex = -1; // -1 means defaults to current day

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

  int _getTodayDayIndex() {
    // DateTime.weekday: 1=Mon, 2=Tue, ..., 7=Sun
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
      case 0: // Sun
        return {'Legs': 8, 'Core': 4, 'Cardio': 3};
      case 1: // Mon
        return {'Chest': 9, 'Shoulders': 5, 'Arms': 4};
      case 2: // Tue
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

    // Compute weekly calories array: past days + today's live workouts; future days are 0.0
    final List<double> weeklyData = List.generate(7, (i) {
      if (i < todayIndex) {
        return _baseCalories[i];
      } else if (i == todayIndex) {
        return _baseCalories[i] + todayLiveCalories;
      } else {
        return 0.0; // Future days after today
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

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting (Name only, no age/roll number)
            Text(
              userProfile.name.isNotEmpty
                  ? 'Hey, ${userProfile.name} 👋'
                  : 'Hey, Athlete 👋',
              style: const TextStyle(
                fontSize: 24,
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Weekly Calories Burn Bar Graph Component with Y-axis and Dotted Line
            _buildWeeklyCalorieGraph(
              weeklyData: weeklyData,
              maxCalorie: maxCalorie,
              todayIndex: todayIndex,
              totalWeeklyBurn: totalWeeklyBurn,
            ),

            const SizedBox(height: 18),

            // Metric Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppTheme.primary,
                    label: "Today's Burn",
                    value:
                        '${(todayLiveCalories + _baseCalories[todayIndex]).toInt()} kcal',
                    sublabel: "You're on fire 🔥",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.checklist_rounded,
                    iconColor: AppTheme.primary,
                    label: 'Sets Progress',
                    value: '$completedSets / $totalSets',
                    sublabel: '${workouts.length} exercises active',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Category Muscle Group Ring Chart Component with vibrant colors (Blue, Violet, Pink, Magenta, Orange)
            _buildCategoryRingChart(
              selectedDayName: _days[currentSelectedDay],
              categorySplit: categorySplit,
              isFuture: currentSelectedDay > todayIndex,
            ),
          ],
        ),
      ),
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

    // Calculate Y-axis top ceiling and steps (e.g. 1000, 750, 500, 250, 0 or 800, 600, 400, 200, 0)
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

                // Main Graph Area (Dotted Lines + Active Dotted Line + Bars)
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Dotted Grid Lines (4 levels)
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

                      // Active Dynamic Dotted Projection Line from Bar to Y-axis
                      if (!isFutureSelected && selectedCal > 0)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          top: activeLineTop,
                          left: 0,
                          right: 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomPaint(
                                  size: const Size(double.infinity, 2),
                                  painter: const DottedLinePainter(
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

                      // 7 Day Bars (Sun - Sat)
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

                                    // Day Name Label (Sun - Sat)
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
    final totalSets = categorySplit.values.fold<int>(0, (sum, val) => sum + val);

    // Sort categories by highest set count
    final sortedEntries = categorySplit.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = sortedEntries.isNotEmpty ? sortedEntries.first.key : 'None';
    final topPercentage = totalSets > 0 && sortedEntries.isNotEmpty
        ? ((sortedEntries.first.value / totalSets) * 100).toInt()
        : 0;

    final values = sortedEntries.map((e) => e.value.toDouble()).toList();
    final colors = sortedEntries.map((e) => AppTheme.getCategoryColor(e.key)).toList();
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
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: topCategoryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: topCategoryColor.withValues(alpha: 0.35)),
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

                // Right: Categories Legend Breakdown
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

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String sublabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
