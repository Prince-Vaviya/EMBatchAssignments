import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/workout_item.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class WorkoutReel {
  final String id;
  final String exerciseTitle;
  final String category;
  final String trainerName;
  final String trainerHandle;
  final String duration;
  final int initialLikes;
  final int commentsCount;
  final String shortDescription;
  final List<String> executionSteps;
  final List<String> targetMuscles;
  final String commonMistakes;
  final double calorieBurnRate; // kcal per minute
  final List<Color> backgroundGradient;
  final IconData visualIcon;

  const WorkoutReel({
    required this.id,
    required this.exerciseTitle,
    required this.category,
    required this.trainerName,
    required this.trainerHandle,
    required this.duration,
    required this.initialLikes,
    required this.commentsCount,
    required this.shortDescription,
    required this.executionSteps,
    required this.targetMuscles,
    required this.commonMistakes,
    required this.calorieBurnRate,
    required this.backgroundGradient,
    required this.visualIcon,
  });
}

class VideoReelsScreen extends ConsumerStatefulWidget {
  const VideoReelsScreen({super.key});

  @override
  ConsumerState<VideoReelsScreen> createState() => _VideoReelsScreenState();
}

class _VideoReelsScreenState extends ConsumerState<VideoReelsScreen> {
  final PageController _pageController = PageController();
  int _activePageIndex = 0;

