import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:actividad_05/bloc/list_animes_favs/list_animes_favs_bloc.dart';
import 'package:actividad_05/bloc/list_animes_favs/list_animes_favs_events.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_bloc.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_events.dart';
import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_bloc.dart';
import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_events.dart';
import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_bloc.dart';
import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_events.dart';
import 'package:actividad_05/bloc/list_events_favs/list_events_favs_bloc.dart';
import 'package:actividad_05/bloc/list_events_favs/list_events_favs_events.dart';
import 'package:actividad_05/bloc/list_series_favs/list_series_favs_bloc.dart';
import 'package:actividad_05/bloc/list_series_favs/list_series_favs_events.dart';
import 'package:actividad_05/routes.dart';
import 'package:actividad_05/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: Link.from([HttpLink('https://graphql.anilist.co')]),
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ListCharactersFavBloc>(
              create: (BuildContext context) => ListCharactersFavBloc()..add(ListCharactersFavShow()),
            ),
            BlocProvider<ListSeriesFavBloc>(
              create: (BuildContext context) => ListSeriesFavBloc()..add(ListSeriesFavShow()),
            ),
            BlocProvider<ListComicsFavBloc>(
              create: (BuildContext context) => ListComicsFavBloc()..add(ListComicsFavShow()),
            ),
            BlocProvider<ListEventsFavBloc>(
              create: (BuildContext context) => ListEventsFavBloc()..add(ListEventsFavShow()),
            ),
            BlocProvider<ListCreatorsFavBloc>(
              create: (BuildContext context) => ListCreatorsFavBloc()..add(ListCreatorsFavShow()),
            ),
            BlocProvider<ListAnimesFavBloc>(
              create: (BuildContext context) => ListAnimesFavBloc()..add(ListAnimesFavShow()),
            ),
          ],
          child: MaterialApp(
            title: 'MyComAni',
            theme: ThemeData(primaryColor: Colors.red),
            routes: routes,
            initialRoute: ROUTE_NAMES['HOME'],
          )
        ),
    );
  }
}
