import 'package:actividad_05/bloc/search_results_bloc.dart';
import 'package:actividad_05/bloc/search_results_cubit.dart';
import 'package:actividad_05/bloc/search_results_events.dart';
import 'package:actividad_05/bloc/search_results_state.dart';
import 'package:actividad_05/models/character.dart';
import 'package:actividad_05/models/comic.dart';
import 'package:actividad_05/models/marvel_response.dart';
import 'package:actividad_05/models/thumbnail.dart';
import 'package:actividad_05/services/marvel_api_service.dart';
import 'package:actividad_05/widgets/labeled_image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchTabCubitScreen extends StatefulWidget {
  const SearchTabCubitScreen({Key key}) : super(key: key);

  @override
  _SearchTabCubitScreenState createState() => _SearchTabCubitScreenState();
}

class _SearchTabCubitScreenState extends State<SearchTabCubitScreen> {
  String searchText = '';
  List<Character> charactersFound = [];
  List<Comic> comicsFound = [];

  final String sdlAnimeSearchByText = """
    query (\$searchText: String) {
      animeSearch: Page(page: 2, perPage: 6) {
        media(sort: TRENDING_DESC, type: ANIME, isAdult: false, search: \$searchText) {
          id
          title {
            userPreferred
          }
          coverImage {
            extraLarge
            large
            color
          }
          startDate {
            year
            month
            day
          }
          endDate {
            year
            month
            day
          }
          bannerImage
          season
          status(version: 2)
          episodes
          # genres
          averageScore
          popularity
          studios(isMain: true) {
            edges {
              isMain
              node {
                id
                name
              }
            }
          }     
        }
      }
    }
  """;

  _onChangeSearchText(newText) {
    context.read<SearchResultsCubit>().searchCharactersByName(newText);
    setState(() {
      searchText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(onChanged: _onChangeSearchText),
        BlocBuilder<SearchResultsCubit, SearchResultsState>(
          builder: (context, state) {
            if (state is SearchResultsIntialState) {
              return Text('Please write some text');
            } else if (state is SearchResultsFetchingState) {
              return Text('Cargando...');
            } else if (state is SearchResultsFailureState) {
              return Text('ERROR');
            } else if (state is SearchResultsEmptyState) {
              return Text('Sin Resultados');
            } else {
              return LabeledImageList(
                  onTap: (index) => () => {},
                  label: "Characters found",
                  thumbs: state.characterResults
                      .map<Thumbnail>((item) => item.thumbnail)
                      .toList());
            }
          },
        ),
        FutureBuilder<MarvelResponse<Comic>>(
          future: MarvelApiService().getAllComics(queryParams: {
            "orderBy": "-modified",
            "titleStartsWith": searchText
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LabeledImageList(
                  onTap: (index) => () => {},
                  label: "Comics found",
                  thumbs: snapshot.data.data.results
                      .map<Thumbnail>((item) => item.thumbnail)
                      .toList());
            } else if (snapshot.hasError) {
              return Text('ERROR');
            } else {
              return Text('Cargando...');
            }
          },
        ),
        Query(
          options: QueryOptions(
              document: gql(sdlAnimeSearchByText),
              variables: {"searchText": searchText},
              fetchPolicy: FetchPolicy.noCache),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.hasException) {
              print(result.exception);
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return Text('Loading...');
            }

            List<dynamic> media = result.data['animeSearch']['media'];

            return Container(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {}, child: AnimeCard(media: media[index]));
                  }),
            );
          },
        )
      ],
    );
  }
}

class AnimeCard extends StatelessWidget {
  const AnimeCard({
    Key key,
    @required this.media,
  }) : super(key: key);

  final dynamic media;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      child: Column(children: [
        Container(
          width: 100,
          height: 150,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(media['coverImage']['large']),
            ),
          ),
        ),
        Text(
          media['title']['userPreferred'],
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }
}
