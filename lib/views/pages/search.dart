// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:weather_app/db/db.dart';
// import 'package:weather_app/views/pages/main.dart';

// import '../../controles/current_weather.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/db/all_cities.dart';
import 'package:weather_app/models/recent_search.dart';

import '../../controles/current_weather.dart';
import '../../db/db.dart';

class Search extends SearchDelegate {
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
    var provider = Provider.of<WeatherProvider>(context, listen: false);
    provider.getCurrent();
    if (query.trim().isEmpty) {
      return const Center(
        child: Text(
          'oops!! this field is required ,enter a location 😕😕',
          style: TextStyle(fontSize: 17, color: Colors.red),
        ),
      );
    } else if (provider.statusCode != 200) {
      return const Center(
        child: Text(
          'oops!! location not found 😕😕',
          style: TextStyle(fontSize: 17, color: Colors.red),
        ),
      );
    } else if (provider.statusCode == 200) {
      RecentSearch recentSearch = RecentSearch();
      provider.getCurrent().then((value) {
        recentSearch = RecentSearch(
            lat: value.coord!.lat, lon: value.coord!.lon, name: value.name);
        provider.recentSearch = recentSearch;
      });

      DBHelper().addRecentSearch(recentSearch);
      Navigator.pop(context);
    }
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionsList = cities.where((element) {
      final result = element.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionsList[index]),
          onTap: () {
            query = suggestionsList[index];
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