  static const List<WorkoutReel> _reels = [
    WorkoutReel(
      id: 'reel_1',
      exerciseTitle: 'Incline Dumbbell Press: Maximum Upper Chest Activation',
      category: 'Chest',
      trainerName: 'Alex Mercer',
      trainerHandle: '@fitPulse',
      duration: '0:45',
      initialLikes: 14200,
      commentsCount: 382,
      shortDescription:
          'Learn the 30° angle sweet spot, retracting your scapula, and driving through the palms for explosive clavicular pec growth.',
      executionSteps: [
        'Set the incline bench to 30 degrees (avoid 45° to reduce front delt strain).',
        'Retract and depress your scapulae into the pad to create a stable base.',
        'Lower dumbbells with a 45° elbow tuck until level with your mid-chest.',
        'Drive upward through the palms without clanking dumbbells at the peak.',
      ],
      targetMuscles: [
        'Upper Pecs (Clavicular Head)',
        'Anterior Deltoids',
        'Triceps',
      ],
      commonMistakes:
          'Flaring elbows out at 90° or bouncing weights off the bottom position.',
      calorieBurnRate: 9.5,
      backgroundGradient: [
        Color(0xFF0F172A),
        Color(0xFF0284C7),
        Color(0xFF0369A1),
      ],
      visualIcon: Icons.fitness_center_rounded,
    ),
    WorkoutReel(
      id: 'reel_2',
      exerciseTitle: 'Barbell Back Squats: Deep Form & Glute Drive',
      category: 'Legs',
      trainerName: 'Elena Rostova',
      trainerHandle: '@fitPulse',
      duration: '1:10',
      initialLikes: 28400,
      commentsCount: 654,
      shortDescription:
          'Master deep hip crease depth, brace 360° intra-abdominal pressure, and eliminate knee valgus collapse.',
      executionSteps: [
        'Rest bar on upper traps (high bar) or across rear delts (low bar).',
        'Take a deep belly breath, expand your core, and push hips backward.',
        'Descend until hip crease breaks parallel below the top of the knee.',
        'Drive feet through the floor and push knees outward on the ascent.',
      ],
      targetMuscles: [
        'Quadriceps',
        'Gluteus Maximus',
        'Adductors',
        'Core Bracing',
      ],
      commonMistakes:
          'Letting knees cave inward (valgus) or allowing chest to collapse forward.',
      calorieBurnRate: 14.0,
      backgroundGradient: [
        Color(0xFF31102A),
        Color(0xFFBE185D),
        Color(0xFF831843),
      ],
      visualIcon: Icons.accessibility_new_rounded,
    ),
    WorkoutReel(
      id: 'reel_3',
      exerciseTitle: 'Lat Pulldown vs Pull-Ups: Wide V-Taper Back Mastery',
      category: 'Back',
      trainerName: 'Marcus Vance',
      trainerHandle: '@marcus_vance',
      duration: '0:55',
      initialLikes: 19800,
      commentsCount: 420,
      shortDescription:
          'Stop pulling with your biceps! Learn the elbow-drive cue and chest-up posture for monstrous lat hypertrophy.',
      executionSteps: [
        'Grip bar slightly wider than shoulder width with thumbs hooked over.',
        'Lean torso back by 10-15 degrees and open chest toward the ceiling.',
        'Initiate the pull by pulling elbows straight down toward your hip pockets.',
        'Squeeze lats at bottom for 1 second, then control the negative eccentric.',
      ],
      targetMuscles: [
        'Latissimus Dorsi',
        'Teres Major',
        'Rhomboids',
        'Middle Traps',
      ],
      commonMistakes:
          'Using excessive momentum/swinging and rounding shoulders forward.',
      calorieBurnRate: 11.2,
      backgroundGradient: [
        Color(0xFF1E1035),
        Color(0xFF7C3AED),
        Color(0xFF4C1D95),
      ],
      visualIcon: Icons.sports_gymnastics_rounded,
    ),
    WorkoutReel(
      id: 'reel_4',
      exerciseTitle:
          'Cable Lateral Raises: 3D Side Deltoids with Constant Tension',
      category: 'Shoulders',
      trainerName: 'Devon Hayes',
      trainerHandle: '@fitPulse',
      duration: '0:40',
      initialLikes: 23100,
      commentsCount: 512,
      shortDescription:
          'Why dumbbells fail in the bottom half and how cable alignment keeps your lateral head under brutal tension throughout.',
      executionSteps: [
        'Set cable pulley at wrist/hand height when standing upright.',
        'Stand tall with a slight forward lean and grip cable handle across body.',
        'Raise arm in the scapular plane (30° forward from straight lateral).',
        'Pause at parallel shoulder height and slowly control the 3-second descent.',
      ],
      targetMuscles: ['Lateral Deltoids', 'Upper Trapezius', 'Anterior Delts'],
      commonMistakes:
          'Shrugging shoulders upward using neck traps instead of isolated deltoid contraction.',
      calorieBurnRate: 8.0,
      backgroundGradient: [
        Color(0xFF2A082C),
        Color(0xFFC026D3),
        Color(0xFF701A75),
      ],
      visualIcon: Icons.sports_kabaddi_rounded,
    ),
    WorkoutReel(
      id: 'reel_5',
      exerciseTitle: 'Bicep 21s & Incline Spider Curls for Massive Bicep Peaks',
      category: 'Arms',
      trainerName: 'Jordan Cole',
      trainerHandle: '@fitPulse',
      duration: '1:00',
      initialLikes: 31200,
      commentsCount: 890,
      shortDescription:
          'Target both the short and long bicep heads through specialized range-of-motion isolation and full peak supination.',
      executionSteps: [
        'Perform 7 reps from bottom to 90 degrees parallel.',
        'Immediately perform 7 reps from 90 degrees to full peak contraction.',
        'Finish with 7 full range-of-motion repetitions with controlled tempo.',
        'Maintain strict elbow position pinned at your ribs without swinging.',
      ],
      targetMuscles: [
        'Biceps Brachii (Short & Long Head)',
        'Brachialis',
        'Forearms',
      ],
      commonMistakes:
          'Swinging torso backward and losing mechanical tension at peak lockout.',
      calorieBurnRate: 8.5,
      backgroundGradient: [
        Color(0xFF331400),
        Color(0xFFEA580C),
        Color(0xFF9A3412),
      ],
      visualIcon: Icons.sports_martial_arts_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        onPageChanged: (index) {
          setState(() {
            _activePageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final reel = _reels[index];
          return _ReelPageItem(reel: reel, isActive: index == _activePageIndex);
        },
      ),
    );
  }
}

class _ReelPageItem extends ConsumerStatefulWidget {
  final WorkoutReel reel;
  final bool isActive;

  const _ReelPageItem({required this.reel, required this.isActive});

