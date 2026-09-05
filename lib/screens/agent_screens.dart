import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/agent_provider.dart';

/// Secret Agent Shell Screen with tactical HUD UI
class AgentShellScreen extends StatelessWidget {
  final Widget child;

  const AgentShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Stealth dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF66).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF00FF66), width: 1.2),
              ),
              child: const Icon(
                Icons.security_rounded,
                color: Color(0xFF00FF66),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SECRET AGENT INTELLIGENCE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: child,
    );
  }
}

/// DetailScreen displaying the Agent Status and "Activate Alias" action
class DetailScreen extends ConsumerWidget {
  final String target;

  const DetailScreen({super.key, required this.target});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current agent alias from userProvider
    final currentUser = ref.watch(userProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tactical Terminal Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: currentUser == 'Supreme Ninja'
                      ? const Color(0xFF00FF66)
                      : const Color(0xFF30363D),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentUser == 'Supreme Ninja'
                        ? const Color(0xFF00FF66).withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: currentUser == 'Supreme Ninja'
                              ? const Color(0xFF00FF66)
                              : const Color(0xFFFF9900),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: currentUser == 'Supreme Ninja'
                                  ? const Color(0xFF00FF66)
                                  : const Color(0xFFFF9900),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentUser == 'Supreme Ninja'
                            ? 'CLASSIFIED PROTOCOL ACTIVE'
                            : 'ENCRYPTED INTELLIGENCE FEED',
                        style: TextStyle(
                          color: currentUser == 'Supreme Ninja'
                              ? const Color(0xFF00FF66)
                              : const Color(0xFF8B949E),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Expected Output Display: Agent 007: TargetAcquired / Supreme Ninja: TargetAcquired
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: Text(
                      '$currentUser: $target',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF58A6FF),
                        fontFamily: 'Courier',
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Agent ID: $currentUser | Target: $target',
                    style: const TextStyle(
                      color: Color(0xFF8B949E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Requirement 2 & 3: "Activate Alias" button calling ref.read(userProvider.notifier).set('Supreme Ninja')
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Requirement 3: Trigger state change to 'Supreme Ninja'
                  ref.read(userProvider.notifier).set('Supreme Ninja');
                },
                icon: const Icon(Icons.flash_on_rounded, size: 20),
                label: const Text(
                  'Activate Alias',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF66),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
