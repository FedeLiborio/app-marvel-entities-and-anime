import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actividad_05/bloc/list_series_favs/list_series_favs_events.dart';
import 'package:actividad_05/bloc/list_series_favs/list_series_favs_state.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/models/serie.dart';
import 'package:actividad_05/services/marvel_api_service.dart';

class ListSeriesFavBloc extends Bloc<ListSeriesFavEvents, ListSeriesFavState>{

  ListSeriesFavBloc():
        super(ListSeriesFavIntialState());

  @override
  Stream<ListSeriesFavState> mapEventToState(ListSeriesFavEvents event) async*{
    if(event is ListSeriesFavShow){
      yield* _listSeriesFavShow();
    }
  }

  Stream<ListSeriesFavState> _listSeriesFavShow() async*{
    yield ListSeriesFavLoadingState();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String favouriteSeries = prefs.getString('favouriteSeries') ?? '[]';

      List<dynamic> serieFavourites = json.decode(favouriteSeries);

      List<MarvelResponse<Serie>> series = [];

      for(int element in serieFavourites){
        series.add(await MarvelApiService().getSerie(element));
      }

      yield ListSeriesFavLoadedState(listaSeries: series);
    }catch (e){
      yield ListSeriesFavFailureState(error: e.toString());
    }
  }
}