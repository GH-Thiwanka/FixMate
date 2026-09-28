import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String imageUrl;
  final Color color;
  final List<String> subServices;
  final bool isPopular;
  final int order;

  CategoryModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.color,
    this.subServices = const [],
    this.isPopular = false,
    this.order = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    Color parsedColor;
    try {
      final colorStr = json['colorCode'] as String? ?? '0xFFE8F5E9';
      parsedColor = Color(int.parse(colorStr));
    } catch (_) {
      parsedColor = const Color(0xFFE8F5E9);
    }

    return CategoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      color: parsedColor,
      subServices: (json['subServices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isPopular: json['isPopular'] as bool? ?? false,
      order: (json['order'] is num) ? (json['order'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'colorCode': '0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
      'subServices': subServices,
      'isPopular': isPopular,
      'order': order,
    };
  }
}
