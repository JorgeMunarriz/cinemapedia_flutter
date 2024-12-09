import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  static const name = 'popular-views';
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool isLastPage = false;
  bool isLoading = false;
  bool _isDisposed = false;

 


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(ratedTvSeriesProvider.notifier).loadNextPage();
      }
    });
  }
  
   void loadNextPageTvSeries() async {
    // Asegúrate de que el widget esté montado antes de realizar cualquier acción.
    if (isLoading || isLastPage || _isDisposed) return;

    isLoading = true;

    // Verificar si el widget sigue montado antes de llamar a setState.
    final tvSeries =
        await ref.read(favoriteMoviesAndSeriesProvider.notifier).loadNextPageTvSeries();
    if (_isDisposed) return;

    isLoading = false;
    if (tvSeries.isEmpty) {
      isLastPage = true;
    }

    if (mounted) {
      setState(() {}); // Puedes hacer un setState aquí si es necesario.
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final popularTvSeries = ref.watch(ratedTvSeriesProvider);
    if (popularTvSeries.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Series populares'),
      ),
      body: TvSeriesMasonry(
        tvSeries: popularTvSeries,
        loadNextPage: loadNextPageTvSeries,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isDisposed = true;

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
