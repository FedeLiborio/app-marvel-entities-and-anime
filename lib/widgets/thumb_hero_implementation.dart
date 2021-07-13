import 'package:flutter/material.dart';
import 'package:actividad_05/models/thumbnail.dart';

class ThumbHeroImplementation extends StatelessWidget {
  const ThumbHeroImplementation({Key key,
    @required this.thumb,
  }) : super(key: key);

  final Thumbnail thumb;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0,4),
            blurRadius: 6,
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(thumb.getSizedThumb(ThumbnailSize.PORTRAIT_UNCANNY)),
          fit: BoxFit.fill,
        ),
      ),
      width: thumbnailSizeDimensions[ThumbnailSize.PORTRAIT_MEDIUM].width,
      height: thumbnailSizeDimensions[ThumbnailSize.PORTRAIT_MEDIUM].height,
      margin: EdgeInsets.all(10),
    );
  }
}
