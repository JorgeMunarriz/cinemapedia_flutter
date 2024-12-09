import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TvSeriesHorizontalListViews extends StatefulWidget {
  final List<TvSerie> tvSeries;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;
  const TvSeriesHorizontalListViews({
    super.key,
    required this.tvSeries,
    this.title,
    this.subTitle,
    this.loadNextPage,
  });

  @override
  State<TvSeriesHorizontalListViews> createState() =>
      _TvSeriesHorizontalListViewsState();
}

class _TvSeriesHorizontalListViewsState extends State<TvSeriesHorizontalListViews> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(
              title: widget.title,
              subTitle: widget.subTitle,
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.tvSeries.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(
                  child: _Slide(
                    tvSerie: widget.tvSeries[index],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final TvSerie tvSerie;
  const _Slide({required this.tvSerie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push('/home/0/serie/${tvSerie.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  fit: BoxFit.cover,
                  tvSerie.posterPath == "no-poster"
                      ? "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png"
                      : tvSerie.posterPath,
                  width: 150,
                  height: 220,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    return FadeIn(child: child);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 150,
              height: 20,
              child: Text(
                tvSerie.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle.titleSmall,
              ),
            ),
            SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_half_outlined,
                    color: Colors.yellow.shade800,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    '${tvSerie.voteAverage}',
                    style: textStyle.bodyMedium?.copyWith(
                      color: Colors.yellow.shade800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    HumanFormats.number(tvSerie.popularity),
                    style: textStyle.bodyMedium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(
                subTitle!,
              ),
            )
        ],
      ),
    );
  }
}