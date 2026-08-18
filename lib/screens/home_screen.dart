import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tool_item.dart';
import '../utils/tool_registry.dart';
import '../providers/app_providers.dart';
import 'tool_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final recentTools = favoritesProvider.recent.map((id) => ToolRegistry.getById(id)).whereType<ToolItem>().toList();
    final favTools = favoritesProvider.favorites.map((id) => ToolRegistry.getById(id)).whereType<ToolItem>().toList();
    final searchResults = ToolRegistry.search(_searchQuery);
    final isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('初眠工具箱'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${ToolRegistry.totalCount}款', style: const TextStyle(fontSize: 12, color: Colors.grey))),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索工具...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: isSearching
                ? _buildSearchResults(searchResults)
                : ListView(
                    children: [
                      if (recentTools.isNotEmpty) ...[
                        _buildSectionHeader('最近使用'),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: recentTools.length,
                            itemBuilder: (ctx, i) => _buildRecentToolCard(recentTools[i]),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (favTools.isNotEmpty) ...[
                        _buildSectionHeader('我的收藏'),
                        _buildToolsGrid(favTools),
                        const SizedBox(height: 16),
                      ],
                      ...ToolCategory.values.map((cat) => _buildCategorySection(cat)),
                      const SizedBox(height: 24),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<ToolItem> results) {
    if (results.isEmpty) {
      return const Center(child: Text('未找到相关工具', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, i) => ListTile(
        leading: Icon(results[i].icon, color: results[i].category.color),
        title: Text(results[i].name),
        subtitle: Text(results[i].description, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(results[i].category.label, style: TextStyle(fontSize: 12, color: results[i].category.color)),
        onTap: () => _openTool(results[i]),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRecentToolCard(ToolItem tool) {
    return GestureDetector(
      onTap: () => _openTool(tool),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: tool.category.color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(tool.icon, color: tool.category.color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(tool.name, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(ToolCategory category) {
    final tools = ToolRegistry.getByCategory(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(category.icon, color: category.color, size: 20),
              const SizedBox(width: 8),
              Text(category.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${tools.length}款', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        _buildToolsGrid(tools),
      ],
    );
  }

  Widget _buildToolsGrid(List<ToolItem> tools) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: tools.length,
      itemBuilder: (ctx, i) => _buildToolCard(tools[i]),
    );
  }

  Widget _buildToolCard(ToolItem tool) {
    return Consumer<FavoritesProvider>(
      builder: (context, favProvider, _) {
        final isFav = favProvider.isFavorite(tool.id);
        return GestureDetector(
          onTap: () => _openTool(tool),
          onLongPress: () => favProvider.toggleFavorite(tool.id),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: tool.category.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(tool.icon, color: tool.category.color, size: 24),
                    ),
                    if (isFav) const Positioned(right: -2, top: -2, child: Icon(Icons.favorite, size: 14, color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(tool.name, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openTool(ToolItem tool) {
    context.read<FavoritesProvider>().addRecent(tool.id);
    Navigator.push(context, MaterialPageRoute(builder: tool.pageBuilder));
  }
}
