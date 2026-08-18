import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tool_item.dart';
import '../utils/tool_registry.dart';
import '../providers/app_providers.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final favTools = favProvider.favorites.map((id) => ToolRegistry.getById(id)).whereType<ToolItem>().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: favTools.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border, size: 80, color: Colors.grey), SizedBox(height: 16), Text('还没有收藏的工具', style: TextStyle(color: Colors.grey)), SizedBox(height: 8), Text('在首页长按工具卡片即可收藏', style: TextStyle(color: Colors.grey, fontSize: 12))]))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: favTools.length,
              itemBuilder: (ctx, i) {
                final tool = favTools[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: tool.pageBuilder)),
                  onLongPress: () => favProvider.toggleFavorite(tool.id),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.2))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(children: [
                          Container(width: 44, height: 44, decoration: BoxDecoration(color: tool.category.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(tool.icon, color: tool.category.color, size: 24)),
                          const Positioned(right: -2, top: -2, child: Icon(Icons.favorite, size: 14, color: Colors.red)),
                        ]),
                        const SizedBox(height: 6),
                        Text(tool.name, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
