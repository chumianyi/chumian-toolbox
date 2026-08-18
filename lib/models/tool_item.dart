import 'package:flutter/material.dart';

enum ToolCategory {
  system,
  daily,
  network,
  image,
  dev,
  media,
}

class ToolItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final ToolCategory category;
  final WidgetBuilder pageBuilder;

  const ToolItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.pageBuilder,
  });
}

extension ToolCategoryExtension on ToolCategory {
  String get label {
    switch (this) {
      case ToolCategory.system:
        return '系统工具';
      case ToolCategory.daily:
        return '日常工具';
      case ToolCategory.network:
        return '网络工具';
      case ToolCategory.image:
        return '图片工具';
      case ToolCategory.dev:
        return '开发工具';
      case ToolCategory.media:
        return '影音工具';
    }
  }

  IconData get icon {
    switch (this) {
      case ToolCategory.system:
        return Icons.phone_android;
      case ToolCategory.daily:
        return Icons.home;
      case ToolCategory.network:
        return Icons.wifi;
      case ToolCategory.image:
        return Icons.image;
      case ToolCategory.dev:
        return Icons.code;
      case ToolCategory.media:
        return Icons.music_note;
    }
  }

  Color get color {
    switch (this) {
      case ToolCategory.system:
        return Colors.blue;
      case ToolCategory.daily:
        return Colors.green;
      case ToolCategory.network:
        return Colors.cyan;
      case ToolCategory.image:
        return Colors.pink;
      case ToolCategory.dev:
        return Colors.orange;
      case ToolCategory.media:
        return Colors.purple;
    }
  }
}
