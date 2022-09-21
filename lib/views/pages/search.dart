import 'package:coolicons/coolicons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/views/pages/main.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey _keyForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    width: MediaQuery.of(context).size.width * .9,
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 17, color: blue2E3A59),
                      key: _keyForm,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          fillColor: const Color.fromARGB(32, 134, 134, 145),
                          filled: true,
                          contentPadding: const EdgeInsets.all(8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(80))),
                      onChanged: //TODO: HINT LIST OF SITES
                          (value) {},
                      onTap: () {
                        //TODO: ADD TO RECENT SEARCHED TABLE
                      },
                    )),
              ],
            ),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) => const ListTile(),
          )),
    );
  }
}
