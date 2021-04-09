class Movie{
  final String imdbID;
  final String poster;
  final String movieTitle;
  final String yearOfRelease;

  Movie({this.imdbID, this.poster, this.movieTitle, this.yearOfRelease});

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(
      imdbID: json["imdbID"],
      poster: json["Poster"],
      movieTitle: json["Title"],
      yearOfRelease: json['Year'],
    );
  }
}
/*
class MovieData{
  final String title;
  final String year;
  final String releaseDate;
  final String runTime;
  final String genre;
  final String actors;
  final String plot;
  final String poster;
  final String imdbRating;

  MovieData({this.title, this.year, this.releaseDate, this.runTime, this.genre, this.actors, this.plot, this.poster, this.imdbRating});

  factory MovieData.fromJson(dynamic json){
    return MovieData(
      title: json["Title"],
      year: json["Year"],
      plot: json["Plot"],
    );
  }

}
*/