import 'package:flutter/material.dart';

import '../../main.dart';

class SearchD extends StatefulWidget {
  const SearchD({super.key});

  @override
  State<SearchD> createState() => _SearchState();
}

class _SearchState extends State<SearchD> {
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: blue2E3A59,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * .8,
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 15, color: blue2E3A59),
                        // key: _keyForm,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            fillColor: const Color.fromARGB(32, 134, 134, 145),
                            filled: true,
                            contentPadding: const EdgeInsets.all(8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(80))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'enter a location is required ';
                          } else {
                            return null;
                          }
                        },
                        onChanged: //TODO: HINT LIST OF SITES
                            (value) {},
                        onTap: () {
                          //TODO: ADD TO RECENT SEARCHED TABLE
                        },
                      )),
                  InkWell(
                    child: const Icon(Icons.more_vert_rounded),
                    onTap: () {},
                  )
                ],
              ),
            ),
            body: Form(
              key: _keyForm,
              child: TextFormField(
                style: const TextStyle(fontSize: 15, color: blue2E3A59),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    fillColor: const Color.fromARGB(32, 134, 134, 145),
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(80))),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  } else {
                    return null;
                  }
                },
                onChanged: //TODO: HINT LIST OF SITES
                    (value) {},
                onSaved: (value) {
                  //TODO: ADD TO RECENT SEARCHED TABLE
                  // WeatherProvider().getCurrent(value!);
                  // if (_keyForm.currentState!.validate() &&
                  //     WeatherProvider.statusCode != 200) {
                  //   Fluttertoast.showToast(
                  //       msg: 'Location not fond 🤨🤨🤨',
                  //       backgroundColor: Colors.redAccent);
                  // } else if (_keyForm.currentState!.validate() &&
                  //     WeatherProvider.statusCode == 200) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const SearchD()));
                  // }
                },
              ),
            )));
  }
}
