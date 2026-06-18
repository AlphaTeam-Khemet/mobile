import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:graduation_project/details/artifact_details_page.dart';
import 'package:graduation_project/home/start_tour_page.dart';
import '../chat/chat_bot_page.dart';
import '../details/collection_page.dart';
import '../localization/app_localization.dart';
import '../widgets/app_colors.dart';
import '../core/network/monument_service.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onToggleFavorite;

  const HomePage({
    Key? key,
    required this.favorites,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final MonumentService _monumentService = MonumentService();
  List<Map<String, dynamic>> _featuredArtifacts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeatured();
  }

  Future<void> _loadFeatured() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final all = await _monumentService.getAllMonuments();
      all.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));
      setState(() {
        _featuredArtifacts = all.take(4).toList();
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final filteredArtifacts = _featuredArtifacts.where((artifact) {
      final title = artifact["title"].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Text(AppLocalization.translate("welcome_to"), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text(AppLocalization.translate("khemet_smart_guide"), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF8B6F4E))),
              const SizedBox(height: 6),
              Text(AppLocalization.translate("explore_the_treasures_of_ancient_egypt"), style: TextStyle(fontSize: 18, color: Colors.black54)),
              SizedBox(height: screenHeight * 0.03),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: AppLocalization.translate("search_artifacts"),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                height: screenHeight * 0.38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(image: AssetImage('assets/image/Home.png'), fit: BoxFit.cover),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))],
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.3)]),
                      ),
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                                  children: [
                                    TextSpan(text: AppLocalization.translate("discover_the_n"), style: TextStyle(color: Colors.white)),
                                    TextSpan(text: AppLocalization.translate("wonders_of"), style: TextStyle(color: Colors.white)),
                                    TextSpan(text: AppLocalization.translate("ancient_egypt"), style: TextStyle(color: Color(0xFFC9A24D))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC9A24D), padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StartTourPage())),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppLocalization.translate("start_tour"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                                    SizedBox(width: 20),
                                    Icon(Icons.arrow_right_alt, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalization.translate("collection"), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CollectionPage(
                          favorites: widget.favorites,
                          onToggleFavorite: widget.onToggleFavorite,
                        ),
                      ),
                    ),
                    child: Text(AppLocalization.translate("view_all"), style: TextStyle(color: Color(0xFFC9A24D), fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.48,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_error!, style: const TextStyle(color: Colors.red)),
                                const SizedBox(height: 8),
                                TextButton(onPressed: _loadFeatured, child: Text(AppLocalization.translate("retry"))),
                              ],
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredArtifacts.length,
                            itemBuilder: (context, index) => _buildArtifactCard(filteredArtifacts[index]),
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "chatbot", backgroundColor: const Color(0xFFC9A24D), elevation: 8,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatBotPage())),
        child: const Icon(Icons.auto_awesome, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildArtifactCard(Map<String, dynamic> artifact) {
    final String image = artifact["image"] ?? '';
    final String title = artifact["title"].toString();
    final String subtitle = artifact["subtitle"].toString();
    final List<String> tags = List<String>.from(artifact["tags"] ?? []);
    final bool isFavorite = widget.favorites.any((item) => item['id'] == artifact['id']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtifactDetailsPage(
              id: artifact['id'], title: title, imagePath: image, dynasty: tags.isNotEmpty ? tags[0] : "", material: tags.length > 1 ? tags[1] : "",
              description: artifact["description"]?.toString() ?? subtitle, favorites: widget.favorites, onToggleFavorite: widget.onToggleFavorite,
            ),
          ),
        );
      },
      child: Container(
        width: 220, margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                    child: CachedNetworkImage(
                      imageUrl: image, height: 200, width: 200, fit: BoxFit.cover, memCacheWidth: 400,
                      placeholder: (context, url) => Container(height: 200, width: 200, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Container(
                        height: 200, width: 200, color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: GestureDetector(
                      onTap: () => widget.onToggleFavorite(artifact),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250), padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.92), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)]),
                        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.redAccent : const Color(0xFFC9A24D), size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.background.withOpacity(0.7), borderRadius: BorderRadius.circular(10)),
                      child: Text(tag, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
