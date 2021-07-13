import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/routes.dart';
import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/labeled_image_list.dart';
import 'package:flutter/material.dart';

class RelatedContentCharacters extends StatelessWidget {

  const RelatedContentCharacters({Key key, @required this.futureCharacters}) : super(key: key);


  final Future<MarvelResponse<Character>> futureCharacters;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MarvelResponse<Character>>(
      future: futureCharacters,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return LabeledImageList(
            onTap: (index) => () {

            },
            label: 'Characters',
            thumbs: snapshot.data.data.results
                .map<Thumbnail>((item) => item.thumbnail)
                .toList(),
          );
        }else if (snapshot.hasError) {
          return Text('ERROR');
        } else {
          return Text('Cargando...');
        }
      },
    );
  }
}
