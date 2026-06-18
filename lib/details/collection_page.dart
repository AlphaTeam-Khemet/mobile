import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../localization/app_localization.dart';
import 'artifact_details_page.dart';
import '../chat/chat_bot_page.dart';
import '../core/network/monument_service.dart';

class CollectionPage extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onToggleFavorite;

  const CollectionPage({Key? key, required this.favorites, required this.onToggleFavorite}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  String selectedFilter = "All Items";
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  bool _sortAscending = true;

  final MonumentService _monumentService = MonumentService();
  List<Map<String, dynamic>> _allItems = [];
  bool _isLoading = true;
  String? _error;

  final List<String> filters = ["All Items", "Artifact", "Pyramid", "Tomb"];

  @override
  void initState() {
    super.initState();
    _loadMonuments();
  }

  Future<void> _loadMonuments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final all = await _monumentService.getAllMonuments();
      setState(() {
        _allItems = all;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = AppLocalization.translate("failed_to_load_monuments");
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final filteredItems = _allItems.where((item) {
      final category = (item['category'] ?? '').toString();
      final filterMatch = selectedFilter == "All Items" ? true : category == selectedFilter;
      final searchMatch = searchText.isEmpty ||
          item['title'].toString().toLowerCase().contains(searchText.toLowerCase()) ||
          item['subtitle'].toString().toLowerCase().contains(searchText.toLowerCase());
      return filterMatch && searchMatch;
    }).toList();

    filteredItems.sort((a, b) {
      final cmp = (a['priority'] as int).compareTo(b['priority'] as int);
      return _sortAscending ? cmp : -cmp;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3EBDD),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC9A24D),
        elevation: 8,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatBotPage()));
        },
        child: const Icon(Icons.auto_awesome, color: Colors.black, size: 28),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMonuments,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                      ),
                      Expanded(
                        child: Text(
                          AppLocalization.translate("collection"),
                          style: TextStyle(fontSize: width * 0.09, fontWeight: FontWeight.w800, color: const Color(0xFF2B2B2B)),
                        ),
                      ),
                      IconButton(
                        tooltip: AppLocalization.translate("sort"),
                        onPressed: () => setState(() => _sortAscending = !_sortAscending),
                        icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, color: const Color(0xFF8E6F45)),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    AppLocalization.translate("collection_description"),
                    style: TextStyle(color: Color(0xFF8E6F45), fontSize: 14),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(18)),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => setState(() => searchText = value),
                      decoration: InputDecoration(
                        hintText: AppLocalization.translate("search_collection"),
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    height: 46,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = selectedFilter == filter;
                        return GestureDetector(
                          onTap: () => setState(() => selectedFilter = filter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFC9A24D) : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(child: Text(filter)),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  if (_isLoading)
                    const Padding(padding: EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator()))
                  else if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Text(_error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 8),
                            TextButton(onPressed: _loadMonuments, child: Text(AppLocalization.translate("retry"))),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 18, childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) => _buildArtifactCard(filteredItems[index]),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtifactCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtifactDetailsPage(
              id: item['id'],
              title: item['title'],
              imagePath: item['image'],
              dynasty: item['tags'] != null && item['tags'].isNotEmpty ? item['tags'][0] : "",
              material: item['tags'] != null && item['tags'].length > 1 ? item['tags'][1] : "",
              description: item['description']?.toString() ?? item['subtitle'],
              favorites: widget.favorites, onToggleFavorite: widget.onToggleFavorite,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    child: Hero(
                      tag: item['id'] ?? item['title'],
                      child: CachedNetworkImage(
                        imageUrl: item['image'], width: double.infinity, height: double.infinity, fit: BoxFit.cover, memCacheWidth: 400,
                        placeholder: (context, url) => Container(color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200, child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => widget.onToggleFavorite(item),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                        child: Icon(
                          widget.favorites.any((f) => f['id'] == item['id']) ? Icons.favorite : Icons.favorite_border,
                          color: widget.favorites.any((f) => f['id'] == item['id']) ? Colors.redAccent : const Color(0xFFC9A24D),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF252525))),
                    const SizedBox(height: 4),
                    Text(item['subtitle'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF8E6F45), fontWeight: FontWeight.w500)),
                    const Spacer(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: (item['tags'] as List<dynamic>? ?? []).map((tag) => Container(
                          margin: const EdgeInsets.only(right: 4), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFF1ECE3), borderRadius: BorderRadius.circular(10)),
                          child: Text(tag.toString(), style: const TextStyle(fontSize: 9, color: Colors.black54)),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}