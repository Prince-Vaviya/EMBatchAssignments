import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'gym_search_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'video_reels_screen.dart';
import 'workout_logger_screen.dart';

class MainScaffoldScreen extends StatefulWidget {
  const MainScaffoldScreen({super.key});

  @override
  State<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
}

class _MainScaffoldScreenState extends State<MainScaffoldScreen> {
  int _currentIndex = 0; // Default to Home

  final List<Widget> _screens = const [
    HomeScreen(), // 0: Home Dashboard
    VideoReelsScreen(), // 1: Video Reels Format
    WorkoutLoggerScreen(), // 2: Dumbbell / Workout Logger
    GymSearchScreen(), // 3: Gym Discovery & Search
    ProfileScreen(), // 4: Profile
  ];

  Widget _buildVideoIcon({required bool isSelected}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          width: 2.2,
        ),
        color: isSelected
            ? AppTheme.primary.withValues(alpha: 0.15)
            : Colors.transparent,
      ),
      child: Center(
        child: Icon(
          Icons.play_arrow_rounded,
          size: 20,
          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNavIcon(int index, bool isSelected) {
    switch (index) {
      case 0:
        return Icon(
          isSelected ? Icons.home_rounded : Icons.home_outlined,
          size: 30,
          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        );
      case 1:
        return _buildVideoIcon(isSelected: isSelected);
      case 2:
        return Transform.rotate(
          angle: isSelected ? -math.pi / 2.4 : -math.pi / 2.4,
          child: Icon(
            isSelected
                ? Icons.fitness_center_rounded
                : Icons.fitness_center_outlined,
            size: 30,
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          ),
        );
      case 3:
        return Icon(
          isSelected ? Icons.search_rounded : Icons.search_rounded,
          size: 30,
          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        );
      case 4:
        return Icon(
          isSelected ? Icons.person_rounded : Icons.person_outline_rounded,
          size: 30,
          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Color(0xFF000000),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FitPulse',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Fire icon with default 0 without outer container
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '4',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF9E0B),
                size: 28,
              ),
              SizedBox(width: 3),
            ],
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 24),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        height: 74,
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border, width: 1.2)),
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / 5;
              return Stack(
                children: [
                  // Smooth gliding top glowing indicator bar
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    left: _currentIndex * tabWidth + (tabWidth - 36) / 2,
                    top: 0,
                    child: Container(
                      width: 39,
                      height: 3.5,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 5 Navigation items
                  Row(
                    children: List.generate(5, (index) {
                      final isSelected = _currentIndex == index;
                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Center(
                            child: AnimatedScale(
                              scale: isSelected ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutBack,
                              child: _buildNavIcon(index, isSelected),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
