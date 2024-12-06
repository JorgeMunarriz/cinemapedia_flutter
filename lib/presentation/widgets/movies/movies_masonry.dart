import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviesMasonry extends ConsumerStatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;
  const MoviesMasonry({
    super.key,
    required this.movies,
    this.loadNextPage,
  });

  @override
  MoviesMasonryState createState() => MoviesMasonryState();
}

class MoviesMasonryState extends ConsumerState<MoviesMasonry> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if ((_scrollController.position.pixels + 100) >=
          _scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
