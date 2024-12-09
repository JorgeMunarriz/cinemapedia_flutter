import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/domain_barrel.dart';

class TvSeriePosterlink extends StatelessWidget {
  final TvSerie tvSerie;

  const TvSeriePosterlink({super.key, required this.tvSerie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      animate: true,
      duration: const Duration(milliseconds: 800),
      child: GestureDetector(
        onTap: () => context.push('/home/0/serie/${tvSerie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeIn(child: Image.network(tvSerie.posterPath)),
        ),
      ),
    );
  }
}
