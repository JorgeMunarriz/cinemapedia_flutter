import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                size: 30,
                Icons.movie_outlined,
                color: colors.primary,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Cinemapedia',
                style: titleStyle.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchMovies: ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery,
                      
                    ),
                  ).then((movie) {
                    if (movie == null) return;
                    if (context.mounted) {
                      context.push('/movie/${movie.id}');
                    }
                  });
                },
                icon: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
