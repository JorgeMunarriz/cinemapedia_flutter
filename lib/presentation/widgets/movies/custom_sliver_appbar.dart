import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSliverAppBar extends ConsumerStatefulWidget {
  final Movie movie;
  const CustomSliverAppBar({super.key, required this.movie});
  @override
  ConsumerState<CustomSliverAppBar> createState() => CustomSliverAppBarState();
}

class CustomSliverAppBarState extends ConsumerState<CustomSliverAppBar> {
  bool _showConfirmation = false;
  late Widget confirmationWidget;
  bool isError = false;

  //   });
  // }
  void _toggleFavorite() async {
    if (!mounted) return;

    final localStorageRepository = ref.read(localStorageRepositoryProvider);

    // Inicializa la variable isCurrentlyFavorite como null en caso de error
    bool? isCurrentlyFavorite;

    try {
      // Verifica si la película es favorita antes de cambiar el estado
      isCurrentlyFavorite =
          await localStorageRepository.isMovieFavorite(widget.movie.id);

      // Cambiar el estado de favorito
      await ref
          .read(favoriteMoviesAndSeriesProvider.notifier)
          .toggleFavorite(widget.movie);

      // Sincronizar el estado de favoritos en isFavoriteProvider
      ref.invalidate(isFavoriteProvider(
          widget.movie.id)); // O bien recargar con ref.refresh

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
          setState(() {
            _showConfirmation = false;
          });
        }
      });
    } catch (e) {
      // Si ocurre un error, cambia el estado de isError a true
      if (mounted) {
        setState(() {
          isError = true;
          confirmationWidget = _getFavoriteStatusTextAndIcon(
              null, true); // El estado es un error
          _showConfirmation = true;
        });
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
        ref.watch(isFavoriteProvider(widget.movie.id));

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
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
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
                    widget.movie.posterPath,
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
                  begin: Alignment.topLeft,
                  stops: [0.0, 0.3],
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
                    height: 150,
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
    confirmationText = 'La película se ha eliminado de favoritos';
    icon = const Icon(
      Icons.remove_circle_rounded,
      color: Colors.red,
    );
  } else {
    confirmationText = 'La película se añadió correctamente a favoritos';
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
