import 'package:flutter/material.dart';

class FavoritesView extends StatefulWidget {
  static const name = 'favorites-views';
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends State<FavoritesView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Llamar a super.build para que funcione el mixin
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas favoritas'),
      ),
      body: const Center(
        child: Text('Favoritos'),
      ),
    );
  }
}
