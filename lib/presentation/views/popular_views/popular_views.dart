import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  static const name = 'categories-views';
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // Llamar a super.build para que funcione el mixin
    final popularMovies = ref.watch(popularMoviesProvider);
    if (popularMovies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Peliculas populares'),
        ),
        body: MoviesMasonry(movies: popularMovies));
  }

  @override
  bool get wantKeepAlive => true;
}
