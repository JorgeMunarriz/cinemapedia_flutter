import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/views/views_barrel.dart';

import 'package:cinemapedia/presentation/widgets/widgets_barrel.dart';
import 'package:go_router/go_router.dart';

const viewRoutes = <Widget>[
  HomeView(),
  CategoriesViews(),
  FavoritesView(),
];

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    context.go('/home/$index');
  }

  void onBottomNavTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.pageIndex,
        onTap: onBottomNavTapped,
      ),
    );
  }
}
