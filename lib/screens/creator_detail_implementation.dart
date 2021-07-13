import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_bloc.dart';
import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_events.dart';
import 'package:actividad_05/models/creator.dart';
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

class CreatorDetailScreenImplementation extends StatefulWidget {
  const CreatorDetailScreenImplementation({Key key, @required this.creator}) : super(key: key);

  final Creator creator;

  @override
  _CreatorDetailScreenImplementationState createState() => _CreatorDetailScreenImplementationState();
}

class _CreatorDetailScreenImplementationState extends State<CreatorDetailScreenImplementation> {
  List<dynamic> favouritedCreatorIds = [];

  toggleFavourite(int creatorId) => () async {
    final listCreatorsFavBloc = BlocProvider.of<ListCreatorsFavBloc>(context);

    setState(() {
      if (favouritedCreatorIds.indexOf(creatorId) >= 0) {
        favouritedCreatorIds.remove(creatorId);
      } else {
        favouritedCreatorIds.add(creatorId);
      }
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteCreators =
          prefs.getString('favouriteCreators') ?? '[]';

      print('From sharedProps $favouriteCreators');

      List<dynamic> favouriteCreatorIds =
      json.decode(favouriteCreators);

      if (favouriteCreatorIds.indexOf(creatorId) >= 0) {
        favouriteCreatorIds.remove(creatorId);
      } else {
        favouriteCreatorIds.add(creatorId);
      }

      await prefs.setString(
          'favouriteCreators', json.encode(favouriteCreatorIds));
      listCreatorsFavBloc.add(ListCreatorsFavShow());
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  };

  getFavouriteCreators() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteCreators =
          prefs.getString('favouriteCreators') ?? '[]';
      List<dynamic> characterSeries = json.decode(favouriteCreators);

      print('From INIT STATE $characterSeries');
      setState(() {
        favouritedCreatorIds = characterSeries;
      });
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  }

  @override
  void initState() {
    super.initState();
    getFavouriteCreators();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          DetailHeroWithBackBtn(thumbnail: widget.creator.thumbnail),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed:
                toggleFavourite(widget.creator != null ? widget.creator.id : 0),
                icon: (favouritedCreatorIds
                    .indexOf(widget.creator != null ? widget.creator.id : 0) >=
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
                widget.creator.fullName.toUpperCase(),
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
              RelatedContentSeries(futureSeries: MarvelApiService().getCreatorSeries(widget.creator.id)),
              RelatedContentComics(futureComics: MarvelApiService().getCreatorComics(widget.creator.id)),
              RelatedContentEvents(futureMarvelEvents: MarvelApiService().getCreatorEvents(widget.creator.id)),
            ],
          ),
          Attribution(),
        ],
      ),
    );
  }
}
