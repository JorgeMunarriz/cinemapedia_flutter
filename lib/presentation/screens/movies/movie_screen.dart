import 'package:cinemapedia/config/config_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  late ScrollController _scrollController;
  bool _showBanner = true;
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && _showBanner) {
        setState(() {
          _showBanner = false;
        });
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
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              movie: movie,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _MovieDetails(movie: movie),
                childCount: 1,
              ),
            )
          ],
        ),
        if (_showBanner)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: FadeIn(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Desliza hacia arriba',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.arrow_upward_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          )
      ]),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleAndOverView(movie: movie, size: size, textStyles: textStyles),
        _Genres(
          movie: movie,
        ),
        ActorsByMovie(movieId: movie.id.toString()),
        VideosFromMovie(movieId: movie.id),
        SimilarMovies(movieId: movie.id)
      ],
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'Géneros',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                ...movie.genreIds.map((gender) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Chip(
                        backgroundColor: colors.secondary,
                        label: Text(
                          gender,
                          style: TextStyle(color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleAndOverView extends StatelessWidget {
  final Movie movie;
  final Size size;
  final TextTheme textStyles;
  const _TitleAndOverView({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              width: size.width * 0.3,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleLarge),
                Text(movie.overview),
                const SizedBox(height: 10),
                MovieRating(voteAverage: movie.voteAverage),
                Row(
                  children: [
                    const Text('Estreno:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(DateFormats.formatDate(movie.releaseDate))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});
