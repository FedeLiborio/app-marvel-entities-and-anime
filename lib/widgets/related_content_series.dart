import 'package:actividad_05/models/serie.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/routes.dart';
import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/labeled_image_list.dart';
import 'package:flutter/material.dart';

class RelatedContentSeries extends StatelessWidget {

  const RelatedContentSeries({Key key, @required this.futureSeries}) : super(key: key);


  final Future<MarvelResponse<Serie>> futureSeries;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MarvelResponse<Serie>>(
      future: futureSeries,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return LabeledImageList(
            onTap: (index) => () {

            },
            label: 'Series',
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
