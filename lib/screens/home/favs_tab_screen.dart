import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:actividad_05/bloc/list_animes_favs/list_animes_favs_bloc.dart';
import 'package:actividad_05/bloc/list_animes_favs/list_animes_favs_state.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_bloc.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_events.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_state.dart';
import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_bloc.dart';
import 'package:actividad_05/bloc/list_comics_favs/list_comics_favs_state.dart';
import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_bloc.dart';
import 'package:actividad_05/bloc/list_creators_favs/list_creators_favs_state.dart';
import 'package:actividad_05/bloc/list_events_favs/list_events_favs_bloc.dart';
import 'package:actividad_05/bloc/list_events_favs/list_events_favs_state.dart';
import 'package:actividad_05/bloc/list_series_favs/list_series_favs_bloc.dart';
import 'package:actividad_05/bloc/list_series_favs/list_series_favs_state.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/screens/home/anime_tab_screen.dart';
import 'package:actividad_05/screens/home/widgets/character_hero.dart';
import 'package:actividad_05/screens/home/widgets/serie_hero.dart';
import 'package:actividad_05/widgets/text_with_icon.dart';
import 'package:actividad_05/widgets/thumb_hero.dart';

import '../../routes.dart';

class FavsTabScreen extends StatefulWidget {
  const FavsTabScreen({Key key}) : super(key: key);

  @override
  _FavsTabScreenState createState() => _FavsTabScreenState();
}

class _FavsTabScreenState extends State<FavsTabScreen> {

