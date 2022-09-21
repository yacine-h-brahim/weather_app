import 'package:coolicons/coolicons.dart';
import 'package:flutter/material.dart';

import '../../db/db.dart';
import 'main.dart';

class Jome extends StatefulWidget {
  const Jome({super.key});

  @override
  State<Jome> createState() => _JomeState();
}

class _JomeState extends State<Jome> {
  List<String> recentSearch = [];
  String? recentSearchName = '';

  @override
  void initState() {
    DBHelper().selecetRecentSearch().then((value) {
      for (int i = 0; i < value.length; i++) {
        recentSearch.add(value[i]);
      }
      debugPrint('${recentSearch.toString()} recentSearch.length');
      setState(() {
        recentSearchName = recentSearch.first;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: recentSearchName,
            items: recentSearch.map(buildItem).toList(),
            onChanged: (value) {
              setState(() {
                // print(recentSearchName!.id);
                recentSearchName = value;
              });
            },
            icon: const Icon(Coolicons.caret_down, size: 24, color: blue2E3A59),
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  DropdownMenuItem buildItem(String e) =>
      DropdownMenuItem(value: e, child: Text(e));
}
