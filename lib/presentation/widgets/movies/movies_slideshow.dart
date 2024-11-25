import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviesSlideshow extends StatefulWidget {
  final List<Movie> movies;
  const MoviesSlideshow({super.key, required this.movies});

  @override
  State<MoviesSlideshow> createState() => _MoviesSlideshowState();
}

class _MoviesSlideshowState extends State<MoviesSlideshow> {
  final SwiperController _swiperController = SwiperController();

  bool _isAutoplayActive = true;
  Timer? _autoplayTimer;
  int _currentIndex = 0;

  bool _isFirstRender = true;

  void _handleInteraction() {
    _autoplayTimer?.cancel();
    setState(() {
      _isAutoplayActive = false;
      _swiperController.stopAutoplay();
    });
    _autoplayTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isAutoplayActive = true;
        _swiperController.startAutoplay();
      });
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleInteraction,
      onPanUpdate: (_) => _handleInteraction(),
      child: Column(
        children: [
          SizedBox(
            height: 210,
            width: double.infinity,
            child: Swiper(
              controller: _swiperController,
              viewportFraction: 0.8,
              scale: 0.9,
              autoplay: _isAutoplayActive,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.movies.length,
              itemBuilder: (context, index) => _Slide(
                movie: widget.movies[index],
                isFirstRender: _isFirstRender,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 20,
            child: _CustomPagination(
              itemCount: widget.movies.length,
              currentIndex: _currentIndex,
              onDotTapped: (index) {
                _handleInteraction();
                setState(() {
                  _currentIndex = index;
                });
                Future.delayed(
                  Duration.zero,
                  () => _swiperController.move(index),
                );
              },
              activeColor: colors.primary,
              inactiveColor: colors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstRender) {
      _isFirstRender = false;
    }
  }
}

class _CustomPagination extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final void Function(int) onDotTapped;
  final Color activeColor;
  final Color inactiveColor;

  const _CustomPagination({
    required this.itemCount,
    required this.currentIndex,
    required this.onDotTapped,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        return GestureDetector(
          onTap: () {
            onDotTapped(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 15 : 10,
            height: isActive ? 15 : 10,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  final bool isFirstRender;
  const _Slide({required this.movie, required this.isFirstRender});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 10),
        )
      ],
    );
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: DecoratedBox(
          decoration: decoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: isFirstRender
                ? FadeIn(
                    child: Image.network(
                      movie.backdropPath,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.network(
                    movie.backdropPath,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