  @override
  ConsumerState<_ReelPageItem> createState() => _ReelPageItemState();
}

class _ReelPageItemState extends ConsumerState<_ReelPageItem> {
  bool _isPlaying = true;
  bool _isLiked = false;
  bool _isSaved = false;
  bool _isExpanded = false;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.reel.initialLikes;
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Bookmark saved to My Library 🔖' : 'Bookmark removed',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addQuickWorkout() {
    final newItem = WorkoutLoggerItem(
      id: 'quick_${DateTime.now().millisecondsSinceEpoch}',
      exerciseName: widget.reel.exerciseTitle.split(':')[0],
      category: widget.reel.category,
      targetSets: 4,
      repetitions: 10,
      weightLoad: 25.0,
      completedSets: 0,
      notes: 'Learned from reel: ${widget.reel.trainerHandle}',
    );

    ref.read(workoutListProvider.notifier).addWorkout(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added "${newItem.exerciseName}" to Today\'s Workout!',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Logs',
          textColor: AppTheme.primary,
          onPressed: () => context.push('/details/${newItem.id}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catColor = AppTheme.getCategoryColor(widget.reel.category);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Cinematic Background & Animated Exercise Canvas
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.reel.backgroundGradient,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stylized Exercise Watermark & Icon
                Opacity(
                  opacity: 0.18,
                  child: Icon(
                    widget.reel.visualIcon,
                    size: 260,
                    color: Colors.white,
                  ),
                ),

                // Center Play / Pause Indicator HUD
                AnimatedOpacity(
                  opacity: _isPlaying ? 0.0 : 0.95,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0x99000000),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 48,
                      color: AppTheme.primary,
                    ),
                  ),
                ),

                // Video Progress Bar at Top
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: widget.isActive && _isPlaying ? 0.65 : 0.0,
                            minHeight: 2.5,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.reel.duration,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Cinematic Bottom & Top Dark Gradient Overlays
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xCC000000),
                    Color(0xFF0A0A0A),
                  ],
                  stops: [0.0, 0.2, 0.45, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 3. Right Action Bar (Instagram Reels Style)
        Positioned(
          right: 14,
          bottom: _isExpanded ? 240 : 130,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Like Button
              _buildActionButton(
                icon: _isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: _isLiked ? const Color(0xFFFF2E63) : Colors.white,
                label: _formatCount(_likesCount),
                onTap: _toggleLike,
              ),

              const SizedBox(height: 18),

              // Comments Button
              _buildActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: Colors.white,
                label: '${widget.reel.commentsCount}',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Form questions & discussion board coming up! 💬',
                      ),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              // Bookmark / Save
              _buildActionButton(
                icon: _isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                iconColor: _isSaved ? AppTheme.primary : Colors.white,
                label: 'Save',
                onTap: _toggleSave,
              ),

              const SizedBox(height: 18),

              // Add to Workout Quick Action
              _buildActionButton(
                icon: Icons.add_circle_outline_rounded,
                iconColor: AppTheme.primary,
                label: 'Add',
                onTap: _addQuickWorkout,
              ),
            ],
          ),
        ),

        // 4. Horizontal Description Section (Clickable & Expandable)
        Positioned(
          left: 14,
          right: 74, // Leave space for right action bar
          bottom: 16,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xCC141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isExpanded
                      ? catColor.withValues(alpha: 0.6)
                      : AppTheme.borderLight.withValues(alpha: 0.7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trainer Info & Category Pill
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: catColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          widget.reel.category.toUpperCase(),
                          style: TextStyle(
                            color: catColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.reel.trainerHandle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Exercise Title
                  Text(
                    widget.reel.exerciseTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: _isExpanded ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Collapsed vs Expanded Description Content
                  if (!_isExpanded) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.reel.shortDescription,
                            style: TextStyle(
                              color: AppTheme.textSecondary.withValues(
                                alpha: 0.9,
                              ),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Text(
                          ' more',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Expanded Detailed Form Guide
                    const SizedBox(height: 6),
                    Text(
                      widget.reel.shortDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Target Muscles Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: widget.reel.targetMuscles.map((muscle) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Text(
                            '🎯 $muscle',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    // Key Step-by-Step Execution
                    const Text(
                      'Form Checklist:',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...widget.reel.executionSteps.map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(color: AppTheme.primary),
                            ),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Common Mistakes Alert
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0x33FF4444),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0x66FF4444)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: Color(0xFFFF6666),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Avoid: ${widget.reel.commonMistakes}',
                              style: const TextStyle(
                                color: Color(0xFFFFB3B3),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Quick Log Button Inside Expanded View
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addQuickWorkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: const Color(0xFF000000),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'Log This Exercise',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0x88141414),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}
