import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controles/current_weather.dart';
import 'package:weather_app/models/recent_search.dart';
import 'package:weather_app/views/pages/home.dart';

import '../../controles/geographic.dart';
import '../../db/db.dart';
import '../../models/geo.dart';

class Search extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        scaffoldBackgroundColor:
            Provider.of<WeatherProvider>(context).isDarkMode
                ? const Color.fromRGBO(32, 29, 29, 1)
                : const Color.fromRGBO(255, 255, 255, 1),
        appBarTheme: AppBarTheme(
            backgroundColor: Provider.of<WeatherProvider>(context).isDarkMode
                ? const Color.fromRGBO(32, 29, 29, 1)
                : const Color.fromRGBO(255, 255, 255, 1)));
  }

  List<Goe> suggestionsList = [];
  List<Goe> list = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) {
    var provider = Provider.of<WeatherProvider>(context);
    if (query.isNotEmpty) {
      query = query[0].toUpperCase() + query.substring(1);

      return FutureBuilder(
        future: Geographic.codeStatus(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != 200) {
              return const Center(
                child: Text(
                  'oops!! location not found 😕😕',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              );
            } else if (snapshot.data == 200) {
              list.addAll(Geographic.goes);
              RecentSearch recent = RecentSearch(
                  name: list[0].name,
                  lat: list[0].lat,
                  lon: list[0].lon,
                  country: list[0].country);
              provider.recentSearch = recent;
              DBHelper().addRecentSearch(recent).then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              });
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return Container();
        },
      );
    } else {
      return const Center(
        child: Text(
          'oops!! location required 😕😕',
          style: TextStyle(fontSize: 17, color: Colors.red),
        ),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      Geographic.getLoction(query.toLowerCase()).then((value) {
        suggestionsList = [];
        for (var i = 0; i < value.length; i++) {
          suggestionsList.add(value[i]);
        }
      });
    }

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionsList[index].name!),
          subtitle: Row(children: [
            Text(suggestionsList[index].country!),
            Text(
                ', lat :${double.parse(suggestionsList[index].lat!.toString()).toStringAsFixed(3)}'),
            Text(
              ', lon :${double.parse(suggestionsList[index].lon!.toString()).toStringAsFixed(3)}',
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            )
          ]),
          onTap: () {
            query = suggestionsList[index].name!;
          },
        );
      },
    );
  }
}
