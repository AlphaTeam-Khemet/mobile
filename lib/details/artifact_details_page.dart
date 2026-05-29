import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ArtifactDetailsPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String dynasty;
  final String material;
  final String description;

  const ArtifactDetailsPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.dynasty,
    required this.material,
    required this.description,
  }) : super(key: key);

  @override
  State<ArtifactDetailsPage> createState() => _ArtifactDetailsPageState();
}

class _ArtifactDetailsPageState extends State<ArtifactDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2E8D5),
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Image.asset(
              widget.imagePath,
              width: double.infinity,
              height: screenHeight * 0.65,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      _buildCircleButton(
                        icon: Icons.share,
                        onPressed: () {
                          Share.share(
                            'Check out this artifact in KHEMET Smart Guide: ${widget.title}',
                            subject: 'Artifact Details',
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildCircleButton(
                        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                        onPressed: () {
                          setState(() => isFavorite = !isFavorite);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFavorite
                                  ? "Added to Favorites ❤️"
                                  : "Removed from Favorites 💔"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF2E8D5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 10),
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(widget.dynasty,
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(width: 12),
                            const Icon(Icons.diamond, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(widget.material,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: const Color(0xFFC9A24D),
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                          tabs: const [
                            Tab(text: "Overview"),
                            Tab(text: "History"),
                            Tab(text: "Inscriptions"),
                            Tab(text: "Med"),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 220,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildContentCard(_buildOverviewTab()),
                              _buildContentCard(_buildHistoryTab()),
                              _buildContentCard(_buildInscriptionsTab()),
                              _buildContentCard(_buildMedTab()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "The Golden Face of Eternity",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "The mask of Tutankhamun is a gold death mask of the 18th‑dynasty ancient Egyptian Pharaoh Tutankhamun. It was discovered by Howard Carter in 1925 in tomb KV62 and is housed in the Grand Egyptian Museum.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return const Text(
      "Discovered by Howard Carter in 1925 in tomb KV62.",
      style: TextStyle(fontSize: 14, color: Colors.black87),
    );
  }

  Widget _buildInscriptionsTab() {
    return const Text(
      "Hieroglyphic inscriptions represent protection and eternal life.",
      style: TextStyle(fontSize: 14, color: Colors.black87),
    );
  }

  Widget _buildMedTab() {
    return const Text(
      "Made of gold and inlaid with lapis lazuli, quartz, and obsidian.",
      style: TextStyle(fontSize: 14, color: Colors.black87),
    );
  }
}
