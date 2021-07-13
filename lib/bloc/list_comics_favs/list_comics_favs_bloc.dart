import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_events.dart';
import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_state.dart';
import 'package:actividad_05/models/comic.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/services/marvel_api_service.dart';

class ListComicsFavBloc extends Bloc<ListComicsFavEvents, ListComicsFavState>{

  ListComicsFavBloc():
        super(ListComicsFavIntialState());

  @override
  Stream<ListComicsFavState> mapEventToState(ListComicsFavEvents event) async*{
    if(event is ListComicsFavShow){
      yield* _listComicsFavShow();
    }
  }

  Stream<ListComicsFavState> _listComicsFavShow() async*{
    yield ListComicsFavLoadingState();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String favouriteComics = prefs.getString('favouriteComics') ?? '[]';

      List<dynamic> comicFavourites = json.decode(favouriteComics);

      List<MarvelResponse<Comic>> comics = [];

      for (int element in comicFavourites){
        comics.add(await MarvelApiService().getComic(element));
      }

      yield ListComicsFavLoadedState(listaComics: comics);
    }catch (e){
      yield ListComicsFavFailureState(error: e.toString());
    }
  }
}