
import 'package:cinemapedia/presentation/widgets/tv_series/horizontal_tv_series_list_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:cinemapedia/presentation/providers/providers_barrel.dart';
import 'package:cinemapedia/presentation/widgets/widgets_barrel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  String? _formattedDate;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES').then((_) {
      setState(() {
        final DateTime today = DateTime.now().add(const Duration(days:0));
        // Formateamos la fecha y convertimos la primera letra a mayúscula.
        final String rawDate = DateFormat('EEEE d', 'es_ES').format(today);
        _formattedDate = rawDate[0].toUpperCase() + rawDate.substring(1);
      });
    });
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(ratedMoviesProvider.notifier).loadNextPage();

    //series

    ref.read(airingTodayProvider.notifier).loadNextPage();
    ref.read(popularTvSeriesProvider.notifier).loadNextPage();
    ref.read(ratedTvSeriesProvider.notifier).loadNextPage();
    ref.read(onTheAirTvSeriesProvider.notifier).loadNextPage();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final ratedMovies = ref.watch(ratedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideShowProvider);

    final airingTodayTvSeries = ref.watch(airingTodayProvider);
    final popularTvSeries = ref.watch(popularTvSeriesProvider);
    final ratedTvSeries = ref.watch(ratedTvSeriesProvider);
    final onAirTvSeries = ref.watch(onTheAirTvSeriesProvider);

    return Visibility(
      visible: !initialLoading,
      child: CustomScrollView(slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Positioned(
              top: 0,
              left: 0,
              child: CustomAppbar(),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                MoviesSlideshow(movies: slideShowMovies),
                MovieHorizontalListview(
                  title: 'En cines',
                  subTitle: _formattedDate ?? 'Cargando...',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                  movies: nowPlayingMovies,
                ),
                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Próximamente',
                  subTitle: 'Este mes',
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  subTitle: 'Estemes',
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: ratedMovies,
                  title: 'Mejor calificadas',
                  subTitle: 'Desde siempre',
                  loadNextPage: () =>
                      ref.read(ratedMoviesProvider.notifier).loadNextPage(),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text('Series de tv'),
                ),
                TvSeriesHorizontalListViews(
                  tvSeries: airingTodayTvSeries,
                  title: 'Top series del momento',
                  subTitle: _formattedDate ?? 'Cargando...',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                TvSeriesHorizontalListViews(
                  title: 'Emitiendo',
                  subTitle: 'Continuan emitiendo ',
                  tvSeries: onAirTvSeries,
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),
                TvSeriesHorizontalListViews(
                  tvSeries: popularTvSeries,
                  title: 'Populares',
                  subTitle: 'Estemes',
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
                TvSeriesHorizontalListViews(
                  tvSeries: ratedTvSeries,
                  title: 'Mejor calificadas',
                  subTitle: 'Desde siempre',
                  loadNextPage: () =>
                      ref.read(ratedMoviesProvider.notifier).loadNextPage(),
                ),
              ],
            );
          }, childCount: 1),
        ),
      ]),
    );
  }
}
