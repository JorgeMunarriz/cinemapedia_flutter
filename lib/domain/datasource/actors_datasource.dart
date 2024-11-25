import 'package:cinemapedia/domain/domain_barrel.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId);
  
}
