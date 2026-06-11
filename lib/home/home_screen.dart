import 'package:flutter/material.dart';
import 'package:graduation_project/details/artifact_details_page.dart';
import 'package:graduation_project/home/start_tour_page.dart';

import '../chat/chat_bot_page.dart';
import '../details/collection_page.dart';
import '../localization/app_localization.dart';
import '../widgets/app_colors.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;
  final Function() onFavoriteChanged;

  const HomePage({
    Key? key,
    required this.favorites,
    required this.onFavoriteChanged,
    required List<Map<String, dynamic>> favoriteItems,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> artifacts = [
    {
      "title": "Golden Mask of Tutankhamun",

      "subtitle": "Valley of the Kings",

      "tags": ["Statues", "Gold"],

      "image": "assets/image/card.png",
    },

    {
      "title": "Colossus of Ramses II",

      "subtitle": "The Grand Hall",

      "tags": ["Statues", "Limestone"],

      "image": "assets/image/hieroglyphics_wall.jpg",
    },

    {
      "title": "Sarcophagus of Ani",

      "subtitle": "Funerary Collection",

      "tags": ["Sarcophagi", "Wood"],

      "image": "assets/image/sarcophagus.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final screenWidth = MediaQuery.of(context).size.width;

    final filteredArtifacts = artifacts.where((artifact) {
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

               Text(
                AppLocalization.translate("welcome_to"),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

               Text(
                  AppLocalization.translate("khemet_smart_guide"),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B6F4E),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                AppLocalization.translate("explore_the_treasures_of_ancient_egypt"),

                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),

              SizedBox(height: screenHeight * 0.03),

              TextField(
                controller: _searchController,

                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },

                decoration: InputDecoration(
                  hintText: AppLocalization.translate("search_artifacts"),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),

                  filled: true,

                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              Container(
                height: screenHeight * 0.38,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  image: const DecorationImage(
                    image: AssetImage('assets/image/Home.png'),

                    fit: BoxFit.cover,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        gradient: LinearGradient(
                          begin: Alignment.topCenter,

                          end: Alignment.bottomCenter,

                          colors: [
                            Colors.transparent,

                            Colors.black.withOpacity(0.3),
                          ],
                        ),
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

                                text:  TextSpan(
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),

                                  children: [
                                    TextSpan(
                                      text: AppLocalization.translate("discover_the_n"),                                      style: TextStyle(color: Colors.white),
                                    ),

                                    TextSpan(
                                      text: AppLocalization.translate("wonders_of"),                                      style: TextStyle(color: Colors.white),
                                    ),

                                    TextSpan(
                                      text: AppLocalization.translate("ancient_egypt"),                                      style: TextStyle(
                                        color: Color(0xFFC9A24D),
                                      ),
                                    ),
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
                                  backgroundColor: const Color(0xFFC9A24D),

                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                onPressed: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) => const StartTourPage(),
                                    ),
                                  );
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Text(
                                      AppLocalization.translate("start_tour"),

                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),

                                    SizedBox(width: 20),

                                    Icon(
                                      Icons.arrow_right_alt,
                                      color: Colors.white,
                                    ),
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
                   Text(
                    AppLocalization.translate("collection"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CollectionPage(collectionItems: artifacts),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalization.translate("view_all"),
                      style: TextStyle(
                        color: Color(0xFFC9A24D),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              SizedBox(
                height: screenHeight * 0.44,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: filteredArtifacts.length,

                  itemBuilder: (context, index) {
                    final artifact = filteredArtifacts[index];

                    return _buildArtifactCard(artifact);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "chatbot",

        backgroundColor: const Color(0xFFC9A24D),

        elevation: 8,

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const ChatBotPage()),
          );
        },

        child: const Icon(Icons.auto_awesome, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildArtifactCard(Map<String, dynamic> artifact) {
    final String image = artifact["image"];

    final String title = AppLocalization.translate(
      artifact["title"].toString(),
    );

    final String subtitle = AppLocalization.translate(
      artifact["subtitle"].toString(),
    );

    final List<String> tags = List<String>.from(artifact["tags"]);

    final bool isFavorite = widget.favorites.any(
      (item) => item['title'] == title,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => ArtifactDetailsPage(
              title: title,
              imagePath: image,
              dynasty: tags.isNotEmpty ? tags[0] : "",
              material: tags.length > 1 ? tags[1] : "",
              description: subtitle,

              favorites: widget.favorites,

              onFavoriteChanged: widget.onFavoriteChanged,
            ),
          ),
        );
      },

      child: Container(
        width: 220,

        margin: const EdgeInsets.only(right: 18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.all(10),

              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),

                    child: Image.asset(
                      image,

                      height: 240,
                      width: 200,

                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,

                    child: GestureDetector(
                      onTap: () {
                        final alreadyExists = widget.favorites.any(
                          (item) => item['title'] == title,
                        );

                        setState(() {
                          if (alreadyExists) {
                            widget.favorites.removeWhere(
                              (item) => item['title'] == title,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text(
                                  AppLocalization.translate("removed_from_favorites"),
                                ),                              ),
                            );
                          } else {
                            widget.favorites.add({
                              'title': title,
                              'subtitle': subtitle,
                              'image': image,
                              'tags': tags,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text(
                                  AppLocalization.translate("added_to_favorites"),
                                ),                              ),
                            );
                          }
                        });

                        widget.onFavoriteChanged();
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        padding: const EdgeInsets.all(7),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),

                          shape: BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),

                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,

                          color: isFavorite
                              ? Colors.redAccent
                              : const Color(0xFFC9A24D),

                          size: 24,
                        ),
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
                  Text(
                    title,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,

                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.7),

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Text(
                              AppLocalization.translate(tag.toLowerCase()),

                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
