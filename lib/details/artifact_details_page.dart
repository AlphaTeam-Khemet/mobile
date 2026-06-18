import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../chat/chat_bot_page.dart';
import '../localization/app_localization.dart';
import '../shared_widgets/voice_guide_button.dart';

class ArtifactDetailsPage extends StatefulWidget {
  final String id;
  final String title;
  final String imagePath;
  final String dynasty;
  final String material;
  final String description;
  final List<Map<String, dynamic>> favorites;
  final void Function(Map<String, dynamic>) onToggleFavorite;

  const ArtifactDetailsPage({
    Key? key, required this.id, required this.title, required this.imagePath, required this.dynasty,
    required this.material, required this.description, required this.favorites, required this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<ArtifactDetailsPage> createState() => _ArtifactDetailsPageState();
}

class _ArtifactDetailsPageState extends State<ArtifactDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isFavorite = widget.favorites.any((item) => item['id'] == widget.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF2E8D5),

      body: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),

            child: CachedNetworkImage(
              imageUrl: widget.imagePath,
              width: double.infinity,
              height: screenHeight * 0.65,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: screenHeight * 0.65,
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                height: screenHeight * 0.65,
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey)),
              ),
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
                            AppLocalization.translate("share_artifact_text")
                                .replaceAll("{title}", widget.title),
                            subject: AppLocalization.translate("artifact_details"),
                          );
                        },
                      ),

                      const SizedBox(width: 10),

                      _buildCircleButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,

                        color: isFavorite ? Colors.redAccent : Colors.white,

                        onPressed: () => widget.onToggleFavorite({
                          'id': widget.id,
                          'title': widget.title,
                          'subtitle': widget.description,
                          'image': widget.imagePath,
                          'tags': [widget.dynasty, widget.material],
                        }),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 10,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: Text(
                                widget.title,

                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChatBotPage(artifactName: widget.title),
                                  ),
                                );
                              },

                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),

                                child: Image.asset(
                                  "assets/icons/star.png",

                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              widget.dynasty,

                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(width: 12),

                            const Icon(
                              Icons.diamond,
                              size: 16,
                              color: Colors.grey,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              widget.material,

                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerLeft,

                          child: TabBar(
                            controller: _tabController,

                            isScrollable: true,

                            labelPadding: EdgeInsets.zero,

                            labelColor: Colors.black,

                            unselectedLabelColor: Colors.grey,

                            indicatorColor: const Color(0xFFC9A24D),

                            indicatorWeight: 3,

                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,

                              fontSize: 15,

                              letterSpacing: 0.3,
                            ),

                            tabs:  [Tab(text: AppLocalization.translate("overview")),],
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 240,

                          child: TabBarView(
                            controller: _tabController,

                            children: [_buildContentCard(_buildOverviewTab())],
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
      children: [
        VoiceGuideButton(
          artifactId: widget.id,
          artifactName: widget.title,
          artifactDescription: widget.description,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              widget.description.isNotEmpty ? widget.description : AppLocalization.translate("no_description_available"),
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
