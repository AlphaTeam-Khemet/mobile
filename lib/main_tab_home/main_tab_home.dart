import 'package:flutter/material.dart';
import '../details/favorite_page.dart';
import '../details/profile_page.dart';
import '../details/settings_page.dart';
import '../home/home_screen.dart';
import '../translate/translate_page.dart';
import '../widgets/app_colors.dart';
class MainNavigationPage extends StatefulWidget {

  final bool isGuest;

  const MainNavigationPage({
    Key? key,
    this.isGuest = false,
  }) : super(key: key);

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<MainNavigationPage> {

  int _currentIndex = 0;

  final List<Map<String, dynamic>> favorites = [];

  void _openTranslate(BuildContext context) {

    if (widget.isGuest) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Please register first to use Translate feature.",
          ),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    Navigator.push(

      context,

      MaterialPageRoute(
        builder: (_) => const ScanPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [

      HomePage(
        favorites: favorites, onFavoriteChanged: () {  }, favoriteItems: [],
      ),

      FavoritesPage(
        favoriteItems: favorites,
      ),

      ProfilePage(
        favoriteCount: favorites.length,
      ),

      const SettingsPage(),
    ];

    return Scaffold(

      body: pages[_currentIndex],

      floatingActionButton: FloatingActionButton(

        backgroundColor: AppColors.primary,

        onPressed: () => _openTranslate(context),

        child: Center(

          child: Image.asset(

            'assets/icons/Transalte.png',

            width: 26,
            height: 26,

            fit: BoxFit.contain,
          ),
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(

        shape: const CircularNotchedRectangle(),

        notchMargin: 8,

        color: AppColors.background,

        child: Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),

          child: Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceAround,

            children: [

              _buildNavItem(
                'assets/icons/Home.png',
                'Home',
                0,
              ),

              _buildNavItem(
                'assets/icons/favorite.png',
                'Favorites',
                1,
              ),

              const SizedBox(width: 40),

              _buildNavItem(
                'assets/icons/profile.png',
                'Profile',
                2,
              ),

              _buildNavItem(
                'assets/icons/settings.png',
                'Settings',
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String iconPath,
      String label,
      int index,
      ) {

    final isSelected = _currentIndex == index;

    return GestureDetector(

      onTap: () {

        setState(() {
          _currentIndex = index;
        });
      },

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Image.asset(

            iconPath,

            width: 22,

            color: isSelected
                ? const Color(0xFFB68D4C)
                : Colors.grey.shade800,
          ),

          const SizedBox(height: 1),

          Text(

            label,

            style: TextStyle(

              color: isSelected
                  ? const Color(0xFFB68D4C)
                  : Colors.grey.shade800,

              fontWeight: FontWeight.bold,

              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}