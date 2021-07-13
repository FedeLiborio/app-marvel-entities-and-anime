import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_bloc.dart';
import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_events.dart';
import 'package:actividad_05/models/comic.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/screens/character_detail/character_releated_content.dart';
import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/attribution.dart';
import 'package:actividad_05/widgets/detail_hero_with_back_btn.dart';
import 'package:actividad_05/widgets/labeled_image_list.dart';
import 'package:actividad_05/widgets/related_content_characters.dart';
import 'package:actividad_05/widgets/related_content_comics.dart';
import 'package:actividad_05/widgets/related_content_creators.dart';
import 'package:actividad_05/widgets/related_content_events.dart';

class ComicDetailScreenImplementation extends StatefulWidget {
  const ComicDetailScreenImplementation({Key key, @required this.comic}) : super(key: key);

  final Comic comic;

  @override
  _ComicDetailScreenImplementationState createState() => _ComicDetailScreenImplementationState();
}

class _ComicDetailScreenImplementationState extends State<ComicDetailScreenImplementation> {
  List<dynamic> favouritedComicIds = [];

  toggleFavourite(int comicId) => () async {
    final listComicsFavBloc = BlocProvider.of<ListComicsFavBloc>(context);

    setState(() {
      if (favouritedComicIds.indexOf(comicId) >= 0) {
        favouritedComicIds.remove(comicId);
      } else {
        favouritedComicIds.add(comicId);
      }
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteComics =
          prefs.getString('favouriteComics') ?? '[]';

      print('From sharedProps $favouriteComics');

      List<dynamic> favouriteComicIds =
      json.decode(favouriteComics);

      if (favouriteComicIds.indexOf(comicId) >= 0) {
        favouriteComicIds.remove(comicId);
      } else {
        favouriteComicIds.add(comicId);
      }

      await prefs.setString(
          'favouriteComics', json.encode(favouriteComicIds));
      listComicsFavBloc.add(ListComicsFavShow());
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  };

  getFavouriteComics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteComics =
          prefs.getString('favouriteComics') ?? '[]';
      List<dynamic> characterSeries = json.decode(favouriteComics);

      print('From INIT STATE $characterSeries');
      setState(() {
        favouritedComicIds = characterSeries;
      });
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  }

  @override
  void initState() {
    super.initState();
    getFavouriteComics();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          DetailHeroWithBackBtn(thumbnail: widget.comic.thumbnail),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed:
                toggleFavourite(widget.comic != null ? widget.comic.id : 0),
                icon: (favouritedComicIds
                    .indexOf(widget.comic != null ? widget.comic.id : 0) >=
                    0)
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_outline),
                iconSize: 40.0,
                color: Colors.black,
              ),
              IconButton(
                onPressed: () => print('Share'),
                icon: Icon(Icons.share),
                iconSize: 35.0,
                color: Colors.black,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.comic.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.0),
              Text(
                '⭐ ⭐ ⭐ ⭐ ⭐',
                style: TextStyle(fontSize: 25.0),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                height: 120.0,
                child: SingleChildScrollView(
                  child: Text(
                    widget.comic.description,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'RELATED CONTENT',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Column(
            children: [
              RelatedContentCharacters(futureCharacters: MarvelApiService().getComicCharactes(widget.comic.id)),
              RelatedContentEvents(futureMarvelEvents: MarvelApiService().getComicEvents(widget.comic.id)),
              RelatedContentCreators(futureCreators: MarvelApiService().getComicCreators(widget.comic.id)),
            ],
          ),
          Attribution(),
        ],
      ),
    );
  }
}
