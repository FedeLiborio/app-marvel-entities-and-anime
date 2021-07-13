import 'package:equatable/equatable.dart';
import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/marvel_response.dart';


abstract class ListCharactersFavState extends Equatable{
  List<Character> characterFavsResults;

  @override
  List<Object> get props => [];
}

class ListCharactersFavIntialState extends ListCharactersFavState {}

class ListCharactersFavLoadingState extends ListCharactersFavState {}

class ListCharactersFavFailureState extends ListCharactersFavState {
  final String error;

  ListCharactersFavFailureState({this.error});

  @override
  List<Object> get props => [error];

}

class ListCharactersFavLoadedState extends ListCharactersFavState {
  List<MarvelResponse<Character>> listaCharacters;

  ListCharactersFavLoadedState({this.listaCharacters});

  @override
  List<Object> get props => [listaCharacters];
}