import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_events_favs/list_events_favs_events.dart';
import 'package:actividad_05/bloc/list_events_favs/list_events_favs_state.dart';
import 'package:actividad_05/models/marvel_event.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/services/marvel_api_service.dart';

class ListEventsFavBloc extends Bloc<ListEventsFavEvents, ListEventsFavState>{

  ListEventsFavBloc():
        super(ListEventsFavIntialState());

  @override
  Stream<ListEventsFavState> mapEventToState(ListEventsFavEvents event) async*{
    if(event is ListEventsFavShow){
      yield* _listEventsFavShow();
    }
  }

  Stream<ListEventsFavState> _listEventsFavShow() async*{
    yield ListEventsFavLoadingState();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String favouriteEvents = prefs.getString('favouriteEvents') ?? '[]';

      List<dynamic> eventFavourites = json.decode(favouriteEvents);

      List<MarvelResponse<MarvelEvent>> events = [];

      for (int element in eventFavourites){
        events.add(await MarvelApiService().getEvent(element));
      }
      yield ListEventsFavLoadedState(listaEvents: events);
    }catch (e){
      yield ListEventsFavFailureState(error: e.toString());
    }
  }

}