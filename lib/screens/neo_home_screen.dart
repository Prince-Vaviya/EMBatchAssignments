import 'package:flutter/material.dart';
import '../models/user_registration.dart';
import '../theme/neo_brutalist_pastel_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample verified community members for preview
    final List<UserRegistration> sampleMembers = [
      UserRegistration(
        fullName: 'Alex Vance',
        email: 'alex.vance@neoverse.io',
        role: 'Software Engineer',
        membershipTier: 'Pro Builder',
        pastelAccent: NeoTheme.pastelMint,
        memberId: 'NEO-982341',
      ),
      UserRegistration(
        fullName: 'Sophia Chen',
        email: 'sophia.c@designlabs.co',
        role: 'UI/UX Designer',
        membershipTier: 'Enterprise VIP',
        pastelAccent: NeoTheme.pastelLilac,
        memberId: 'NEO-541298',
      ),
      UserRegistration(
        fullName: 'Marcus Aurel',
        email: 'marcus@productforge.org',
        role: 'Product Lead',
        membershipTier: 'Standard Access',
        pastelAccent: NeoTheme.pastelPeach,
        memberId: 'NEO-773120',
      ),
    ];

    return Scaffold(
      backgroundColor: NeoTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: NeoTheme.neoBox(
                color: NeoTheme.pastelLime,
                radius: 10,
                borderWidth: 2,
                shadowOffset: 2.5,
              ),
              child: const Text(
                'NEO',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: NeoTheme.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('COMMUNITY ⚡'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: NeoTheme.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: NeoTheme.black,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: NeoTheme.pastelMint, width: 2),
                  ),
                  content: const Text(
                    '3-Screen Named Route Demo: Home ➔ Form ➔ Detail',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HERO REGISTRATION CTA BANNER
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: NeoTheme.neoBox(
                color: NeoTheme.pastelLilac,
                radius: 20,
                borderWidth: 2.5,
                shadowOffset: 4.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeoTheme.black, width: 1.8),
                    ),
                    child: const Text(
                      'OFFICIAL ONBOARDING 🚀',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: NeoTheme.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Join the Neo-Brutalist Developer Guild',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: NeoTheme.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Register your membership profile with validated credentials and generate your official digital access badge.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Named Route Navigation to Registration Form
                  InkWell(
                    onTap: () {
                      // Named Route Navigation: '/' -> '/form'
                      Navigator.pushNamed(context, '/form');
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: NeoTheme.neoBox(
                        color: NeoTheme.pastelLime,
                        radius: 14,
                        borderWidth: 2.2,
                        shadowOffset: 3.5,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.how_to_reg_rounded, size: 20, color: NeoTheme.black),
                          SizedBox(width: 8),
                          Text(
                            'Start Registration Form ✍️',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: NeoTheme.black,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 2. HIGHLIGHT PILLARS GRID
            // ==========================================
            const Text(
              'PLATFORM HIGHLIGHTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xFF666666),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.verified_user_rounded,
                    title: 'Form Validation',
                    subtitle: 'Strict regex email & password checks',
                    color: NeoTheme.pastelMint,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.alt_route_rounded,
                    title: 'Named Routes',
                    subtitle: 'Type-safe multi-screen navigation',
                    color: NeoTheme.pastelPeach,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 3. RECENT REGISTERED MEMBERS
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RECENT GUILD PASSES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF666666),
                    letterSpacing: 1.0,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/form'),
                  child: const Text(
                    '+ Add Yours',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: NeoTheme.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...sampleMembers.map((member) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: NeoTheme.neoBox(
                  color: Colors.white,
                  radius: 16,
                  borderWidth: 2.2,
                  shadowOffset: 3.5,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: member.pastelAccent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoTheme.black, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          member.fullName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: NeoTheme.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.fullName,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w900,
                              color: NeoTheme.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${member.role} • ${member.membershipTier}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Named Route Navigation with Arguments: '/' -> '/detail'
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: member,
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: NeoTheme.pastelButter,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeoTheme.black, width: 1.8),
                        ),
                        child: const Text(
                          'View ID ➔',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: NeoTheme.black,
                          ),
                        ),
                      ),
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

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: NeoTheme.neoBox(
        color: color,
        radius: 16,
        borderWidth: 2.2,
        shadowOffset: 3.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NeoTheme.black, width: 1.5),
            ),
            child: Icon(icon, size: 20, color: NeoTheme.black),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: NeoTheme.black,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}
