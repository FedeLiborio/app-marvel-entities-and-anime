import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_events.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_state.dart';
import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/services/marvel_api_service.dart';

class ListCharactersFavBloc extends Bloc<ListCharactersFavEvents, ListCharactersFavState>{

  ListCharactersFavBloc():
        super(ListCharactersFavIntialState());

  @override
  Stream<ListCharactersFavState> mapEventToState(ListCharactersFavEvents event) async*{
    if(event is ListCharactersFavShow){
      yield* _listCharactersFavShow();
    }
  }

  Stream<ListCharactersFavState> _listCharactersFavShow() async*{
    yield ListCharactersFavLoadingState();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String favouriteCharacters = prefs.getString('favouriteCharacters') ?? '[]';

      List<dynamic> characterFavourites = json.decode(favouriteCharacters);

      List<MarvelResponse<Character>> characters = [];

      for (int element in characterFavourites){
        characters.add(await MarvelApiService().getCharacter(element));
      }

      yield ListCharactersFavLoadedState(listaCharacters: characters);
    }catch (e){
      yield ListCharactersFavFailureState(error: e.toString());
    }
  }
}