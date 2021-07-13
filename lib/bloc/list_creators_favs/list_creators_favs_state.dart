import 'package:equatable/equatable.dart';
import 'package:actividad_05/models/creator.dart';
import 'package:actividad_05/models/marvel_response.dart';


abstract class ListCreatorsFavState extends Equatable{
  List<Creator> creatorFavsResults;

  @override
  List<Object> get props => [];
}

class ListCreatorsFavIntialState extends ListCreatorsFavState {}

class ListCreatorsFavLoadingState extends ListCreatorsFavState {}

class ListCreatorsFavFailureState extends ListCreatorsFavState {
  final String error;

  ListCreatorsFavFailureState({this.error});

  @override
  List<Object> get props => [error];

}

class ListCreatorsFavLoadedState extends ListCreatorsFavState {
  List<MarvelResponse<Creator>> listaCreators;

  ListCreatorsFavLoadedState({this.listaCreators});

  @override
  List<Object> get props => [listaCreators];
}