import 'package:common_atlas_frontend/features/home/home_page.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(25, 199, 30, 41)),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.route_outlined), label: 'Routes'),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_outlined), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: const <Widget>[
            Center(child: HomePage()),
            Center(child: RoutesPage()),
            Center(child: StorePage()),
            Center(child: ProfilePage()),
          ],
        ),
      ),
    );
  }
}
