import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../utils/tool_registry.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle('外观'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('主题模式'),
            subtitle: Text(_themeLabel(themeProvider.themeMode)),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('跟随系统')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('浅色')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('深色')),
              ],
              onChanged: (v) => themeProvider.setThemeMode(v!),
            ),
          ),
          const Divider(),
          _buildSectionTitle('关于'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('应用名称'),
            subtitle: Text('初眠工具箱'),
          ),
          const ListTile(
            leading: Icon(Icons.tag),
            title: Text('版本'),
            subtitle: Text('v1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.extension),
            title: const Text('工具数量'),
            subtitle: Text('${ToolRegistry.totalCount} 款工具'),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('开发者'),
            subtitle: Text('初眠工作室'),
          ),
          const Divider(),
          _buildSectionTitle('其他'),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('清除最近使用'),
            onTap: () {
              context.read<FavoritesProvider>().clearRecent();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已清除最近使用记录')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('清除所有收藏'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('确认清除'),
                  content: const Text('确定要清除所有收藏的工具吗？'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
                    TextButton(
                      onPressed: () {
                        context.read<FavoritesProvider>().clearFavorites();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已清除所有收藏')));
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Center(child: Text('初眠工具箱 v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12))),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold)),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return '跟随系统';
      case ThemeMode.light: return '浅色';
      case ThemeMode.dark: return '深色';
    }
  }
}
