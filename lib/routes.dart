import 'package:actividad_05/screens/anime_detail_screen.dart';
import 'package:actividad_05/screens/character_detail/character_detail_screen.dart';
import 'package:actividad_05/screens/comic_detail.dart';
import 'package:actividad_05/screens/creator_detail.dart';
import 'package:actividad_05/screens/event_detail.dart';
import 'package:actividad_05/screens/home/home_screen.dart';
import 'package:actividad_05/screens/serie_detail.dart';
import 'package:flutter/widgets.dart';

const Map<String, String> ROUTE_NAMES = {
  'HOME': 'Home',
  'CHARACTER_DETAIL': 'Character Details',
  'SERIE_DETAIL': 'Serie Details',
  'COMIC_DETAIL': 'Comic Details',
  'EVENT_DETAIL': 'Event Details',
  'CREATOR_DETAIL': 'Creator Details',
  'ANIME_DETAIL': 'Anime Details',
};

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  ROUTE_NAMES['HOME']: (BuildContext context) => HomeScreen(),
  ROUTE_NAMES['CHARACTER_DETAIL']: (BuildContext context) =>
      CharacterDetailScreen(),
  ROUTE_NAMES['SERIE_DETAIL']: (BuildContext context) => SerieDetailScreen(),
  ROUTE_NAMES['COMIC_DETAIL']: (BuildContext context) => ComicDetailScreen(),
  ROUTE_NAMES['EVENT_DETAIL']: (BuildContext context) => EventDetailScreen(),
  ROUTE_NAMES['CREATOR_DETAIL']: (BuildContext context) =>
      CreatorDetailScreen(),
  ROUTE_NAMES['ANIME_DETAIL']: (BuildContext context) => AnimeDetailScreen(),
};
