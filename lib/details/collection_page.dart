import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import 'artifact_details_page.dart';
import '../chat/chat_bot_page.dart';

class CollectionPage extends StatefulWidget {
  final List<Map<String, dynamic>> collectionItems;

  const CollectionPage({
    Key? key,
    required this.collectionItems,
  }) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  String selectedFilter = "All Items";

  final TextEditingController searchController =
  TextEditingController();

  String searchText = "";

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final filteredItems = widget.collectionItems.where((item) {
      final tags = item['tags'] as List<dynamic>? ?? [];

      final filterMatch = selectedFilter == "All Items"
          ? true
          : tags.any(
            (tag) => tag
            .toString()
            .toLowerCase()
            .contains(
          selectedFilter.toLowerCase(),
        ),
      );

      final searchMatch =
          searchText.isEmpty ||
              item['title']
                  .toString()
                  .toLowerCase()
                  .contains(
                searchText.toLowerCase(),
              ) ||
              item['subtitle']
                  .toString()
                  .toLowerCase()
                  .contains(
                searchText.toLowerCase(),
              );

      return filterMatch && searchMatch;
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        AppLocalization.translate("collection"),                        style: TextStyle(
                          fontSize: width * 0.09,
                          fontWeight: FontWeight.w800,
                          color: const Color(
                            0xFF2B2B2B,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: height * 0.005,
                ),

                  Text(
                    AppLocalization.translate("collection_description"),                  style: TextStyle(
                    color: Color(0xFF8E6F45),
                    fontSize: 14,
                  ),
                ),

                SizedBox(
                  height: height * 0.02,
                ),

                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration:
                     InputDecoration(
                      hintText: AppLocalization.translate("search_collection"),                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                      ),
                      border:
                      InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: height * 0.02,
                ),

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
                        child: AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds: 250,
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
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: height * 0.02,
                ),

                GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount:
                  filteredItems.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder:
                      (context, index) {
                    return _buildArtifactCard(
                      filteredItems[index],
                    );
                  },
                ),
              ],
            ),
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

            // Image
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Hero(
                  tag: item['title'],
                  child: Image.asset(
                    item['image'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              flex: 3,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
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
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Color(0xFF252525),
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      item['subtitle'],
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color:
                        Color(0xFF8E6F45),
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),

                    const Spacer(),

                    // Tags
                    SingleChildScrollView(
                      scrollDirection:
                      Axis.horizontal,
                      child: Row(
                        children:
                        (item['tags']
                        as List<dynamic>? ??
                            [])
                            .map(
                              (tag) =>
                              Container(
                                margin:
                                const EdgeInsets.only(
                                  right: 4,
                                ),
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
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
                                    fontSize:
                                    9,
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                              ),
                        )
                            .toList(),
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