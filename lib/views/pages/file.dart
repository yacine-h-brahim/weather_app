import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controles/geographic.dart';
import 'package:weather_app/models/geo.dart';

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
  List<Goe> list = [];

  @override
  void initState() {
    super.initState();
    DBHelper().selecteRecentRow().then((value) {
      setState(() {
        Provider.of<WeatherProvider>(context, listen: false).recentSearch =
            value;
      });
    });
//TODO:MEKE THIS AN CONSTANT IN THE WEATHER PROVIDER::::::::::::
    Geographic.getLoction('ghardaia').then((value) {
      for (var element in value) {
        setState(() {
          list.add(element);
        });
      }
    });
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

    return Container(
      color: Colors.red,
      child: Text(list.first.country.toString()),
    );
  }
}
