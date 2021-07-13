import 'dart:convert';

import 'package:actividad_05/bloc/list_series_favs/list_series_favs_events.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_series_favs/list_series_favs_bloc.dart';
import 'package:actividad_05/models/serie.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/screens/character_detail/character_releated_content.dart';
import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/attribution.dart';
import 'package:actividad_05/widgets/detail_hero_with_back_btn.dart';
import 'package:actividad_05/widgets/labeled_image_list.dart';
import 'package:actividad_05/widgets/related_content_events.dart';
import 'package:actividad_05/widgets/related_content_characters.dart';
import 'package:actividad_05/widgets/related_content_comics.dart';
import 'package:actividad_05/widgets/related_content_creators.dart';

class SerieDetailScreenImplementation extends StatefulWidget {
  const SerieDetailScreenImplementation({Key key, @required this.serie}) : super(key: key);

  final Serie serie;

  @override
  _SerieDetailScreenImplementationState createState() => _SerieDetailScreenImplementationState();
}

class _SerieDetailScreenImplementationState extends State<SerieDetailScreenImplementation> {

  List<dynamic> favouritedSerieIds = [];

  toggleFavourite(int serieId) => () async {
    final listSeriesFavBloc = BlocProvider.of<ListSeriesFavBloc>(context);

    setState(() {
      if (favouritedSerieIds.indexOf(serieId) >= 0) {
        favouritedSerieIds.remove(serieId);
      } else {
        favouritedSerieIds.add(serieId);
      }
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteSeries =
          prefs.getString('favouriteSeries') ?? '[]';

      print('From sharedProps $favouriteSeries');

      List<dynamic> favouriteSerieIds =
      json.decode(favouriteSeries);

      if (favouriteSerieIds.indexOf(serieId) >= 0) {
        favouriteSerieIds.remove(serieId);
      } else {
        favouriteSerieIds.add(serieId);
      }

      await prefs.setString(
          'favouriteSeries', json.encode(favouriteSerieIds));
      listSeriesFavBloc.add(ListSeriesFavShow());
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  };

  getFavouriteSeries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteSeries =
          prefs.getString('favouriteSeries') ?? '[]';
      List<dynamic> characterSeries = json.decode(favouriteSeries);

      print('From INIT STATE $characterSeries');
      setState(() {
        favouritedSerieIds = characterSeries;
      });
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  }

  @override
  void initState() {
    super.initState();
    getFavouriteSeries();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          DetailHeroWithBackBtn(thumbnail: widget.serie.thumbnail),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed:
                toggleFavourite(widget.serie != null ? widget.serie.id : 0),
                icon: (favouritedSerieIds
                    .indexOf(widget.serie != null ? widget.serie.id : 0) >=
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
                widget.serie.title.toUpperCase(),
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
                    widget.serie.description,
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
              RelatedContentCharacters(futureCharacters: MarvelApiService().getSerieCharactes(widget.serie.id)),
              RelatedContentComics(futureComics: MarvelApiService().getSerieComics(widget.serie.id)),
              RelatedContentEvents(futureMarvelEvents: MarvelApiService().getSerieEvents(widget.serie.id)),
              RelatedContentCreators(futureCreators: MarvelApiService().getSerieCreators(widget.serie.id)),
            ],
          ),
          Attribution(),
        ],
      ),
    );
  }
}
