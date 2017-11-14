import 'dart:async';

import 'package:flutter/material.dart';

import 'tmdb/api.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Movie Watch',
      theme: new ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Avenir'),
      home: new Scaffold(
        appBar: new AppBar(title: const Text('Movie Watch')),
        body: new NowPlaying()));
  }
}

class NowPlaying extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> {
  List<Map<String, dynamic>> movies;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<Null> reload() async {
    ApiResponse response = await MovieDatabase.instance.nowPlaying();
    if (response.status != 200) { return; }
    setState(() {
      movies = response.response['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      return new Center(child: new CircularProgressIndicator());
    }

    return new Scrollbar(
      child: new RefreshIndicator(
        onRefresh: reload,
        child: new GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 0.59,
        children: movies.map<Widget>((Map<String, dynamic> movie) {
          return new Card(
            elevation: 3.0,
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    movie['title'],
                    style: const TextStyle(fontSize: 16.0),
                    maxLines: 2),
                  new Image(
                    image: new ApiPosterImage(movie['poster_path']))])));
          }).toList()),
        ));
  }
}
