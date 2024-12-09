import 'package:isar/isar.dart';
part 'genre.g.dart';

@collection
class GenreTv {
  Id? isarId;  

  final int id;
  final String name;

  GenreTv({
    required this.id,
    required this.name,
  });

  factory GenreTv.fromJson(Map<String, dynamic> json) => GenreTv(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
