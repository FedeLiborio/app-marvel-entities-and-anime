import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_bloc.dart';
import 'package:actividad_05/bloc/list_characters_favs/list_characters_favs_events.dart';
import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/screens/character_detail/character_releated_content.dart';
import 'package:actividad_05/services/favourites_service.dart';
import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/attribution.dart';
import 'package:actividad_05/widgets/detail_hero_with_back_btn.dart';
import 'package:actividad_05/widgets/labeled_image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CharacterDetailScreen extends StatefulWidget {
  const CharacterDetailScreen({Key key}) : super(key: key);

  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  List<dynamic> favouritedCharacterIds = [];
  List<int> favouritedCharacterIdsSqlite = [];

  toggleFavouriteSqlite(Character character) => () async {
        setState(() {
          if (favouritedCharacterIdsSqlite.indexOf(character.id) >= 0) {
            favouritedCharacterIdsSqlite.remove(character.id);
            FavouritesService().deleteCharacter(character);
          } else {
            favouritedCharacterIdsSqlite.add(character.id);
            FavouritesService().insertCharacter(character);
          }
        });
      };

  getFavouriteCharactersSqlite() async {
    try {
      List<int> favCharIds = await FavouritesService().getFavouriteCharacters();
      print("getFavouriteCharactersSqlite ${favCharIds.toString()}");
      setState(() {
        favouritedCharacterIdsSqlite = favCharIds;
      });
    } catch (e) {
      print('getFavouriteCharactersSqlite $e');
    }
  }

  toggleFavourite(int characterId) => () async {
        final listCharactersFavBloc = BlocProvider.of<ListCharactersFavBloc>(context);

        setState(() {
          if (favouritedCharacterIds.indexOf(characterId) >= 0) {
            favouritedCharacterIds.remove(characterId);
          } else {
            favouritedCharacterIds.add(characterId);
          }
        });

        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String favouriteCharacters =
              prefs.getString('favouriteCharacters') ?? '[]';

          print('From sharedProps $favouriteCharacters');

          List<dynamic> favouriteCharactersIds =
              json.decode(favouriteCharacters);

          if (favouriteCharactersIds.indexOf(characterId) >= 0) {
            favouriteCharactersIds.remove(characterId);
          } else {
            favouriteCharactersIds.add(characterId);
          }

          await prefs.setString(
              'favouriteCharacters', json.encode(favouriteCharactersIds));
          listCharactersFavBloc.add(ListCharactersFavShow());
        } catch (e) {
          print('Err $e');
          SharedPreferences.setMockInitialValues({});
        }
      };

  getFavouriteCharacters() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String favouriteCharacters =
          prefs.getString('favouriteCharacters') ?? '[]';
      List<dynamic> characterFavourites = json.decode(favouriteCharacters);

      print('From INIT STATE $characterFavourites');
      setState(() {
        favouritedCharacterIds = characterFavourites;
      });
    } catch (e) {
      print('Err $e');
      SharedPreferences.setMockInitialValues({});
    }
  }

  @override
  void initState() {
    super.initState();
    getFavouriteCharacters();
    getFavouriteCharactersSqlite();
  }

  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context).settings.arguments as Character;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          DetailHeroWithBackBtn(thumbnail: character.thumbnail),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed:
                    toggleFavourite(character != null ? character.id : 0),
                icon: (favouritedCharacterIds
                            .indexOf(character != null ? character.id : 0) >=
                        0)
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_outline),
                iconSize: 40.0,
                color: Colors.black,
              ),
              // Se comentó estas lineas para no confundir, pero el metodo al
              // que llama funciona perfectamente.
              /*
              IconButton(
                onPressed:
                    toggleFavouriteSqlite(character != null ? character : null),
                icon: (favouritedCharacterIdsSqlite
                            .indexOf(character != null ? character.id : 0) >=
                        0)
                    ? Icon(Icons.star)
                    : Icon(Icons.star_outline),
                iconSize: 40.0,
                color: Colors.black,
              ),
               */
              IconButton(
                onPressed: () => print('Share'),
                icon: Icon(Icons.share),
                iconSize: 35.0,
                color: Colors.black,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                character.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.0),
              Text(
                '⭐ ⭐ ⭐ ⭐ ⭐',
                style: TextStyle(fontSize: 25.0),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                height: 120.0,
                child: SingleChildScrollView(
                  child: Text(
                    character.description,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'RELATED CONTENT',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          CharacterReleatedContent(
            character: character,
          ),
          Attribution(),
        ],
      ),
    );
  }
}
