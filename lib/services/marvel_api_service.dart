import 'dart:convert';

import 'package:actividad_05/contants.dart';
import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/comic.dart';
import 'package:actividad_05/models/creator.dart';
import 'package:actividad_05/models/marvel_event.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/models/serie.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class MarvelApiService {
  static const String MARVEL_API_BASE = "gateway.marvel.com";
  static const String MARVEL_API_VERSION = "/v1/public";
  static const String MARVEL_ATTRIBUTION =
      "Data provided by Marvel. © 2014 Marvel";

  String _generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }

  Uri _buildUri(String path, {Map<String, String> queryParams}) {
    String ts = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String> baseQryParams = {
      "ts": ts,
      "apikey": MARVEL_API_PUBLIC_KEY,
      "hash": _generateMd5(ts + MARVEL_API_PRIVATE_KEY + MARVEL_API_PUBLIC_KEY)
    };
    if (queryParams != null) {
      baseQryParams.addAll(queryParams);
    }
    Uri uri =
        Uri.https(MARVEL_API_BASE, MARVEL_API_VERSION + path, baseQryParams);
    return uri;
  }

  //
  // CHARACTERS
  //

  Future<MarvelResponse<Character>> getAllCharacters(
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http.get(_buildUri('/characters', queryParams: queryParams)).then(
          (response) => MarvelResponse<Character>.fromRawJson(response.body));

  Future<MarvelResponse<Character>> getCharacter(int characterId,
      {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http.get(_buildUri('/characters/$characterId', queryParams: queryParams)).then(
              (response) => MarvelResponse<Character>.fromRawJson(response.body));

  Future<MarvelResponse<Serie>> getCharacterSeries(int characterId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/characters/$characterId/series',
              queryParams: queryParams))
          .then((response) => MarvelResponse<Serie>.fromRawJson(response.body));

  Future<MarvelResponse<Comic>> getCharacterComics(int characterId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/characters/$characterId/comics',
              queryParams: queryParams))
          .then((response) => MarvelResponse<Comic>.fromRawJson(response.body));

  Future<MarvelResponse<MarvelEvent>> getCharacterEvents(int characterId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/characters/$characterId/events',
              queryParams: queryParams))
          .then((response) =>
              MarvelResponse<MarvelEvent>.fromRawJson(response.body));

  //
  // Series
  //

  Future<MarvelResponse<Serie>> getAllSeries(
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/series', queryParams: queryParams))
          .then((response) => MarvelResponse<Serie>.fromRawJson(response.body));

  Future<MarvelResponse<Serie>> getSerie(int serieId,
      {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/series/$serieId', queryParams: queryParams))
          .then((response) => MarvelResponse<Serie>.fromRawJson(response.body));

  Future<MarvelResponse<Character>> getSerieCharactes(int serieId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/series/$serieId/characters',
              queryParams: queryParams))
          .then((response) =>
              MarvelResponse<Character>.fromRawJson(response.body));

  Future<MarvelResponse<Comic>> getSerieComics(int serieId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/series/$serieId/comics', queryParams: queryParams))
          .then((response) => MarvelResponse<Comic>.fromRawJson(response.body));

  Future<MarvelResponse<MarvelEvent>> getSerieEvents(int serieId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/series/$serieId/events', queryParams: queryParams))
          .then((response) =>
              MarvelResponse<MarvelEvent>.fromRawJson(response.body));

  Future<MarvelResponse<Creator>> getSerieCreators(int serieId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/series/$serieId/creators', queryParams: queryParams))
          .then(
              (response) => MarvelResponse<Creator>.fromRawJson(response.body));

  //
  // Comics
  //

  Future<MarvelResponse<Comic>> getAllComics(
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/comics', queryParams: queryParams))
          .then((response) => MarvelResponse<Comic>.fromRawJson(response.body));

  Future<MarvelResponse<Comic>> getComic(int comicId,
      {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/comics/$comicId', queryParams: queryParams))
          .then((response) => MarvelResponse<Comic>.fromRawJson(response.body));

  Future<MarvelResponse<Character>> getComicCharactes(int comicId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/comics/$comicId/characters',
              queryParams: queryParams))
          .then((response) =>
              MarvelResponse<Character>.fromRawJson(response.body));

  Future<MarvelResponse<MarvelEvent>> getComicEvents(int comicId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/comics/$comicId/events', queryParams: queryParams))
          .then((response) =>
              MarvelResponse<MarvelEvent>.fromRawJson(response.body));

  Future<MarvelResponse<Creator>> getComicCreators(int comicId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/comics/$comicId/creators', queryParams: queryParams))
          .then(
              (response) => MarvelResponse<Creator>.fromRawJson(response.body));

  //
  // Events
  //

  Future<MarvelResponse<MarvelEvent>> getAllEvents(
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http.get(_buildUri('/events', queryParams: queryParams)).then(
          (response) => MarvelResponse<MarvelEvent>.fromRawJson(response.body));

  Future<MarvelResponse<MarvelEvent>> getEvent(int eventId,
      {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http.get(_buildUri('/events/$eventId', queryParams: queryParams)).then(
              (response) => MarvelResponse<MarvelEvent>.fromRawJson(response.body));

  Future<MarvelResponse<Character>> getEventCharactes(int eventId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/events/$eventId/characters',
              queryParams: queryParams))
          .then((response) =>
              MarvelResponse<Character>.fromRawJson(response.body));

  Future<MarvelResponse<Comic>> getEventComics(int eventId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/events/$eventId/comics', queryParams: queryParams))
          .then((response) => MarvelResponse<Comic>.fromRawJson(response.body));

  Future<MarvelResponse<Serie>> getEventSeries(int eventId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/events/$eventId/series', queryParams: queryParams))
          .then((response) => MarvelResponse<Serie>.fromRawJson(response.body));

  Future<MarvelResponse<Creator>> getEventCreators(int eventId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/events/$eventId/creators', queryParams: queryParams))
          .then(
              (response) => MarvelResponse<Creator>.fromRawJson(response.body));

  //
  // Creators
  //

  Future<MarvelResponse<Creator>> getAllCreators(
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http.get(_buildUri('/creators', queryParams: queryParams)).then(
          (response) => MarvelResponse<Creator>.fromRawJson(response.body));

  Future<MarvelResponse<Creator>> getCreator(int creatorId,
      {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http.get(_buildUri('/creators/$creatorId', queryParams: queryParams)).then(
              (response) => MarvelResponse<Creator>.fromRawJson(response.body));

  Future<MarvelResponse<Serie>> getCreatorSeries(int creatorId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/creators/$creatorId/series',
              queryParams: queryParams))
          .then((response) => MarvelResponse<Serie>.fromRawJson(response.body));

  Future<MarvelResponse<Comic>> getCreatorComics(int creatorId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/creators/$creatorId/comics',
              queryParams: queryParams))
          .then((response) => MarvelResponse<Comic>.fromRawJson(response.body));

  Future<MarvelResponse<MarvelEvent>> getCreatorEvents(int creatorId,
          {Map<String, String> queryParams: const {"orderBy": "-modified"}}) =>
      http
          .get(_buildUri('/creators/$creatorId/events',
              queryParams: queryParams))
          .then((response) =>
              MarvelResponse<MarvelEvent>.fromRawJson(response.body));
}
