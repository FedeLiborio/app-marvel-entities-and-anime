import 'dart:convert';
import 'package:flutter/material.dart';

class Thumbnail {
  Thumbnail({
    this.path,
    this.extension,
  });

  String path;
  String extension;

  getSizedThumb(ThumbnailSize thumbnailSize) =>
      '$path/${thumbnailSizeValues[thumbnailSize]}.$extension'
          .replaceAll('http', 'https');

  factory Thumbnail.fromRawJson(String str) =>
      Thumbnail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        path: json["path"],
        extension: json["extension"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "extension": extension,
      };
}

enum ThumbnailSize {
  PORTRAIT_SMALL,
  PORTRAIT_MEDIUM,
  PORTRAIT_XLARGE,
  PORTRAIT_FANTASTIC,
  PORTRAIT_UNCANNY,
  PORTRAIT_INCREDIBLE,
  STANDARD_SMALL,
  STANDARD_MEDIUM,
  STANDARD_LARGE,
  STANDARD_XLARGE,
  STANDARD_FANTASTIC,
  STANDARD_AMAZING,
  LANDSCAPE_SMALL,
  LANDSCAPE_MEDIUM,
  LANDSCAPE_LARGE,
  LANDSCAPE_XLARGE,
  LANDSCAPE_AMAZING,
  LANDSCAPE_INCREDIBLE,
  DETAIL,
  FULL,
}

final Map<ThumbnailSize, String> thumbnailSizeValues = {
  ThumbnailSize.PORTRAIT_SMALL: "portrait_small",
  ThumbnailSize.PORTRAIT_MEDIUM: "portrait_medium",
  ThumbnailSize.PORTRAIT_XLARGE: "portrait_xlarge",
  ThumbnailSize.PORTRAIT_FANTASTIC: "portrait_fantastic",
  ThumbnailSize.PORTRAIT_UNCANNY: "portrait_uncanny",
  ThumbnailSize.PORTRAIT_INCREDIBLE: "portrait_incredible",
  ThumbnailSize.STANDARD_SMALL: "standard_small",
  ThumbnailSize.STANDARD_MEDIUM: "standard_medium",
  ThumbnailSize.STANDARD_LARGE: "standard_large",
  ThumbnailSize.STANDARD_XLARGE: "standard_xlarge",
  ThumbnailSize.STANDARD_FANTASTIC: "standard_fantastic",
  ThumbnailSize.STANDARD_AMAZING: "standard_amazing",
  ThumbnailSize.LANDSCAPE_SMALL: "landscape_small",
  ThumbnailSize.LANDSCAPE_MEDIUM: "landscape_medium",
  ThumbnailSize.LANDSCAPE_LARGE: "landscape_large",
  ThumbnailSize.LANDSCAPE_XLARGE: "landscape_xlarge",
  ThumbnailSize.LANDSCAPE_AMAZING: "landscape_amazing",
  ThumbnailSize.LANDSCAPE_INCREDIBLE: "landscape_incredible",
  ThumbnailSize.DETAIL: "detail",
  ThumbnailSize.FULL: "full-size",
};

final Map<ThumbnailSize, Size> thumbnailSizeDimensions = {
  ThumbnailSize.PORTRAIT_SMALL: Size(50, 75),
  ThumbnailSize.PORTRAIT_MEDIUM: Size(100, 150),
  ThumbnailSize.PORTRAIT_XLARGE: Size(150, 225),
  ThumbnailSize.PORTRAIT_FANTASTIC: Size(168, 252),
  ThumbnailSize.PORTRAIT_UNCANNY: Size(300, 450),
  ThumbnailSize.PORTRAIT_INCREDIBLE: Size(216, 324),
  ThumbnailSize.STANDARD_SMALL: Size(65, 45),
  ThumbnailSize.STANDARD_MEDIUM: Size(100, 100),
  ThumbnailSize.STANDARD_LARGE: Size(140, 140),
  ThumbnailSize.STANDARD_XLARGE: Size(200, 200),
  ThumbnailSize.STANDARD_FANTASTIC: Size(250, 250),
  ThumbnailSize.STANDARD_AMAZING: Size(180, 180),
  ThumbnailSize.LANDSCAPE_SMALL: Size(120, 90),
  ThumbnailSize.LANDSCAPE_MEDIUM: Size(175, 130),
  ThumbnailSize.LANDSCAPE_LARGE: Size(190, 140),
  ThumbnailSize.LANDSCAPE_XLARGE: Size(270, 200),
  ThumbnailSize.LANDSCAPE_AMAZING: Size(250, 156),
  ThumbnailSize.LANDSCAPE_INCREDIBLE: Size(464, 261),
  ThumbnailSize.DETAIL: null,
  ThumbnailSize.FULL: null,
};
