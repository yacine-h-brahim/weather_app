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
import 'package:weather_app/views/themes.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../controles/forecast.dart';
import '../../models/forecast.dart';
import '../../main.dart';
import 'weather_detail.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AllThemes theme = AllThemes();

  @override
  void initState() {
    super.initState();

    DBHelper().selecetLastUpdate().then((value) {
      setState(() {
        context.read<WeatherProvider>().lastUpdateTime = value;
      });
    });

    DBHelper().selecteRecentRow().then((value) {
      setState(() {
        Provider.of<WeatherProvider>(context, listen: false).recentSearch =
            RecentSearch(
                id: value.id,
                country: value.country,
                lat: value.lat,
                lon: value.lon,
                name: value.name);
      });
    });
//TODO:MEKE THIS AN CONSTANT IN THE WEATHER PROVIDER::::::::::::
    DBHelper().selecetRecentSearch().then((value) {
      setState(() {
        Provider.of<WeatherProvider>(context, listen: false)
            .recentSearchList
            .addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WeatherProvider>(context, listen: true);
    Color background = provider.isDarkMode
        ? const Color.fromRGBO(36, 36, 37, 1)
        : const Color.fromARGB(255, 245, 245, 245);
    List<String> listOfName = [];
    var backgroundColors2 = provider.isDarkMode
        ? [
            const Color.fromRGBO(79, 127, 250, 1),
            const Color.fromRGBO(51, 95, 209, 1)
          ]
        : provider.isNight()
            ? [
                const Color.fromRGBO(76, 78, 83, 1),
                const Color.fromRGBO(11, 18, 35, 1)
              ]
            : [
                const Color.fromRGBO(79, 127, 250, 1),
                const Color.fromRGBO(51, 95, 209, 1)
              ];
    for (var i = 0; i < provider.recentSearchList.length; i++) {
      if (!listOfName.contains(
          '${provider.recentSearchList[i].name!} ,${provider.recentSearchList[i].country!}')) {
        listOfName.add(
            '${provider.recentSearchList[i].name!} ,${provider.recentSearchList[i].country!}');
      }
    }
    //////////////the build methode/////////////////////////////////////////////////

    return SafeArea(
      child: Scaffold(
        backgroundColor: provider.isDarkMode
            ? const Color.fromRGBO(32, 29, 29, 1)
            : const Color.fromRGBO(255, 255, 255, 1),
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Icon(Coolicons.location,
                      color: provider.isDarkMode ? Colors.white : blue2E3A59,
                      size: 24),
                  const SizedBox(width: 8),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .55,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              menuMaxHeight: 200,
                              dropdownColor: background,
                              style: provider.isDarkMode
                                  ? theme.headline2w
                                  : theme.headline2b,
                              value:
                                  '${provider.recentSearch!.name} ,${provider.recentSearch!.country}',
                              items: listOfName.map(buildItem).toList(),
                              onChanged: (value) {
                                for (var e in provider.recentSearchList) {
                                  if ('${e.name!.toLowerCase()} ,${e.country!.toLowerCase()}' ==
                                      value!.toLowerCase()) {
                                    setState(() {
                                      provider.recentSearch = e;
                                    });
                                  }
                                }
                              },
                              focusColor: Colors.black,
                              autofocus: true,
                              icon: Icon(Coolicons.caret_down,
                                  size: 24,
                                  color: provider.isDarkMode
                                      ? Colors.white
                                      : blue2E3A59),
                              isExpanded: true))),
                  const Spacer(),
                  InkWell(
                      child: Icon(
                        Coolicons.search,
                        color: provider.isDarkMode ? Colors.white : blue2E3A59,
                        size: 25,
                      ),
                      onTap: () {
                        showSearch(context: context, delegate: Search())
                            .then((value) {
                          setState(() {});
                        });
                      })
                ]))),
        body: provider.recentSearch == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                    child: FutureBuilder<ForecastFiveThree?>(
                        future: ForecastFiveThreeProvider.getForcast(
                            provider.recentSearch!.lat,
                            provider.recentSearch!.lon),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            Fluttertoast.showToast(
                                msg: snapshot.error.toString());
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            List list = [];
                            list = ForecastFiveThreeProvider.dailyListTemp(
                                snapshot.data!.lst);

                            return Column(children: [
                              FutureBuilder<CurrentWeather>(
                                  future: provider.getCurrent(),
                                  builder: (context, currentSnapshot) {
                                    if (currentSnapshot.hasData) {
                                      return InkWell(
                                          child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .25,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors:
                                                          backgroundColors2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: provider
                                                                .isNight()
                                                            ? const Color
                                                                    .fromRGBO(
                                                                6, 13, 31, 0.4)
                                                            : const Color
                                                                    .fromRGBO(
                                                                59,
                                                                105,
                                                                222,
                                                                0.4),
                                                        spreadRadius: 0,
                                                        blurRadius: 40,
                                                        offset:
                                                            const Offset(0, 4))
                                                  ]),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    StreamBuilder(
                                                        stream: Stream.periodic(
                                                            const Duration(
                                                                seconds: 1)),
                                                        builder: (context,
                                                            snapshot) {
                                                          return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    DateFormat(
                                                                            'yMMMMEEEEd')
                                                                        .format(DateTime
                                                                            .now()),
                                                                    style: theme
                                                                        .bodyText2),
                                                                Text(
                                                                    DateFormat(
                                                                            'jm')
                                                                        .format(DateTime
                                                                            .now())
                                                                        .toString(),
                                                                    style: theme
                                                                        .bodyText2)
                                                              ]);
                                                        }),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                            width: 15),
                                                        Image.network(
                                                          "http://openweathermap.org/img/w/${currentSnapshot.data!.weather!.first.icon!}.png",
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '${currentSnapshot.data!.mian!.temp}° C  ',
                                                                  style: theme
                                                                      .bodyText1),
                                                              Text(
                                                                  '${currentSnapshot.data!.weather!.first.description}',
                                                                  style: theme
                                                                      .subtitle1White20),
                                                              Text(
                                                                  'min :${currentSnapshot.data!.mian!.tempMin}/max :${currentSnapshot.data!.mian!.tempMax}',
                                                                  style: theme
                                                                      .bodyText2
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12)),
                                                            ])
                                                      ],
                                                    ),
                                                    StreamBuilder(
                                                        stream: Stream.periodic(
                                                            const Duration(
                                                                seconds: 2)),
                                                        builder: (context,
                                                            snapshot) {
                                                          return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Last update ${context.watch<WeatherProvider>().lastUpdateTime}',
                                                                    style: theme
                                                                        .bodyText2),
                                                                InkWell(
                                                                    onTap: () {
                                                                      DBHelper()
                                                                          .addLastUpdate(
                                                                        DateFormat('jm')
                                                                            .format(DateTime.now()),
                                                                      );
                                                                      DBHelper()
                                                                          .selecetLastUpdate()
                                                                          .then(
                                                                              (value) {
                                                                        setState(
                                                                            () {
                                                                          provider.lastUpdateTime =
                                                                              value;
                                                                        });
                                                                      });
                                                                    },
                                                                    child: const Icon(
                                                                        Coolicons
                                                                            .refresh,
                                                                        color: Colors
                                                                            .white))
                                                              ]);
                                                        })
                                                  ])),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailWeather(
                                                          currentSnapshot:
                                                              currentSnapshot,
                                                          recentSearch: provider
                                                              .recentSearch!),
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
                                Text('Hourly Weather',
                                    style: provider.isDarkMode
                                        ? theme.headline1w
                                        : theme.headline1b),
                                Expanded(child: Container())
                              ]),
                              list.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 10,
                                          itemBuilder: ((context, index) =>
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  // height: 100,
                                                  width: 87,
                                                  decoration: BoxDecoration(
                                                      color: background,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.5)),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.network(
                                                            'http://openweathermap.org/img/w/${snapshot.data!.lst![index].weather!.first.icon!}.png'),
                                                        Text(
                                                            '${snapshot.data!.lst![index].main!.temp}° C',
                                                            style: provider
                                                                    .isDarkMode
                                                                ? theme
                                                                    .subtitle2White14
                                                                : theme
                                                                    .subtitle2black14),
                                                        Text(
                                                            DateFormat('Hm')
                                                                .add_Md()
                                                                .format(DateTime
                                                                    .parse(snapshot
                                                                        .data!
                                                                        .lst![
                                                                            index]
                                                                        .dtTxt!)),
                                                            style: provider
                                                                    .isDarkMode
                                                                ? theme
                                                                    .bodyTextWhite
                                                                : theme
                                                                    .bodyTextBrown)
                                                      ]))))),
                              const SizedBox(height: 5),
                              //Daily
                              Row(children: [
                                Text('Daily',
                                    style: provider.isDarkMode
                                        ? theme.headline1w
                                        : theme.headline1b),
                                Expanded(child: Container())
                              ]),
                              list[0]
                                      .weather!
                                      .first
                                      .description
                                      .toString()
                                      .contains('rain')
                                  ? noteCard()
                                  : Container(),
                              Expanded(
                                  flex: 2,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 70,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: const Color.fromRGBO(
                                                  210, 223, 255, 1),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ListTile(
                                              leading: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        154, 182, 255, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Image.network(
                                                  'http://openweathermap.org/img/w/${list[index].weather!.first.icon!}.png',
                                                ),
                                              ),
                                              title: Text(
                                                DateFormat('EEEE').format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        list[index]!.dt *
                                                            1000)),
                                                style: theme.subtitle2black14,
                                              ),
                                              subtitle: Text(
                                                  list[index]
                                                      .weather!
                                                      .first
                                                      .description!,
                                                  style: theme.bodyText3Brown),
                                              trailing: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        '${list[index].main!.feelsLike!}° C',
                                                        style: theme
                                                            .subtitle2black14),
                                                    const SizedBox(width: 10),
                                                    const Icon(
                                                        Coolicons.caret_right,
                                                        color: Colors.black)
                                                  ]),
                                              // onTap: () {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //         builder: (context) => DetailWeather(
                                              //             currentSnapshot: ),
                                              //       ));
                                              // },
                                            ));
                                      }))
                            ]);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })),
              ),
      ),
    );
  }

  Widget noteCard() {
    final provider = Provider.of<WeatherProvider>(context);
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: provider.isDarkMode
                ? const Color.fromRGBO(231, 117, 92, 0.4)
                : const Color.fromRGBO(231, 117, 92, 0.13)),
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
                            children: [
                              Text(
                                  "Tomorrow's weather is likely to rain this afternoon",
                                  maxLines: 3,
                                  softWrap: true,
                                  style: provider.isDarkMode
                                      ? theme.subtitle2White14
                                          .copyWith(height: 1.3)
                                      : theme.subtitle2black14
                                          .copyWith(height: 1.3)),
                              Text("Don't forget to bring an umbrella",
                                  style: provider.isDarkMode
                                      ? theme.bodyText3White
                                      : theme.bodyText3Brown)
                            ]))
                  ]))
        ]));
  }

  DropdownMenuItem<String> buildItem(String e) => DropdownMenuItem(
        value: e,
        child: Text(e,
            style: context.watch<WeatherProvider>().isDarkMode
                ? theme.bodyText2.copyWith(overflow: TextOverflow.ellipsis)
                : theme.bodyText2.copyWith(
                    overflow: TextOverflow.ellipsis, color: Colors.black)),
      );
}
