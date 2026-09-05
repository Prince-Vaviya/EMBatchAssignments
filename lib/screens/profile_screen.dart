import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isAgeRevealed = false;

  void _toggleAgeReveal() {
    setState(() {
      _isAgeRevealed = !_isAgeRevealed;
    });
  }

  void _showEditProfileDialog() {
    final userProfile = ref.read(userProfileProvider);
    final nameCtrl = TextEditingController(text: userProfile.name);
    final ageCtrl = TextEditingController(
      text: userProfile.age > 0 ? userProfile.age.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person, color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: ageCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.cake_rounded, color: AppTheme.primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameCtrl.text.trim();
              final newAge = int.tryParse(ageCtrl.text.trim()) ?? userProfile.age;
              if (newName.isNotEmpty) {
                ref.read(userProfileProvider.notifier).updateProfile(
                      name: newName,
                      age: newAge,
                    );
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully! ✨'),
                  backgroundColor: AppTheme.surface,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    final String displayName = userProfile.name.isNotEmpty ? userProfile.name : 'FitPulse Athlete';
    final int userAge = userProfile.age > 0 ? userProfile.age : 22;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar with Glowing Accent Ring
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: AppTheme.surfaceVariant,
                        child: Text(
                          displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Athlete Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Text(
                    'PRO ATHLETE • FITPULSE',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Structured Info Section: Name & Age (Label on Left, Value on Right)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      // Row 1: Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.primary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: _showEditProfileDialog,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppTheme.border),
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1, color: AppTheme.border),
                      ),

                      // Row 2: Age (with clean Reveal/Hide toggle without text bleed)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.cake_rounded,
                                  color: AppTheme.primary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Age',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          // Age Value / Blurred Particles & Reveal Button
                          _buildCleanAgeRevealWidget(userAge),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Clean Age Reveal Widget with no overlapping bleed
  Widget _buildCleanAgeRevealWidget(int age) {
    return GestureDetector(
      onTap: _toggleAgeReveal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _isAgeRevealed
              ? AppTheme.primary.withValues(alpha: 0.15)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isAgeRevealed ? AppTheme.primary : AppTheme.borderLight,
            width: 1.2,
          ),
          boxShadow: _isAgeRevealed
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isAgeRevealed) ...[
              Text(
                '$age yrs',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                  letterSpacing: 0.3,
                ),
              ),
            ] else ...[
              // Blurred Particle Dots (Clean, no text bleed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(width: 8),

            // Reveal / Hide Button Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _isAgeRevealed ? AppTheme.primary : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _isAgeRevealed ? AppTheme.primary : AppTheme.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isAgeRevealed ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    size: 12,
                    color: _isAgeRevealed ? const Color(0xFF000000) : AppTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isAgeRevealed ? 'Hide' : 'Reveal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _isAgeRevealed ? const Color(0xFF000000) : AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
