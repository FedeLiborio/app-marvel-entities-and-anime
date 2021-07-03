import 'package:actividad_05/routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:actividad_05/widgets/text_with_icon.dart';

final String commonStructureFragment = r"""
      id
      title {
        userPreferred
      }
      coverImage {
        large
      }
  """;

class AnimeTabScreen extends StatelessWidget {
  AnimeTabScreen({Key key}) : super(key: key);

  final String queryAnimeTab = """
    query (\$season: MediaSeason, \$seasonYear: Int, \$nextSeason: MediaSeason, \$nextYear: Int) {
      trending: Page(page: 1, perPage: 20) {
        media(sort: TRENDING_DESC, type: ANIME, isAdult: false) {
          $commonStructureFragment
        }
      }
      season: Page(page: 1, perPage: 20) {
        media(season: \$season, seasonYear: \$seasonYear, sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
          $commonStructureFragment
        }
      }
      nextSeason: Page(page: 1, perPage: 20) {
        media(season: \$nextSeason, seasonYear: \$nextYear, sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
          $commonStructureFragment
        }
      }
      popular: Page(page: 1, perPage: 20) {
        media(sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
          $commonStructureFragment
        }
      }
      top: Page(page: 1, perPage: 20) {
        media(sort: SCORE_DESC, type: ANIME, isAdult: false) {
          $commonStructureFragment
        }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(queryAnimeTab),
            variables: {
              "season": "SPRING",
              "seasonYear": 2021,
              "nextSeason": "SUMMER",
              "nextYear": 2021
            },
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

          //trending, season, nextSeason, popular, top
          dynamic media = result.data['trending']['media'];
          return ListView(
            children: [
              TextWithIcon(label: "Trending now"),
              Container(
                height: 240,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: result.data['trending']['media'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ROUTE_NAMES['ANIME_DETAIL'],
                                arguments: result.data['trending']['media']
                                    [index]);
                          },
                          child: AnimeCard(
                              media: result.data['trending']['media'][index]));
                    }),
              ),
              TextWithIcon(label: "Popular this season"),
              Container(
                height: 240,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: result.data['season']['media'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ROUTE_NAMES['ANIME_DETAIL'],
                                arguments: result.data['season']['media']
                                    [index]);
                          },
                          child: AnimeCard(
                              media: result.data['season']['media'][index]));
                    }),
              ),
              TextWithIcon(label: "Upcoming next season"),
              Container(
                height: 240,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: result.data['nextSeason']['media'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ROUTE_NAMES['ANIME_DETAIL'],
                                arguments: result.data['nextSeason']['media']
                                    [index]);
                          },
                          child: AnimeCard(
                              media: result.data['nextSeason']['media']
                                  [index]));
                    }),
              ),
              TextWithIcon(label: "All time popular"),
              Container(
                height: 240,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: result.data['popular']['media'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ROUTE_NAMES['ANIME_DETAIL'],
                                arguments: result.data['popular']['media']
                                    [index]);
                          },
                          child: AnimeCard(
                              media: result.data['popular']['media'][index]));
                    }),
              ),
              TextWithIcon(label: "Top"),
              Container(
                height: 240,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: result.data['top']['media'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ROUTE_NAMES['ANIME_DETAIL'],
                                arguments: result.data['top']['media'][index]);
                          },
                          child: AnimeCard(
                              media: result.data['top']['media'][index]));
                    }),
              )
            ],
          );
        });
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
    return Column(children: [
      Container(
        margin: EdgeInsets.only(left: 15, bottom: 10, top: 5),
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 6,
                color: Colors.black54.withOpacity(0.25))
          ],
          image: DecorationImage(
            image: NetworkImage(media['coverImage']['large']),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      Container(
          margin: EdgeInsets.only(left: 15, bottom: 10),
          width: 150,
          child: Text(
            media['title']['userPreferred'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          )),
    ]);
  }
}
