import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_animes_favs/list_animes_favs_events.dart';
import 'package:actividad_05/bloc/list_animes_favs/list_animes_favs_state.dart';

class ListAnimesFavBloc extends Bloc<ListAnimesFavEvents, ListAnimesFavState>{

  ListAnimesFavBloc():
        super(ListAnimesFavIntialState());

  @override
  Stream<ListAnimesFavState> mapEventToState(ListAnimesFavEvents event) async*{
    if(event is ListAnimesFavShow){
      yield* _listAnimesFavShow();
    }
  }

  final String queryAnimesFavs = """
    query(\$ids: [Int]){
      Page{
        media(id_in: \$ids){
          id
          title {
            userPreferred
          }
          coverImage {
            large
          }
        }
      }
    }
  """;

  Stream<ListAnimesFavState> _listAnimesFavShow() async*{
    yield ListAnimesFavLoadingState();
    try{
      Map<String, List> media;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String favouriteAnimes = prefs.getString('favouriteAnimes') ?? '[]';

      List<dynamic> animeFavourites = json.decode(favouriteAnimes);

      // todo: mover todas las conexiones a otro archivo
      final _httpLink = HttpLink(
        'https://graphql.anilist.co',
      );

      final GraphQLClient client = GraphQLClient(
        /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(),
        link: _httpLink,
      );

      final QueryOptions options = QueryOptions(
        document: gql(queryAnimesFavs),
        variables: <String, dynamic>{
          "ids": animeFavourites
        },
      );

      final QueryResult result = await client.query(options);

      yield ListAnimesFavLoadedState(listaAnimes: result);
    }catch (e){
      yield ListAnimesFavFailureState(error: e.toString());
    }
  }
}