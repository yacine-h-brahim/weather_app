import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/recent_search.dart';
import 'package:weather_app/views/pages/home.dart';

import '../../controles/current_weather.dart';
import '../../db/db.dart';

class Jome extends StatefulWidget {
  const Jome({super.key});

  @override
  State<Jome> createState() => _JomeState();
}

class _JomeState extends State<Jome> {
  // List<String> recentSearchNames = [];
  // List<RecentSearch> recentSearchList = [];

  @override
  void initState() {
    super.initState();
    DBHelper().selecteRecentRow().then((value) {
      setState(() {
        debugPrint(value.toString());
        Provider.of<WeatherProvider>(context, listen: false).recentSearch =
            value;
      });
    });
//TODO:MEKE THIS AN CONSTANT IN THE WEATHER PROVIDER::::::::::::

    DBHelper().selecetRecentSearch().then((value) {
      for (int i = 0; i < value.length; i++) {
        setState(() {
          Provider.of<WeatherProvider>(context, listen: false)
              .recentSearchList
              .add(value[i]);
          // Provider.of<WeatherProvider>(context, listen: false)
          //     .recentSearchNames
          //     .add(value[i].name!);
        });
      }
      // setState(() {
      //   Provider.of<WeatherProvider>(context, listen: false).recentSearchList =
      //       recentSearchList;
      //   Provider.of<WeatherProvider>(context, listen: false).recentSearchNames =
      //       recentSearchNames;

      //TODO: UPDATE THIS LIST 'RECENTSEARCHNAMES' WHEN POPING FROM THE SEARCH PAGE;S
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WeatherProvider>(context);
    debugPrint(provider.lastUpdateTime);
    debugPrint(
        'provider.recentSearchList :${provider.recentSearchList.last.toMap().toString()}');
    // List list =
    // debugPrint('list.toString() : ${list.toString()}');
    // return Container(
    //   color: Colors.amber,
    // );
    return Container();
  }
}
