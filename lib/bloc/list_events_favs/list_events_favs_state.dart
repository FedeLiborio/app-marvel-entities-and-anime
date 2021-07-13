import 'package:equatable/equatable.dart';
import 'package:actividad_05/models/marvel_event.dart';
import 'package:actividad_05/models/marvel_response.dart';


abstract class ListEventsFavState extends Equatable{
  List<MarvelEvent> eventFavsResults;

  @override
  List<Object> get props => [];
}

class ListEventsFavIntialState extends ListEventsFavState {}

class ListEventsFavLoadingState extends ListEventsFavState {}

class ListEventsFavFailureState extends ListEventsFavState {
  final String error;

  ListEventsFavFailureState({this.error});

  @override
  List<Object> get props => [error];

}

class ListEventsFavLoadedState extends ListEventsFavState {
  List<MarvelResponse<MarvelEvent>> listaEvents;

  ListEventsFavLoadedState({this.listaEvents});

  @override
  List<Object> get props => [listaEvents];
}