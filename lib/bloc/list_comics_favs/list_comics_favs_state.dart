import 'package:equatable/equatable.dart';
import 'package:actividad_05/models/comic.dart';
import 'package:actividad_05/models/marvel_response.dart';


abstract class ListComicsFavState extends Equatable{
  List<Comic> comicFavsResults;

  @override
  List<Object> get props => [];
}

class ListComicsFavIntialState extends ListComicsFavState {}

class ListComicsFavLoadingState extends ListComicsFavState {}

class ListComicsFavFailureState extends ListComicsFavState {
  final String error;

  ListComicsFavFailureState({this.error});

  @override
  List<Object> get props => [error];

}

class ListComicsFavLoadedState extends ListComicsFavState {
  List<MarvelResponse<Comic>> listaComics;

  ListComicsFavLoadedState({this.listaComics});

  @override
  List<Object> get props => [listaComics];
}