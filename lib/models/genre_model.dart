class Genre {
  int genreId;
  String name;

  Genre({
    required this.genreId,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      genreId: json['genre_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genre_id': genreId,
      'name': name,
    };
  }
}
