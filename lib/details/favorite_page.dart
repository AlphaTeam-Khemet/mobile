import 'package:flutter/material.dart';
import 'artifact_details_page.dart';
import '../chat/chat_bot_page.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteItems;

  const FavoritesPage({
    Key? key,
    required this.favoriteItems,
  }) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String selectedFilter = "All Items";
  String searchQuery = "";

  final TextEditingController searchController =
  TextEditingController();

  final List<String> filters = [
    "All Items",
    "Statues",
    "Sarcophagi",
    "Papyrus",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems =
    widget.favoriteItems.where((item) {
      final tags =
          item['tags'] as List<dynamic>? ?? [];

      bool matchesFilter =
      selectedFilter == "All Items"
          ? true
          : tags.any(
            (tag) => tag
            .toString()
            .toLowerCase()
            .contains(
          selectedFilter.toLowerCase(),
        ),
      );

      bool matchesSearch =
          searchQuery.isEmpty ||
              item['title']
                  .toString()
                  .toLowerCase()
                  .contains(
                searchQuery.toLowerCase(),
              ) ||
              item['subtitle']
                  .toString()
                  .toLowerCase()
                  .contains(
                searchQuery.toLowerCase(),
              ) ||
              tags.any(
                    (tag) => tag
                    .toString()
                    .toLowerCase()
                    .contains(
                  searchQuery.toLowerCase(),
                ),
              );

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3EBDD),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC9A24D),
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChatBotPage(),
            ),
          );
        },
        child: const Icon(
          Icons.auto_awesome,
          color: Colors.black,
          size: 28,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "Favorites",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight:
                          FontWeight.w800,
                          color:
                          Color(0xFF2B2B2B),
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "My Collection",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                          Color(0xFF8E6F45),
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ),


                ],
              ),

              const SizedBox(height: 20),

              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText:
                    "Search favorites...",
                    prefixIcon:
                    Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                height: 46,
                child: ListView.builder(
                  scrollDirection:
                  Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder:
                      (context, index) {

                    final filter =
                    filters[index];

                    final isSelected =
                        selectedFilter ==
                            filter;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter =
                              filter;
                        });
                      },
                      child:
                      AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds:
                          250,
                        ),
                        margin:
                        const EdgeInsets.only(
                          right: 10,
                        ),
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration:
                        BoxDecoration(
                          color: isSelected
                              ? const Color(
                              0xFFC9A24D)
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                              30),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style:
                            TextStyle(
                              color:
                              isSelected
                                  ? Colors
                                  .white
                                  : const Color(
                                  0xFF8E6F45),
                              fontWeight:
                              FontWeight
                                  .w600,
                              fontSize:
                              14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              Expanded(
                child:
                filteredItems.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: const [
                      Icon(
                        Icons
                            .favorite_border,
                        size: 60,
                        color:
                        Colors.grey,
                      ),
                      SizedBox(
                          height: 14),
                      Text(
                        "No favorites found",
                        style:
                        TextStyle(
                          fontSize:
                          18,
                          color: Colors
                              .grey,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ],
                  ),
                )
                    : GridView.builder(
                  physics:
                  const BouncingScrollPhysics(),
                  itemCount:
                  filteredItems
                      .length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    2,
                    crossAxisSpacing:
                    14,
                    mainAxisSpacing:
                    18,
                    childAspectRatio:
                    0.60,
                  ),
                  itemBuilder:
                      (context,
                      index) {
                    final item =
                    filteredItems[
                    index];

                    return _buildArtifactCard(
                        item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildArtifactCard(
      Map<String, dynamic> item,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtifactDetailsPage(
              title: item['title'],
              imagePath: item['image'],
              dynasty: item['tags'] != null &&
                  item['tags'].isNotEmpty
                  ? item['tags'][0]
                  : "",
              material: item['tags'] != null &&
                  item['tags'].length > 1
                  ? item['tags'][1]
                  : "",
              description: item['subtitle'], favorites: [], onFavoriteChanged: () {  },
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Expanded(
              flex: 6,
              child: Stack(
                children: [

                  ClipRRect(
                    borderRadius:
                    const BorderRadius.only(
                      topLeft:
                      Radius.circular(24),
                      topRight:
                      Radius.circular(24),
                    ),

                    child: Hero(
                      tag: item['title'],

                      child: Image.asset(
                        item['image'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,

                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.favoriteItems
                              .removeWhere(
                                (favItem) =>
                            favItem[
                            'title'] ==
                                item['title'],
                          );
                        });

                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Removed from Favorites 💔",
                            ),
                            duration:
                            Duration(
                              seconds: 1,
                            ),
                          ),
                        );
                      },

                      child: Container(
                        width: 34,
                        height: 34,

                        decoration:
                        const BoxDecoration(
                          color: Colors.white,
                          shape:
                          BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.favorite,
                          color: Color(
                              0xFFC9A24D),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,

              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      item['title'],

                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Color(0xFF252525),
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      item['subtitle'],

                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                        color:
                        Color(0xFF8E6F45),
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,

                      children:
                      (item['tags']
                      as List<dynamic>)
                          .map(
                            (tag) => Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                              0xFFF1ECE3,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),

                          child: Text(
                            tag.toString(),

                            style:
                            const TextStyle(
                              fontSize: 11,
                              color:
                              Colors.black54,
                              fontWeight:
                              FontWeight
                                  .w500,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}