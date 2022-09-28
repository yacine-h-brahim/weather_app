import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controles/current_weather.dart';
import 'package:weather_app/models/recent_search.dart';

import '../../controles/geographic.dart';
import '../../db/db.dart';
import '../../models/geo.dart';

class Search extends SearchDelegate {
  List<Goe> suggestionsList = [];
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
    // if (suggestionsList.isNotEmpty) {
    //   var goe = suggestionsList.where((element) => element.name == query);
    //   RecentSearch recentSearchItem = RecentSearch(
    //       name: goe.first.name, lat: goe.first.lat, lon: goe.first.lon);
    //   provider.recentSearch = recentSearchItem;
    //   DBHelper().addRecentSearch(recentSearchItem);
    //   provider.recentSearchList.add(recentSearchItem);
    //   Navigator.pop(context);
    // } else
    if (query.isNotEmpty) {
      query = query[0].toUpperCase() + query.substring(1);
      Geographic.codeStatus(query).then((value) {
        if (value == 200) {
          provider.recentSearch = Geographic.recent;
          DBHelper().addRecentSearch(Geographic.recent);
          provider.recentSearchList.add(Geographic.recent);
          Navigator.pop(context, true);
        } else {
          return const Center(
            child: Text(
              'oops!! location not found 😕😕',
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
          );
        }
      });
    } else {
      return const Center(
        child: Text(
          'oops!! location not found 😕😕',
          style: TextStyle(fontSize: 17, color: Colors.red),
        ),
      );
    }

    // print(query);
    // print(goe.first.country);
    // var provider = Provider.of<WeatherProvider>(context, listen: false);
    // provider.getCurrent();
    // if (query.trim().isEmpty) {
    //   return const Center(
    //     child: Text(
    //       'oops!! this field is required ,enter a location 😕😕',
    //       style: TextStyle(fontSize: 17, color: Colors.red),
    //     ),
    //   );
    // } else if (provider.statusCode != 200) {
    //   return const Center(
    //     child: Text(
    //       'oops!! location not found 😕😕',
    //       style: TextStyle(fontSize: 17, color: Colors.red),
    //     ),
    //   );
    // } else if (provider.statusCode == 200) {
    //   RecentSearch recentSearch = RecentSearch();
    //   provider.getCurrent().then((value) {
    //     recentSearch = RecentSearch(
    //         lat: value.coord!.lat, lon: value.coord!.lon, name: value.name);
    //     provider.recentSearch = recentSearch;
    //   });

    //   Navigator.pop(context);
    // }
    return Container();
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

// class Search extends SearchDelegate {
//   const Search({super.key});

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   final _keyForm = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             appBar: PreferredSize(
//               preferredSize: const Size(double.infinity, kToolbarHeight),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Icon(
//                       Icons.arrow_back,
//                       color: blue2E3A59,
//                     ),
//                   ),
//                   Container(
//                       margin: const EdgeInsets.only(top: 8),
//                       width: MediaQuery.of(context).size.width * .8,
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: TextFormField(
//                         style: const TextStyle(fontSize: 15, color: blue2E3A59),
//                         // key: _keyForm,
//                         keyboardType: TextInputType.text,
//                         textInputAction: TextInputAction.search,
//                         decoration: InputDecoration(
//                             fillColor: const Color.fromARGB(32, 134, 134, 145),
//                             filled: true,
//                             contentPadding: const EdgeInsets.all(8),
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(80))),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'enter a location is required ';
//                           } else {
//                             return '';
//                           }
//                         },
//                         onChanged: //TODO: HINT LIST OF SITES
//                             (value) {},
//                         onTap: () {
//                           //TODO: ADD TO RECENT SEARCHED TABLE
//                         },
//                       )),
//                   InkWell(
//                     child: const Icon(Icons.more_vert_rounded),
//                     onTap: () {},
//                   )
//                 ],
//               ),
//             ),
//             body: Form(
//               key: _keyForm,
//               child: TextFormField(
//                 style: const TextStyle(fontSize: 15, color: blue2E3A59),
//                 keyboardType: TextInputType.text,
//                 textInputAction: TextInputAction.search,
//                 decoration: InputDecoration(
//                     fillColor: const Color.fromARGB(32, 134, 134, 145),
//                     filled: true,
//                     contentPadding: const EdgeInsets.all(8),
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(80))),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'This field is required';
//                   } else {
//                     return null;
//                   }
//                 },
//                 onChanged: //TODO: HINT LIST OF SITES

//                     (value) {},
//                 onSaved: (value) {
//                   //TODO: ADD TO RECENT SEARCHED TABLE
//                   WeatherProvider.getCurrent(value!);
//                   if (_keyForm.currentState!.validate() &&
//                       WeatherProvider.statusCode != 200) {
//                     Fluttertoast.showToast(
//                         msg: 'Location not fond 🤨🤨🤨',
//                         backgroundColor: Colors.redAccent);
//                   } else if (_keyForm.currentState!.validate() &&
//                       WeatherProvider.statusCode == 200) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Search()));
//                   }
//                 },
//               ),
//             )));
//   }
// }
