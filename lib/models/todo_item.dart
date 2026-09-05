import 'package:flutter/material.dart';

enum TodoCategory {
  work('Work', Icons.work_outline_rounded, Color(0xFFBAE6FD), Color(0xFF0369A1)),
  personal('Personal', Icons.person_outline_rounded, Color(0xFFFBCFE8), Color(0xFFBE185D)),
  study('Study', Icons.menu_book_rounded, Color(0xFFDDD6FE), Color(0xFF6D28D9)),
  health('Health', Icons.favorite_outline_rounded, Color(0xFFBBF7D0), Color(0xFF15803D)),
  shopping('Shopping', Icons.shopping_bag_outlined, Color(0xFFFED7AA), Color(0xFFC2410C));

  final String label;
  final IconData icon;
  final Color pastelBg;
  final Color textDark;

  const TodoCategory(this.label, this.icon, this.pastelBg, this.textDark);
}

enum EisenhowerQuadrant {
  q1DoFirst(
    code: 'Q1',
    title: 'Do First',
    subtitle: 'Urgent & Important',
    actionDesc: 'Immediate crises, critical deadlines & exams',
    pastelBg: Color(0xFFFFE4E6), // Soft Rose / Blush
    pastelCardBg: Color(0xFFFFF1F2),
    accentDark: Color(0xFFE11D48),
    textDark: Color(0xFF9F1239),
    icon: Icons.local_fire_department_rounded,
    badgeText: 'DO NOW',
  ),
  q2Schedule(
    code: 'Q2',
    title: 'Schedule',
    subtitle: 'Not Urgent & Important',
    actionDesc: 'Strategic goals, deep work & personal growth',
    pastelBg: Color(0xFFE0F2FE), // Soft Sky
    pastelCardBg: Color(0xFFF0F9FF),
    accentDark: Color(0xFF0284C7),
    textDark: Color(0xFF075985),
    icon: Icons.event_available_rounded,
    badgeText: 'DECIDE',
  ),
  q3Delegate(
    code: 'Q3',
    title: 'Delegate',
    subtitle: 'Urgent & Not Important',
    actionDesc: 'Quick errands, small requests & minor chores',
    pastelBg: Color(0xFFFEF3C7), // Soft Butter / Peach
    pastelCardBg: Color(0xFFFFFBEB),
    accentDark: Color(0xFFD97706),
    textDark: Color(0xFF92400E),
    icon: Icons.people_outline_rounded,
    badgeText: 'DELEGATE',
  ),
  q4Eliminate(
    code: 'Q4',
    title: 'Eliminate',
    subtitle: 'Not Urgent & Not Important',
    actionDesc: 'Distractions, excess media & low-value tasks',
    pastelBg: Color(0xFFDCFCE7), // Soft Mint / Sage
    pastelCardBg: Color(0xFFF0FDF4),
    accentDark: Color(0xFF16A34A),
    textDark: Color(0xFF166534),
    icon: Icons.spa_outlined,
    badgeText: 'MINIMIZE',
  );

  final String code;
  final String title;
  final String subtitle;
  final String actionDesc;
  final Color pastelBg;
  final Color pastelCardBg;
  final Color accentDark;
  final Color textDark;
  final IconData icon;
  final String badgeText;

  const EisenhowerQuadrant({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.actionDesc,
    required this.pastelBg,
    required this.pastelCardBg,
    required this.accentDark,
    required this.textDark,
    required this.icon,
    required this.badgeText,
  });

  static EisenhowerQuadrant fromFlags({
    required bool isUrgent,
    required bool isImportant,
  }) {
    if (isUrgent && isImportant) return EisenhowerQuadrant.q1DoFirst;
    if (!isUrgent && isImportant) return EisenhowerQuadrant.q2Schedule;
    if (isUrgent && !isImportant) return EisenhowerQuadrant.q3Delegate;
    return EisenhowerQuadrant.q4Eliminate;
  }
}

class TodoItem {
  final String id;
  String title;
  String? description;
  bool isCompleted;
  bool isUrgent;
  bool isImportant;
  final TodoCategory category;
  final DateTime createdAt;
  DateTime? dueDate;

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.isUrgent = true,
    this.isImportant = true,
    this.category = TodoCategory.personal,
    DateTime? createdAt,
    this.dueDate,
  }) : createdAt = createdAt ?? DateTime.now();

  EisenhowerQuadrant get quadrant => EisenhowerQuadrant.fromFlags(
        isUrgent: isUrgent,
        isImportant: isImportant,
      );

  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isUrgent,
    bool? isImportant,
    TodoCategory? category,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isUrgent: isUrgent ?? this.isUrgent,
      isImportant: isImportant ?? this.isImportant,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
