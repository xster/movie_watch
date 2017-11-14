import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'key.dart';

class MovieDatabase {
  MovieDatabase(this.apiKey) : assert(
    apiKey != null && apiKey.isNotEmpty,
    'You need a real API key in key.dart');

  final String apiKey;

  static MovieDatabase _instance;
  static MovieDatabase get instance => _instance ?? new MovieDatabase(developmentKey);

  Future<ApiResponse> get(String path) async {
    return await new ApiMethod(path, apiKey).get();
  }

  Future<ApiResponse> nowPlaying() async => get('movie/now_playing');
}

class ApiMethod {
  static const String baseUrl = 'https://api.themoviedb.org/3/';

  ApiMethod(this.path, this.apiKey);

  final String path;
  final String apiKey;

  Future<ApiResponse> get() async {
    http.Response response = await http.get(new Uri.https(
      'api.themoviedb.org',
      '3/' + path,
      {'api_key': apiKey}));

    return new ApiResponse(response.statusCode, response.body);
  }
}

class ApiResponse {
  ApiResponse(this.status, this.responseString);

  final int status;
  final String responseString;

  Map<String, dynamic> _json;
  Map<String, dynamic> get response => _json ?? JSON.decode(responseString);
}

class ApiPosterImage extends NetworkImage {
  ApiPosterImage(posterPath) : super(baseUrl + posterPath);

  static const String baseUrl = 'https://image.tmdb.org/t/p/w500';
}
