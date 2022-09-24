import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/recent_search.dart';

import '../../controles/current_weather.dart';
import '../../db/db.dart';

class Jome extends StatefulWidget {
  const Jome({super.key});

  @override
  State<Jome> createState() => _JomeState();
}

class _JomeState extends State<Jome> {
  RecentSearch recentSearch = RecentSearch();
  @override
  void initState() {
    super.initState();
    DBHelper().selecteRecentRow().then((value) {
      setState(() {
        Provider.of<WeatherProvider>(context, listen: false).recentSearch =
            value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.recentSearch.id}'),
      ),
      body: const Center(),
    );
  }
}
