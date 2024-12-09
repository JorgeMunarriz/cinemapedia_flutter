import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';


class TvSeriesMasonry extends ConsumerStatefulWidget {
  final List<TvSerie> tvSeries;
  final VoidCallback? loadNextPage;
  const TvSeriesMasonry({
    super.key,
    required this.tvSeries,
    this.loadNextPage,
  });

  @override
  TvSeriesMasonryState createState() => TvSeriesMasonryState();
}

class TvSeriesMasonryState extends ConsumerState<TvSeriesMasonry> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesAndSeriesProvider.notifier).loadNextPageTvSeries();
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
        itemCount: widget.tvSeries.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                TvSeriePosterlink(tvSerie: widget.tvSeries[index]),
              ],
            );
          }
          return TvSeriePosterlink(tvSerie: widget.tvSeries[index]);
        },
      ),
    );
  }
}
