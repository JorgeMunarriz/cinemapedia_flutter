import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/providers_barrel.dart';

class TvSerieScreen extends ConsumerStatefulWidget {
  static const name = 'tv-serie-screen';
  final String tvSerieId;

  const TvSerieScreen({super.key, required this.tvSerieId});

  @override
  TvSerieScreenState createState() => TvSerieScreenState();
}

class TvSerieScreenState extends ConsumerState<TvSerieScreen> {
  late ScrollController _scrollController;
  bool _showBanner = true;
  @override
  void initState() {
    super.initState();
    ref.read(tvSerieInfoProvider.notifier).loadTvSerie(widget.tvSerieId);
    // ref.read(actorByMovieProvider.notifier).loadActors(widget.tvSerieId);
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
    final TvSerie? tvSerie = ref.watch(tvSerieInfoProvider)[widget.tvSerieId];
    if (tvSerie == null) {
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
            _CustomSliverAppBar(
              tvSerie: tvSerie,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _TvSerieDetails(tvSerie: tvSerie),
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

class _TvSerieDetails extends StatelessWidget {
  final TvSerie tvSerie;
  const _TvSerieDetails({required this.tvSerie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  tvSerie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvSerie.name,
                      style: textStyles.titleLarge,
                    ),
                    Text(
                      tvSerie.overview,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...tvSerie.genres.map((genre) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(genre.name),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

final isFavoriteTvSeriesProvider =
    FutureProvider.family.autoDispose((ref, int tvSerieId) {
  final tvSerieslocalStorageRepository =
      ref.watch(localStorageRepositoryProvider);

  return tvSerieslocalStorageRepository.isTvSerieFavorite(tvSerieId);
});

class _CustomSliverAppBar extends ConsumerStatefulWidget {
  final TvSerie tvSerie;
  const _CustomSliverAppBar({required this.tvSerie});
  @override
  ConsumerState<_CustomSliverAppBar> createState() =>
      _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<_CustomSliverAppBar> {
  bool _showConfirmation = false;
  late Widget confirmationWidget;
  bool isError = false;

  void _toggleFavorite() async {
    if (!mounted) return;

    final tvSerieLocalRepository = ref.read(localStorageRepositoryProvider);

    // Inicializa la variable isCurrentlyFavorite como null en caso de error

    try {
      // Verifica si la película es favorita antes de cambiar el estado
      final isCurrentlyFavorite =
          await tvSerieLocalRepository.isTvSerieFavorite(widget.tvSerie.id);

      // Cambiar el estado de favorito
      await ref
          .read(favoriteMoviesAndSeriesProvider.notifier)
          .toggleFavoriteTvSerie(widget.tvSerie);

      // Aquí es donde refrescamos el estado favorito
      ref.invalidate(isFavoriteTvSeriesProvider(widget.tvSerie.id));

      // Si todo va bien, no hay error
      if (mounted) {
        setState(() {
          confirmationWidget =
              _getFavoriteStatusTextAndIcon(isCurrentlyFavorite, false);
          _showConfirmation = true;
        });
      }

      // Ocultar el mensaje después de 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(
            () {
              _showConfirmation = false;
            },
          );
        }
      });
    } catch (e) {
      // Si ocurre un error, cambia el estado de isError a true
      if (mounted) {
        setState(
          () {
            isError = true;
            confirmationWidget = _getFavoriteStatusTextAndIcon(
                null, true); // El estado es un error
            _showConfirmation = true;
          },
        );
      }

      // Ocultar el mensaje después de 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showConfirmation = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final AsyncValue<bool> isFavoriteFuture =
        ref.watch(isFavoriteTvSeriesProvider(widget.tvSerie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: _toggleFavorite,
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite_rounded, color: Colors.red)
                : const Icon(Icons.favorite_border),
            error: (_, __) => const Icon(Icons.error, color: Colors.red),
            loading: () => const CircularProgressIndicator(strokeWidth: 5),
          ),
        ),
      ],
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            background: Stack(
              children: [
                SizedBox.expand(
                  child: Image.network(
                    widget.tvSerie.posterPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) return const SizedBox();
                      return FadeIn(child: child);
                    },
                  ),
                ),
                const _CustomGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 0.2],
                  colors: [Colors.black54, Colors.transparent],
                ),
                const _CustomGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.8, 1.0],
                  colors: [Colors.transparent, Colors.black54],
                ),
                const _CustomGradient(
                  begin: Alignment.topLeft,
                  stops: [0.0, 0.5],
                  colors: [Colors.black87, Colors.transparent],
                ),
              ],
            ),
          ),
          if (_showConfirmation)
            Positioned(
              top: 40,
              left: 40,
              right: 40,
              child: FadeInUp(
                animate: true,
                duration: const Duration(milliseconds: 1200),
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: confirmationWidget,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Función que maneja el estado favorito o error, devolviendo el texto y el icono adecuados
Widget _getFavoriteStatusTextAndIcon(bool? isCurrentlyFavorite, bool isError) {
  String confirmationText;
  Icon icon;

  if (isError) {
    confirmationText = 'Hubo un error al cambiar el estado de favorito';
    icon = const Icon(
      Icons.error_outline,
      color: Colors.red,
    );
  } else if (isCurrentlyFavorite != null && isCurrentlyFavorite) {
    confirmationText = 'La serie se ha eliminado de favoritos';
    icon = const Icon(
      Icons.remove_circle_rounded,
      color: Colors.red,
    );
  } else {
    confirmationText = 'La serie se añadió correctamente a favoritos';
    icon = const Icon(
      Icons.check_circle_rounded,
      color: Colors.green,
    );
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        confirmationText,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(width: 10),
      icon,
    ],
  );
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin,
    this.end = Alignment.centerRight,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