  //Devuelve un container para mostrar los characters favoritos
  Container containerBlocCharacters(){
    return Container(
      height: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_XLARGE].height,
      child: BlocBuilder<ListCharactersFavBloc, ListCharactersFavState>(
          builder: (context, state){
            if(state is ListCharactersFavLoadedState){
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.listaCharacters.length,
                  itemBuilder: (BuildContext context, index){
                    return CharacterHero(
                      character: state.listaCharacters[index].data.results[0],
                    );
                  }
              );
            }
            if (state is ListCharactersFavFailureState){
              return Text('Ocurrió un error.' + state.error);
            }
            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                )
            );
          }
      ),
    );
  }

  Container containerBlocSeries(){
    return Container(
      height: 70,
        child: BlocBuilder<ListSeriesFavBloc, ListSeriesFavState>(
          builder: (context, state){
            if(state is ListSeriesFavLoadedState){
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.listaSeries.length,
                itemBuilder: (BuildContext context, index){
                  return SerieHero(serie: state.listaSeries[index].data.results[0]);
                },
              );
            }
            if (state is ListSeriesFavFailureState){
              print('hubo error');
              return Text('Ocurrió un error.' + state.error);
            }
            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                )
            );
          }
        ),
    );
  }

  // No use LabeledImageList porque prefería que se vea siempre el TextWithIcon
  //
  // El codigo se va a repetir en el container de Events, Creators y probablemente animes.
  // TODO: CONVERTIR EL CODIGO REPETIDO EN UN WIDGET
  Container containerBlocComics(){
    return Container(
      height: thumbnailSizeDimensions[ThumbnailSize.PORTRAIT_MEDIUM].height,
      child: BlocBuilder<ListComicsFavBloc, ListComicsFavState>(
        builder: (context, state){
          if(state is ListComicsFavLoadedState){
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.listaComics.length,
              itemBuilder: (BuildContext context, index){
                return GestureDetector(
                  onTap:() => Navigator.pushNamed(
                    context, ROUTE_NAMES['COMIC_DETAIL'],
                    arguments: state.listaComics[index].data.results[0]
                  ),
                  child: ThumbHero(
                    thumb: state.listaComics[index].data.results
                        .map<Thumbnail>((item) => item.thumbnail)
                        .toList()[0],
                  ),
                );
              },
            );
          }
          if (state is ListComicsFavFailureState){
            return Text('Ocurrió un error.' + state.error);
          }
          return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              )
          );
        }
      ),
    );
  }

  Container containerBlocEvents(){
    return Container(
      height: thumbnailSizeDimensions[ThumbnailSize.PORTRAIT_MEDIUM].height,
      child: BlocBuilder<ListEventsFavBloc, ListEventsFavState>(
        builder: (context, state){
          if(state is ListEventsFavLoadedState){
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.listaEvents.length,
              itemBuilder: (BuildContext context, index){
                return GestureDetector(
                  onTap:() => Navigator.pushNamed(
                      context, ROUTE_NAMES['EVENT_DETAIL'],
                      arguments: state.listaEvents[index].data.results[0]
                  ),
                  child: ThumbHero(
                    thumb: state.listaEvents[index].data.results
                        .map<Thumbnail>((item) => item.thumbnail)
                        .toList()[0],
                  ),
                );
              },
            );
          }
          if (state is ListEventsFavFailureState){
            return Text('Ocurrió un error.' + state.error);
          }
          return Center(
              child: CircularProgressIndicator(strokeWidth: 2)
          );
        }
      ),
    );
  }

  Container containerBlocCreators(){
    return Container(
      height: thumbnailSizeDimensions[ThumbnailSize.PORTRAIT_MEDIUM].height,
      child: BlocBuilder<ListCreatorsFavBloc, ListCreatorsFavState>(
        builder: (context, state){
        if(state is ListCreatorsFavLoadedState){
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.listaCreators.length,
            itemBuilder: (BuildContext context, index){
              return GestureDetector(
                onTap:() => Navigator.pushNamed(
                    context, ROUTE_NAMES['CREATOR_DETAIL'],
                    arguments: state.listaCreators[index].data.results[0]
                ),
                child: ThumbHero(
                  thumb: state.listaCreators[index].data.results
                      .map<Thumbnail>((item) => item.thumbnail)
                      .toList()[0],
                ),
              );
            },
          );
        }
        if (state is ListCreatorsFavFailureState){
          return Text('Ocurrió un error.' + state.error);
        }
        return Center(
            child: CircularProgressIndicator(strokeWidth: 2)
          );
        }
      )
    );
  }

  Container containerBlocAnimes(){
    return Container(
      height: 240,
      child: BlocBuilder<ListAnimesFavBloc, ListAnimesFavState>(
        builder: (context, state){
          if(state is ListAnimesFavLoadedState){
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.listaAnimes.data['Page']['media'].length,
              itemBuilder: (BuildContext context, index){
                return GestureDetector(
                  onTap:() => Navigator.pushNamed(
                      context, ROUTE_NAMES['ANIME_DETAIL'],
                      arguments: state.listaAnimes.data['Page']['media'][index]
                  ),
                  child: AnimeCard(
                    media: state.listaAnimes.data['Page']['media'][index],
                  )
                );
              },
            );
          }
          if (state is ListAnimesFavFailureState){
            return Text('Ocurrió un error.' + state.error);
          }
          return Center(
              child: CircularProgressIndicator(strokeWidth: 2)
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextWithIcon(label: 'Characters'),
        containerBlocCharacters(),
        TextWithIcon(label: 'Series'),
        containerBlocSeries(),
        TextWithIcon(label: 'Comics'),
        containerBlocComics(),
        TextWithIcon(label: 'Events'),
        containerBlocEvents(),
        TextWithIcon(label: 'Creators'),
        containerBlocCreators(),
        TextWithIcon(label: 'Animes'),
        containerBlocAnimes(),
      ],
    );
  }
}


/*
class FavsTabScreen1 extends StatelessWidget {
  const FavsTabScreen1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('me dibujo');
    final _listCharacterFavsBloc = BlocProvider.of<ListCharactersFavBloc>(context);
    _listCharacterFavsBloc.add(ListCharactersFavShow());
    return ListView(
      children: [
        TextWithIcon(label: 'Characters'),

        Container(
          height: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_XLARGE].height,
          child: BlocBuilder<ListCharactersFavBloc, ListCharactersFavState>(
            builder: (context, state){
              if(state is ListCharactersFavLoadedState){
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.listaCharacters.data.results.length,
                    itemBuilder: (BuildContext context, index){
                      return CharacterHero(
                        character: state.listaCharacters.data.results[index],
                      );
                    }
                );
              }
              if (state is ListCharactersFavFailureState){
                print('hubo error');
                return Text('Ocurrió un error.' + state.error);
              }
              return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )
              );
            }
          ),
        ),
        TextWithIcon(label: 'Series'),
        TextWithIcon(label: 'Comics'),
        TextWithIcon(label: 'Events'),
        TextWithIcon(label: 'Creators'),
        TextWithIcon(label: 'Animes'),
      ],
    );
  }
}

 */