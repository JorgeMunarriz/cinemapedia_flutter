import 'package:flutter/material.dart';

class CategoriesViews extends StatefulWidget {
  static const name = 'categories-views';
  const CategoriesViews({super.key});

  @override
  CategoriesViewsState createState() => CategoriesViewsState();
}

class CategoriesViewsState extends State<CategoriesViews>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Llamar a super.build para que funcione el mixin
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías de películas'),
      ),
      body: const Center(
        child: Text('Categorías'),
      ),
    );
  }
}
