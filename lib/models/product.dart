import 'package:flutter/material.dart';

enum ProductCategory {
  all('All'),
  electronics('Electronics'),
  audio('Audio'),
  footwear('Footwear'),
  lifestyle('Lifestyle'),
  accessories('Accessories');

  final String label;
  const ProductCategory(this.label);
}

class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final ProductCategory category;
  final Color pastelColor;
  final IconData icon;
  final String badge;
  final bool inStock;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.pastelColor,
    required this.icon,
    this.badge = '',
    this.inStock = true,
    this.isFavorite = false,
  });

  double get discountPercent {
    if (originalPrice <= price) return 0.0;
    return (((originalPrice - price) / originalPrice) * 100);
  }
}
