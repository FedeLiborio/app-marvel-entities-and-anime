import 'package:actividad_05/models/serie.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:equatable/equatable.dart';

abstract class ListSeriesFavState extends Equatable{
  List<Serie> serieFavsResults;

  @override
  List<Object> get props => [];
}

class ListSeriesFavIntialState extends ListSeriesFavState {}

class ListSeriesFavLoadingState extends ListSeriesFavState {}

class ListSeriesFavFailureState extends ListSeriesFavState {
  final String error;

  ListSeriesFavFailureState({this.error});

  @override
  List<Object> get props => [error];

}

class ListSeriesFavLoadedState extends ListSeriesFavState {
  List<MarvelResponse<Serie>> listaSeries;

  ListSeriesFavLoadedState({this.listaSeries});

  @override
  List<Object> get props => [listaSeries];
}