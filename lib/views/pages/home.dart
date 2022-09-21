import 'package:coolicons/coolicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controles/current_weather.dart';
import 'package:weather_app/db/db.dart';
import 'package:weather_app/models/recent_search.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/views/pages/search.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../controles/forecast.dart';
import '../../models/forecast.dart';
import 'main.dart';
import 'weather_detail.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String? lastUpdateTime = '';
String? recentSearchName = '';

class _MyHomePageState extends State<MyHomePage> {
  Map<String?, dynamic> coord = {
    'lat': 0.1,
    'lon': 0.3,
    'name': 'ghardaia',
  };
  List<String> recentSearch = <String>[];

  @override
  void initState() {
    DBHelper().selecetLastUpdate().then((value) {
      lastUpdateTime = value;
    });
    DBHelper().selecetRecentSearch().then((value) {
      for (int i = 0; i < value.length; i++) {
        recentSearch.add(value[i]);
      }
      print('${recentSearch.first} recentSearch.length');
      recentSearchName = recentSearch[0];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var provider = Provider.of<WeatherProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  const Icon(
                    Coolicons.location,
                    color: blue2E3A59,
                    size: 24,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .55,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        value: recentSearchName,
                        items: recentSearch.map(buildItem).toList(),
                        onChanged: (value) {
                          setState(() {
                            recentSearchName = value;
                          });
                        },
                        icon: const Icon(Coolicons.caret_down,
                            size: 24, color: blue2E3A59),
                        isExpanded: true,
                      ))),
                  const Spacer(),
                  InkWell(
                      child: const Icon(
                        Coolicons.search,
                        color: blue2E3A59,
                        size: 25,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Search()));
                      })
                ]))),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
              child: Column(
            children: [
              FutureBuilder<CurrentWeather>(
                  future: provider.getCurrent('ghardaia'),
                  builder: (context, currentSnapshot) {
                    if (currentSnapshot.hasData) {
                      return InkWell(
                          child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: MediaQuery.of(context).size.height * .25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: provider.isNight()
                                          ? [
                                              const Color.fromRGBO(
                                                  76, 78, 83, 1),
                                              const Color.fromRGBO(
                                                  11, 18, 35, 1)
                                            ]
                                          : [
                                              const Color.fromRGBO(
                                                  79, 127, 250, 1),
                                              const Color.fromRGBO(
                                                  51, 95, 209, 1)
                                            ]),
                                  boxShadow: [
                                    BoxShadow(
                                        color: provider.isNight()
                                            ? const Color.fromRGBO(
                                                6, 13, 31, 0.4)
                                            : const Color.fromRGBO(
                                                59, 105, 222, 0.4),
                                        spreadRadius: 0,
                                        blurRadius: 40,
                                        offset: const Offset(0, 4))
                                  ]),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder(
                                        stream: Stream.periodic(
                                            const Duration(seconds: 1)),
                                        builder: (context, snapshot) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  DateFormat('yMMMMEEEEd')
                                                      .format(DateTime.now()),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Text(
                                                DateFormat('jm')
                                                    .format(DateTime.now())
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          );
                                        }),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          "http://openweathermap.org/img/w/${currentSnapshot.data!.weather!.first.icon!}.png",
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${currentSnapshot.data!.mian!.temp}° C  ',
                                                  style: theme.headline2),
                                              Text(
                                                  '${currentSnapshot.data!.weather!.first.description}',
                                                  style: theme.headline3)
                                            ])
                                      ],
                                    ),

                                    //DONE: CHANGE THIS TO A STREAM BUILDER;
                                    FutureBuilder(
                                        future: DBHelper().selecetLastUpdate(),
                                        builder: (context, snapshot) {
                                          return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Last update ${snapshot.data}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                InkWell(
                                                    onTap: () {
                                                      DBHelper().addLastUpdate(
                                                        DateFormat('jm').format(
                                                            DateTime.now()),
                                                      );
                                                      DBHelper()
                                                          .selecetLastUpdate()
                                                          .then((value) {
                                                        setState(() {
                                                          lastUpdateTime =
                                                              value;
                                                        });
                                                      });
                                                    },
                                                    child: const Icon(
                                                        Coolicons.refresh,
                                                        color: Colors.white))
                                              ]);
                                        }),
                                  ])),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailWeather(
                                      currentSnapshot: currentSnapshot),
                                ));
                          });
                    } else if (currentSnapshot.hasError) {
                      Fluttertoast.showToast(
                          msg: currentSnapshot.error.toString(),
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.BOTTOM);
                      return Container();
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(height: 5),
              //Hourly Weather
              Row(children: [
                const Text(
                  'Hourly Weather',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 20),
                ),
                Expanded(child: Container())
              ]),
              FutureBuilder<ForecastFiveThree?>(
                  future: ForecastFiveThreeProvider.getForcast(
                      coord['lat']!, coord['lon']!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.cnt,
                              itemBuilder: ((context, index) => Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  // height: 100,
                                  width: 87,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 245, 245, 245),
                                      borderRadius: BorderRadius.circular(7.5)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.network(
                                            'http://openweathermap.org/img/w/${snapshot.data!.lst![index].weather!.first.icon!}.png'),
                                        Text(
                                            '${snapshot.data!.lst![index].main!.temp}° C',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    32, 28, 28, 1),
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            DateFormat('Hm').add_Md().format(
                                                DateTime.parse(snapshot
                                                    .data!.lst![index].dtTxt!)),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    73, 67, 67, 1)))
                                      ])))));
                    } else {
                      if (snapshot.hasError) {
                        Fluttertoast.showToast(msg: snapshot.error.toString());
                        return const CircularProgressIndicator();
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }
                  }),
              const SizedBox(height: 5),
              //Daily
              Row(children: [
                const Text(
                  'Daily',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 20),
                ),
                Expanded(child: Container())
              ]),
              noteCard(),
              Expanded(
                flex: 2,
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: 7,
                    itemBuilder: (context, index) => Container(
                          height: 70,
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromRGBO(210, 223, 255, 1),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(154, 182, 255, 1),
                                  borderRadius: BorderRadius.circular(25)),
                              child: const Icon(
                                WeatherIcons.cloudy_windy,
                              ),
                            ),
                            title: Text(
                              'Tuesday',
                              style: theme.headline4,
                            ),
                            subtitle: const Text(
                              'thunderstorm',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(73, 67, 67, 1)),
                            ),
                            trailing: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('19° C', style: theme.headline1),
                                  const SizedBox(width: 10),
                                  const Icon(Coolicons.caret_right)
                                ]),
                            // onTap: () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => DetailWeather(
                            //             currentSnapshot: ),
                            //       ));
                            // },
                          ),
                        )),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget noteCard() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(231, 117, 92, 0.13)),
        child: Stack(children: [
          Positioned(
            right: -40,
            top: -60,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: const Color.fromRGBO(243, 126, 126, 0.2), width: 12),
              ),
            ),
          ),
          Positioned(
              right: -20,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/dotsPic.svg',
                height: 30,
                width: 80,
                color: const Color.fromRGBO(243, 126, 126, 0.2),
              )),
          Positioned(
              top: 5,
              bottom: 5,
              left: 20,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      WeatherIcons.rain,
                      size: 30,
                      color: Color.fromRGBO(255, 113, 113, 1),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .65,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                  "Tomorrow's weather is likely to rain this afternoon",
                                  maxLines: 3,
                                  softWrap: true,
                                  style: TextStyle(
                                      height: 1.3,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              // SizedBox(height: 10),
                              Text("Don't forget to bring an umbrella",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400))
                            ]))
                  ]))
        ]));
  }

  Widget inkWellCard(WeatherProvider provider, TextTheme theme) {
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return InkWell(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: provider.isNight()
                            ? [
                                const Color.fromRGBO(76, 78, 83, 1),
                                const Color.fromRGBO(11, 18, 35, 1)
                              ]
                            : [
                                const Color.fromRGBO(79, 127, 250, 1),
                                const Color.fromRGBO(51, 95, 209, 1)
                              ]),
                    boxShadow: [
                      BoxShadow(
                          color: provider.isNight()
                              ? const Color.fromRGBO(6, 13, 31, 0.4)
                              : const Color.fromRGBO(59, 105, 222, 0.4),
                          spreadRadius: 0,
                          blurRadius: 40,
                          offset: const Offset(0, 4))
                    ]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('yMMMMEEEEd').format(DateTime.now()),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          Text(
                            DateFormat('jm').format(DateTime.now()).toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(WeatherIcons.rain_wind),
                          const SizedBox(width: 20),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('18° C', style: theme.headline2),
                                Text('Cloudy Rain', style: theme.headline3)
                              ])
                        ],
                      ),
                      FutureBuilder(
                          future: DBHelper().selecetLastUpdate(),
                          builder: (context, snapshot) {
                            return Row(children: [
                              Text(
                                'Last update ${snapshot.data}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              InkWell(
                                child: const Icon(Icons.refresh,
                                    color: Colors.white),
                                onTap: () {
                                  DBHelper().addLastUpdate(
                                    DateFormat('jm').format(DateTime.now()),
                                  );
                                },
                              )
                            ]);
                          })
                    ])),
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const DetailWeather(),
            //       ));
            // }
          );
        });
  }

  DropdownMenuItem<String> buildItem(String e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      );
}
