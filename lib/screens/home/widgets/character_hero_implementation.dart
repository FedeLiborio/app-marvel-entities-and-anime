import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/widgets/thumb_hero.dart';
import 'package:flutter/material.dart';

class CharacterHeroImplementation extends StatelessWidget {
  const CharacterHeroImplementation({Key key, this.character}) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(0,4),
            blurRadius: 10,
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(character.thumbnail.getSizedThumb(ThumbnailSize.LANDSCAPE_XLARGE)),
            fit: BoxFit.fill,
        ),
      ),

      width: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_XLARGE].width,
      height: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_XLARGE].height,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black12
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.center,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              character.name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
