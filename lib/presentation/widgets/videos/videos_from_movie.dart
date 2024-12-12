import 'package:cinemapedia/domain/domain_barrel.dart';
import 'package:cinemapedia/presentation/presentation_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider =
    FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(moviesRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});

class VideosFromMovie extends ConsumerWidget {
  final int movieId;
  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesfromVideo = ref.watch(videosFromMovieProvider(movieId));

    return moviesfromVideo.when(
      data: (videos) => _VideoList(videos: videos),
      error: (_, __) => Center(
        child: Text('No se pudo cargar el tráiler'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _VideoList extends StatelessWidget {
  final List<Video> videos;
  const _VideoList({required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            'Videos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _YoutubeVideoPlayes(
            youtubeId: videos.first.youtubeKey, name: videos.first.name)
      ],
    );
  }
}

class _YoutubeVideoPlayes extends StatefulWidget {
  final String youtubeId;
  final String name;
  const _YoutubeVideoPlayes({required this.youtubeId, required this.name});

  @override
  State<_YoutubeVideoPlayes> createState() => _YoutubeVideoPlayesState();
}

class _YoutubeVideoPlayesState extends State<_YoutubeVideoPlayes> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget.youtubeId,
        flags: const YoutubePlayerFlags(
          hideThumbnail: true,
          showLiveFullscreenButton: false,
          mute: false,
          autoPlay: false,
          disableDragSeek: true,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: false,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name),
          SizedBox(
            height: 10,
          ),
          YoutubePlayer(controller: _controller)
        ],
      ),
    );
  }
}
