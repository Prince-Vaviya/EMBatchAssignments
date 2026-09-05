import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: const Icon(
                  Icons.play_circle_filled_rounded,
                  size: 64,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Workout Video Guides',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore high-definition form tutorials and guided workout routines.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises, muscle groups...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list_rounded, color: AppTheme.primary),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Popular Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Chest',
                'Back',
                'Legs',
                'Shoulders',
                'Biceps',
                'Triceps',
                'Abs & Core',
                'Cardio',
                'HIIT'
              ].map((category) {
                return Chip(
                  label: Text(category),
                  backgroundColor: AppTheme.surfaceVariant,
                  side: const BorderSide(color: AppTheme.border),
                  labelStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 46,
              backgroundColor: AppTheme.primary,
              child: CircleAvatar(
                radius: 43,
                backgroundColor: AppTheme.surfaceVariant,
                child: Icon(Icons.person, size: 50, color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              userProfile.name.isNotEmpty ? userProfile.name : 'FitPulse Athlete',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userProfile.age > 0
                  ? 'Age: ${userProfile.age} yrs • Roll: 150096724005'
                  : 'Roll No: 150096724005',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileTile(Icons.bar_chart_rounded, 'Workout Statistics', 'View your progress'),
            _buildProfileTile(Icons.timer_outlined, 'Rest Timer Settings', 'Default: 60s'),
            _buildProfileTile(Icons.local_fire_department_outlined, 'Calorie Goal', '500 kcal / day'),
            _buildProfileTile(Icons.settings_outlined, 'Preferences', 'Theme & units (kg/lbs)'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        onTap: () {},
      ),
    );
  }
}
