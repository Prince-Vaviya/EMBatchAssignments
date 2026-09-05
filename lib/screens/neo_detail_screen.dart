import 'package:flutter/material.dart';
import '../models/user_registration.dart';
import '../theme/neo_brutalist_pastel_theme.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract UserRegistration model passed as argument via Named Route
    final UserRegistration? user =
        ModalRoute.of(context)?.settings.arguments as UserRegistration?;

    // Fallback if accessed directly without arguments
    final fallbackUser = UserRegistration(
      fullName: 'Alex Vance',
      email: 'alex.vance@neoverse.io',
      role: 'Software Engineer',
      membershipTier: 'Pro Builder',
      pastelAccent: NeoTheme.pastelMint,
    );

    final currentUser = user ?? fallbackUser;

    return Scaffold(
      backgroundColor: NeoTheme.background,
      appBar: AppBar(
        title: const Text('MEMBERSHIP PASS 🎖️'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: NeoTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: NeoTheme.black),
            onPressed: () {
              // Pop back to root Home screen using Named Route pattern
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: Column(
          children: [
            // Success Notification Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: NeoTheme.pastelLime,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: NeoTheme.black, width: 2),
                boxShadow: NeoTheme.hardShadow(x: 2.5, y: 2.5),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: NeoTheme.black),
                  SizedBox(width: 6),
                  Text(
                    'REGISTRATION VERIFIED & ACTIVE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: NeoTheme.black,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ==========================================
            // OFFICIAL NEO-BRUTALIST ID BADGE CARD
            // ==========================================
            Container(
              width: double.infinity,
              decoration: NeoTheme.neoBox(
                color: currentUser.pastelAccent,
                radius: 24,
                borderWidth: 3.0,
                shadowOffset: 6.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Top Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
                      border: Border(bottom: BorderSide(color: NeoTheme.black, width: 2.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: NeoTheme.black,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'NEO GUILD PASS',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: NeoTheme.black,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: NeoTheme.pastelButter,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: NeoTheme.black, width: 1.5),
                          ),
                          child: Text(
                            currentUser.memberId,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: NeoTheme.black,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge Body (Photo Box + Name + Role)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Avatar Box
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: NeoTheme.black, width: 2.5),
                                boxShadow: NeoTheme.hardShadow(x: 3, y: 3),
                              ),
                              child: Center(
                                child: Text(
                                  currentUser.fullName.isNotEmpty
                                      ? currentUser.fullName.substring(0, 1).toUpperCase()
                                      : 'N',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: NeoTheme.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Name & Verified Email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser.fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: NeoTheme.black,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.mark_email_read_rounded,
                                          size: 14, color: Color(0xFF047857)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          currentUser.email,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF333333),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Detail Info Tiles
                        _buildInfoRow('ROLE', currentUser.role),
                        const SizedBox(height: 8),
                        _buildInfoRow('MEMBERSHIP TIER', currentUser.membershipTier),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'ISSUED DATE',
                          '${currentUser.registeredAt.day}/${currentUser.registeredAt.month}/${currentUser.registeredAt.year}',
                        ),

                        const SizedBox(height: 18),

                        // Barcode Simulator
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: NeoTheme.black, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(24, (index) {
                              final isThick = index % 3 == 0;
                              final isDouble = index % 5 == 0;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                width: isDouble ? 5.0 : (isThick ? 3.0 : 1.5),
                                height: 28,
                                color: NeoTheme.black,
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

            const SizedBox(height: 24),

            // ==========================================
            // ACTION BUTTONS (Named Navigation)
            // ==========================================
            Row(
              children: [
                // Register Another
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Named Route Navigation: Pop & push replacement to '/form'
                      Navigator.pushReplacementNamed(context, '/form');
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: NeoTheme.neoBox(
                        color: Colors.white,
                        radius: 14,
                        borderWidth: 2.2,
                        shadowOffset: 3.5,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, size: 18, color: NeoTheme.black),
                          SizedBox(width: 4),
                          Text(
                            'Register New',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: NeoTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Return to Home
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Pop back to root Home screen '/'
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: NeoTheme.neoBox(
                        color: NeoTheme.pastelMint,
                        radius: 14,
                        borderWidth: 2.2,
                        shadowOffset: 3.5,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_rounded, size: 18, color: NeoTheme.black),
                          SizedBox(width: 6),
                          Text(
                            'Home Feed ➔',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: NeoTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NeoTheme.black, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF666666),
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: NeoTheme.black,
            ),
          ),
        ],
      ),
    );
  }
}
