import 'package:flutter/material.dart';
import '../details/favorite_page.dart';
import '../details/profile_page.dart';
import '../details/settings_page.dart';
import '../home/home_screen.dart';
import '../localization/app_localization.dart';
import '../translate/translate_page.dart';
import '../widgets/app_colors.dart';
import '../core/network/favorite_service.dart';
import '../core/network/monument_service.dart';

class MainNavigationPage extends StatefulWidget {
  final bool isGuest;
  const MainNavigationPage({Key? key, this.isGuest = false}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final FavoriteService _favoriteService = FavoriteService();
  final MonumentService _monumentService = MonumentService();

  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final refs = await _favoriteService.getFavoriteRefs();
      final allMonuments = await _monumentService.getAllMonuments();

      final joined = <Map<String, dynamic>>[];
      for (final ref in refs) {
        final monument = allMonuments.firstWhere(
          (m) => m['id'] == ref['monumentId'],
          orElse: () => {},
        );
        if (monument.isNotEmpty) {
          joined.add({...monument, 'favoriteId': ref['favoriteId']});
        }
      }

      if (mounted) setState(() => favorites = joined);
    } catch (e) {
      // Silently ignore for now — favorites just won't show until the next successful load.
    }
  }

  Future<void> _toggleFavorite(BuildContext context, Map<String, dynamic> monument) async {
    if (widget.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.translate("please_register_first_to_save_favorites")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final existingIndex = favorites.indexWhere((f) => f['id'] == monument['id']);

    try {
      if (existingIndex != -1) {
        final favoriteId = favorites[existingIndex]['favoriteId'];
        await _favoriteService.removeFavorite(favoriteId);
        setState(() => favorites.removeAt(existingIndex));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalization.translate("removed_from_favorites"))),
        );
      } else {
        final favoriteId = await _favoriteService.addFavorite(monument['id']);
        setState(() => favorites.add({...monument, 'favoriteId': favoriteId}));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalization.translate("added_to_favorites"))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.translate("something_went_wrong")), backgroundColor: Colors.red),
      );
    }
  }

  void _openTranslate(BuildContext context) {
    if (widget.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.translate("please_register_first_to_use_translate_feature")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanPage()));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        favorites: favorites,
        onToggleFavorite: (monument) => _toggleFavorite(context, monument),
      ),
      FavoritesPage(
        favoriteItems: favorites,
        onToggleFavorite: (monument) => _toggleFavorite(context, monument),
      ),
      ProfilePage(favoriteCount: favorites.length, isGuest: widget.isGuest),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openTranslate(context),
        child: Center(
          child: Image.asset('assets/icons/Transalte.png', width: 26, height: 26, fit: BoxFit.contain),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('assets/icons/Home.png', AppLocalization.translate("home"), 0),
              _buildNavItem('assets/icons/favorite.png', AppLocalization.translate("favorites"), 1),
              const SizedBox(width: 40),
              _buildNavItem('assets/icons/profile.png', AppLocalization.translate("profile"), 2),
              _buildNavItem('assets/icons/settings.png', AppLocalization.translate("settings"), 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 22, color: isSelected ? const Color(0xFFB68D4C) : Colors.grey.shade800),
          const SizedBox(height: 1),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFFB68D4C) : Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }
}