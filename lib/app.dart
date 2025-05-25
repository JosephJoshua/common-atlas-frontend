import 'package:common_atlas_frontend/features/profile/profile_page.dart';
import 'package:common_atlas_frontend/features/routes/routes_page.dart';
import 'package:common_atlas_frontend/features/store/store_page.dart';
import 'package:flutter/material.dart';

class CommonAtlasApp extends StatelessWidget {
  const CommonAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Common Atlas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          primary: const Color(0xFF00A9E0), // Vibrant sky blue
          secondary: const Color(0xFFFFA500), // Standard orange
          background: const Color(0xFFF5F5F5), // Light off-white
          surface: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light off-white
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialPageIndex});
  final int? initialPageIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.black, // Will be inherited from theme
        // unselectedItemColor: Colors.black, // Will be inherited from theme
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Routes'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_outlined), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          // Ensure direct children are const if they are, or remove const from <Widget>[] if any child isn't.
          children: const <Widget>[
            Center(child: RoutesPage()), // Changed from HomePage
            Center(child: Placeholder(child: Text("Progress Page Placeholder"))), // New Progress Page
            Center(child: StorePage()),
            Center(child: ProfilePage()),
          ],
        ),
      ),
    );
  }
}
