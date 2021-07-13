import 'package:equatable/equatable.dart';
import 'package:graphql/client.dart';

abstract class ListAnimesFavState extends Equatable{
  //List<Character> characterFavsResults;

  @override
  List<Object> get props => [];
}

class ListAnimesFavIntialState extends ListAnimesFavState {}

class ListAnimesFavLoadingState extends ListAnimesFavState {}

class ListAnimesFavFailureState extends ListAnimesFavState {
  final String error;

  ListAnimesFavFailureState({this.error});

  @override
  List<Object> get props => [error];

}

class ListAnimesFavLoadedState extends ListAnimesFavState {
  QueryResult listaAnimes;

  ListAnimesFavLoadedState({this.listaAnimes});

  @override
  List<Object> get props => [listaAnimes];
}
