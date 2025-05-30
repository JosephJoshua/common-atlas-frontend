import 'package:common_atlas_frontend/features/home_map/home_map_page.dart';
import 'package:common_atlas_frontend/features/profile/profile_page.dart';
import 'package:common_atlas_frontend/features/progress/progress_page.dart';
import 'package:common_atlas_frontend/features/routes/routes_page.dart';
import 'package:common_atlas_frontend/features/store/store_page.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonAtlasApp extends StatelessWidget {
  const CommonAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData.light();

    return MaterialApp(
      title: 'Common Atlas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          primary: const Color(0xFF5B86E5),
          secondary: const Color(0xFF36D1DC),
          surface: Colors.white,
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: const Color(0xFF333333),
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
          bodyMedium: GoogleFonts.lato(
            textStyle: base.textTheme.bodyMedium?.copyWith(color: const Color(0xFF333333)),
          ),
          titleMedium: GoogleFonts.lato(
            textStyle: base.textTheme.titleMedium?.copyWith(color: const Color(0xFF333333)),
          ),
          headlineSmall: GoogleFonts.lato(
            textStyle: base.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        primaryTextTheme: GoogleFonts.latoTextTheme(base.primaryTextTheme),
        cardTheme: CardThemeData(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B86E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF5B86E5)),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: const Color(0xFF5B86E5),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 5.0,
        ),
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

  final List<String> _pageTitles = const ["Home", "Routes", "Progress", "Store", "Profile"];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Routes'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_outlined), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: const <Widget>[
            HomeMapPage(),
            RoutesPage(),
            ProgressPage(),
            StorePage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
