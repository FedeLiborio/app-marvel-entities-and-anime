import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_events_favs/list_events_favs_bloc.dart';
import 'package:actividad_05/bloc/list_events_favs/list_events_favs_events.dart';
import 'package:actividad_05/models/marvel_event.dart';
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
import 'package:actividad_05/widgets/related_content_series.dart';

class EventDetailScreenImplementation extends StatefulWidget {
  const EventDetailScreenImplementation({Key key, @required this.event}) : super(key: key);

  final MarvelEvent event;

  @override
  _EventDetailScreenImplementationState createState() => _EventDetailScreenImplementationState();
}

class _EventDetailScreenImplementationState extends State<EventDetailScreenImplementation> {
  List<dynamic> favouritedMarvelEventIds = [];

  toggleFavourite(int marvelEventId) => () async {
    final listEventsFavBloc = BlocProvider.of<ListEventsFavBloc>(context);

    setState(() {
      if (favouritedMarvelEventIds.indexOf(marvelEventId) >= 0) {
        favouritedMarvelEventIds.remove(marvelEventId);
      } else {
        favouritedMarvelEventIds.add(marvelEventId);
      }
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteMarvelEvents =
          prefs.getString('favouriteEvents') ?? '[]';

      print('From sharedProps $favouriteMarvelEvents');

      List<dynamic> favouriteMarvelEventIds =
      json.decode(favouriteMarvelEvents);

      if (favouriteMarvelEventIds.indexOf(marvelEventId) >= 0) {
        favouriteMarvelEventIds.remove(marvelEventId);
      } else {
        favouriteMarvelEventIds.add(marvelEventId);
      }

      await prefs.setString(
          'favouriteEvents', json.encode(favouriteMarvelEventIds));
      listEventsFavBloc.add(ListEventsFavShow());
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  };

  getFavouriteMarvelEvents() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteMarvelEvents =
          prefs.getString('favouriteEvents') ?? '[]';
      List<dynamic> characterSeries = json.decode(favouriteMarvelEvents);

      print('From INIT STATE $characterSeries');
      setState(() {
        favouritedMarvelEventIds = characterSeries;
      });
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  }

  @override
  void initState() {
    super.initState();
    getFavouriteMarvelEvents();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          DetailHeroWithBackBtn(thumbnail: widget.event.thumbnail),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed:
                toggleFavourite(widget.event != null ? widget.event.id : 0),
                icon: (favouritedMarvelEventIds
                    .indexOf(widget.event != null ? widget.event.id : 0) >=
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
                widget.event.title.toUpperCase(),
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
                    widget.event.description,
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
              RelatedContentCharacters(futureCharacters: MarvelApiService().getEventCharactes(widget.event.id)),
              RelatedContentSeries(futureSeries: MarvelApiService().getEventSeries(widget.event.id)),
              RelatedContentComics(futureComics: MarvelApiService().getEventComics(widget.event.id)),
              RelatedContentCreators(futureCreators: MarvelApiService().getEventCreators(widget.event.id)),
            ],
          ),
          Attribution(),
        ],
      ),
    );
  }
}
