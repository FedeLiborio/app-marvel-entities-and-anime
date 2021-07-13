import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_events.dart';
import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_state.dart';
import 'package:actividad_05/models/creator.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/services/marvel_api_service.dart';

class ListCreatorsFavBloc extends Bloc<ListCreatorsFavEvents, ListCreatorsFavState>{

  ListCreatorsFavBloc():
        super(ListCreatorsFavIntialState());

  @override
  Stream<ListCreatorsFavState> mapEventToState(ListCreatorsFavEvents event) async*{
    if(event is ListCreatorsFavShow){
      yield* _listCreatorsFavShow();
    }
  }

  Stream<ListCreatorsFavState> _listCreatorsFavShow() async*{
    yield ListCreatorsFavLoadingState();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String favouriteCreators = prefs.getString('favouriteCreators') ?? '[]';

      List<dynamic> creatorFavourites = json.decode(favouriteCreators);

      List<MarvelResponse<Creator>> creators = [];

      for (int element in creatorFavourites){
        creators.add(await MarvelApiService().getCreator(element));
      }

      yield ListCreatorsFavLoadedState(listaCreators: creators);
    }catch (e){
      yield ListCreatorsFavFailureState(error: e.toString());
    }
  }
}