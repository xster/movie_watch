import 'package:http/http.dart';

import 'key.dart';

class MovieDatabase {
  MovieDatabase(this.apiKey);

  final String apiKey;

  static MovieDatabase _instance;
  static MovieDatabase get instance => _instance ?? new MovieDatabase(developmentKey);

}