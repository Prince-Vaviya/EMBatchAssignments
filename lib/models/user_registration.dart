import 'package:flutter/material.dart';

class UserRegistration {
  final String fullName;
  final String email;
  final String role;
  final String membershipTier;
  final DateTime registeredAt;
  final String memberId;
  final Color pastelAccent;

  UserRegistration({
    required this.fullName,
    required this.email,
    required this.role,
    required this.membershipTier,
    DateTime? registeredAt,
    String? memberId,
    this.pastelAccent = const Color(0xFFB8F2E6), // Pastel Mint default
  })  : registeredAt = registeredAt ?? DateTime.now(),
        memberId = memberId ?? 'NEO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
}
