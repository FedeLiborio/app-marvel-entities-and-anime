import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/related_content_series.dart';
import 'package:actividad_05/widgets/related_content_comics.dart';
import 'package:actividad_05/widgets/related_content_events.dart';
import 'package:flutter/material.dart';
import 'package:actividad_05/models/character.dart';

class CharacterReleatedContentImplementation extends StatelessWidget {
  const CharacterReleatedContentImplementation(
      {Key key, @required this.character}) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RelatedContentSeries(futureSeries: MarvelApiService().getCharacterSeries(character.id)),
        RelatedContentComics(futureComics: MarvelApiService().getCharacterComics(character.id)),
        RelatedContentEvents(futureMarvelEvents: MarvelApiService().getCharacterEvents(character.id))
      ],
    );
  }


}
