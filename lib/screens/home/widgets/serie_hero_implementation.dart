import 'package:actividad_05/models/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:actividad_05/models/serie.dart';
//import 'package:actividad_05/widgets/thumb_hero.dart';

class SerieHeroImplementation extends StatelessWidget {
  const SerieHeroImplementation({Key key, this.serie}) : super(key: key);

  final Serie serie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade800.withOpacity(0.9),
            offset: Offset(0,2),
            blurRadius: 8,
          )
        ],
        image: DecorationImage(
          image: NetworkImage(serie.thumbnail.getSizedThumb(ThumbnailSize.LANDSCAPE_SMALL)),
          fit: BoxFit.fill,
          // En la documentación de Flutter hablan sobre ColorFilter.matrix y muestran distintas matrices para aplicar filtros
          colorFilter: ColorFilter.matrix(
              [
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]
          ),
        ),
        color: Colors.grey,
      ),
      margin: EdgeInsets.all(10),
      width: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_SMALL].width,
      height: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_SMALL].height,
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.red.shade400.withOpacity(0.9),
              Colors.red.shade800.withOpacity(0.9),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            //alignment: Alignment.center,
            child: Text(
              serie.title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,

              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      /*
        child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                serie.title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      */
    );
  }
}
