import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/views/views_barrel.dart';

import 'package:cinemapedia/presentation/widgets/widgets_barrel.dart';
import 'package:go_router/go_router.dart';

const viewRoutes = <Widget>[
  HomeView(),
  PopularView(),
  FavoritesView(),
  FavoritesTvSeriesView(),
];

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({
    super.key,
    required this.pageIndex,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    context.go('/home/$index');
  }

  void onBottomNavTapped(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
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
