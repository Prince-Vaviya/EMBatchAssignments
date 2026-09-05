import 'package:flutter/material.dart';

enum ArchiveCategory {
  space('Space', '🚀', Color(0xFFE8D7FF), Color(0xFF6D28D9)),
  dinosaur('Dinosaur', '🦖', Color(0xFFFFD8BE), Color(0xFFC2410C)),
  solarpunk('Solarpunk', '🌿', Color(0xFFB8F2E6), Color(0xFF047857));

  final String label;
  final String emoji;
  final Color pastelBg;
  final Color textDark;

  const ArchiveCategory(this.label, this.emoji, this.pastelBg, this.textDark);
}

class ArchiveEntry {
  final int id;
  final String title;
  final String era;
  final String summary;
  final String tag;
  final String metric;
  final String author;
  final ArchiveCategory category;
  final int likesCount;
  final bool isCached;

  ArchiveEntry({
    required this.id,
    required this.title,
    required this.era,
    required this.summary,
    required this.tag,
    required this.metric,
    required this.author,
    required this.category,
    this.likesCount = 0,
    this.isCached = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'era': era,
      'summary': summary,
      'tag': tag,
      'metric': metric,
      'author': author,
      'category': category.name,
      'likesCount': likesCount,
    };
  }

  factory ArchiveEntry.fromJson(Map<String, dynamic> json, {bool isCached = false}) {
    ArchiveCategory parseCategory(String? cat) {
      switch (cat?.toLowerCase().trim()) {
        case 'space':
          return ArchiveCategory.space;
        case 'dinosaur':
          return ArchiveCategory.dinosaur;
        case 'solarpunk':
          return ArchiveCategory.solarpunk;
        default:
          return ArchiveCategory.solarpunk;
      }
    }

    return ArchiveEntry(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled Archive',
      era: json['era'] as String? ?? 'Unknown Era',
      summary: json['summary'] as String? ?? '',
      tag: json['tag'] as String? ?? 'ARCHIVE',
      metric: json['metric'] as String? ?? 'Standard Rating',
      author: json['author'] as String? ?? 'Anonymous Curator',
      category: parseCategory(json['category'] as String?),
      likesCount: json['likesCount'] as int? ?? 12,
      isCached: isCached,
    );
  }

  ArchiveEntry copyWith({
    int? id,
    String? title,
    String? era,
    String? summary,
    String? tag,
    String? metric,
    String? author,
    ArchiveCategory? category,
    int? likesCount,
    bool? isCached,
  }) {
    return ArchiveEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      era: era ?? this.era,
      summary: summary ?? this.summary,
      tag: tag ?? this.tag,
      metric: metric ?? this.metric,
      author: author ?? this.author,
      category: category ?? this.category,
      likesCount: likesCount ?? this.likesCount,
      isCached: isCached ?? this.isCached,
    );
  }
}
