import 'package:flutter/material.dart';
import 'package:actividad_05/models/thumbnail.dart';

class DetailHeroWithBackBtnImplementation extends StatelessWidget {
  const DetailHeroWithBackBtnImplementation({Key key, @required this.thumbnail}) : super(key: key);

  final Thumbnail thumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(60, 40),
            bottomRight: Radius.elliptical(60, 40)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(0,4),
            blurRadius: 10,
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(thumbnail.getSizedThumb(ThumbnailSize.LANDSCAPE_XLARGE)),
          fit: BoxFit.cover,
        ),
      ),
      width: double.infinity,
      height: thumbnailSizeDimensions[ThumbnailSize.LANDSCAPE_XLARGE].height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(60, 40),
              bottomRight: Radius.elliptical(60, 40)
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black45,
              Colors.black38.withAlpha(0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            //child: Text('MMMM', ),
          ),
        ),
      ),
    );
  }
}

