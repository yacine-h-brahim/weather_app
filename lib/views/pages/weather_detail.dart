import 'package:coolicons/coolicons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weather_app/controles/air_qulity_index.dart';
import 'package:weather_app/controles/current_weather.dart';
import 'package:weather_app/controles/forecast.dart';
import 'package:weather_app/models/air_pollution_data.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/recent_search.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/views/themes.dart';

import '../../db/db.dart';

class DetailWeather extends StatefulWidget {
  const DetailWeather({
    required this.currentSnapshot,
    required this.recentSearch,
    super.key,
  });
  final AsyncSnapshot<CurrentWeather> currentSnapshot;
  final RecentSearch recentSearch;
  @override
  State<DetailWeather> createState() => _DetailWeatherState();
}

class _DetailWeatherState extends State<DetailWeather> {
  AllThemes theme = AllThemes();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final Color background = provider.isDarkMode
        ? const Color.fromRGBO(36, 36, 37, 1)
        : const Color.fromARGB(255, 245, 245, 245);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: provider.isDarkMode
          ? const Color.fromRGBO(32, 29, 29, 1)
          : const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
              child: const Icon(Coolicons.chevron_left, size: 25),
              onTap: () {
                Navigator.pop(context);
              }),
          title: Text(
              '${widget.recentSearch.name} ,${widget.recentSearch.country}',
              style: theme.headline2White),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            const Text('dark mode'),
                            Switch.adaptive(
                                value: provider.isDarkMode,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  provider.toggleThemeMode(value);
                                  setMode(value).whenComplete(() {
                                    RestartWidget.restartApp(context);
                                  });
                                })
                          ]))
                    ])
          ]),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: provider.isDarkMode
                          ? [
                              const Color.fromRGBO(79, 127, 250, 1),
                              const Color.fromRGBO(51, 95, 209, 1)
                            ]
                          : provider.isNight()
                              ? [
                                  const Color.fromRGBO(76, 78, 83, 1),
                                  const Color.fromRGBO(12, 18, 36, 1),
                                ]
                              : [
                                  const Color.fromRGBO(79, 128, 250, 1),
                                  const Color.fromRGBO(55, 100, 215, 1),
                                  const Color.fromRGBO(51, 95, 209, 1)
                                ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 30),
                    Text(DateFormat('yMMMMEEEEd').format(DateTime.now()),
                        style: theme.bodyText2),
                    Image.network(
                      "http://openweathermap.org/img/w/${widget.currentSnapshot.data!.weather!.first.icon!}.png",
                    ),
                    const SizedBox(height: 15),
                    Text('${widget.currentSnapshot.data!.mian!.feelsLike}° C',
                        style: theme.bodyText1),
                    Text(
                        '${widget.currentSnapshot.data!.weather!.first.description}',
                        style: theme.subtitle1White20),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: DBHelper().selecetLastUpdate(),
                        builder: (context, snapshot) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Last update ${snapshot.data}',
                                    style: theme.bodyText2),
                                InkWell(
                                    onTap: () {
                                      DBHelper().addLastUpdate(
                                        DateFormat('jm').format(DateTime.now()),
                                      );
                                      DBHelper()
                                          .selecetLastUpdate()
                                          .then((value) {
                                        setState(() {
                                          provider.lastUpdateTime = value;
                                        });
                                      });
                                    },
                                    child: const Icon(Coolicons.refresh,
                                        color: Colors.white))
                              ]);
                        }),
                    const SizedBox(height: 15),
                  ])),

          const SizedBox(height: 5),
          //Hourly Weather
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: [
              Text(
                'Hourly Weather',
                style:
                    provider.isDarkMode ? theme.headline1w : theme.headline1b,
              ),
              Expanded(child: Container())
            ]),
          ),
          FutureBuilder<ForecastFiveThree?>(
              future: ForecastFiveThreeProvider.getForcast(
                  widget.recentSearch.lat, widget.recentSearch.lon),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.16,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: ((context, index) => Container(
                              margin: const EdgeInsets.only(right: 10),
                              // height: 100,
                              width: 87,
                              decoration: BoxDecoration(
                                  color: background,
                                  borderRadius: BorderRadius.circular(7.5)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        'http://openweathermap.org/img/w/${snapshot.data!.lst![index].weather!.first.icon!}.png'),
                                    Text(
                                        '${snapshot.data!.lst![index].main!.temp}° C',
                                        style: provider.isDarkMode
                                            ? theme.subtitle2White14
                                            : theme.subtitle2black14),
                                    Text(
                                        DateFormat('Hm').add_Md().format(
                                            DateTime.parse(snapshot
                                                .data!.lst![index].dtTxt!)),
                                        style: provider.isDarkMode
                                            ? theme.bodyTextWhite
                                            : theme.bodyTextBrown)
                                  ])))));
                } else if (snapshot.hasError) {
                  Fluttertoast.showToast(msg: snapshot.error.toString());
                  return const CircularProgressIndicator();
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: [
              Text(
                'Information Details',
                style:
                    provider.isDarkMode ? theme.headline1w : theme.headline1b,
              ),
              Expanded(child: Container())
            ]),
          ),
          FutureBuilder<AirPollutionData?>(
              future: AirQulity().getAirQulity(
                  widget.recentSearch.lat, widget.recentSearch.lon),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Fluttertoast.showToast(msg: snapshot.error.toString());
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return Container(
                      margin: const EdgeInsets.only(
                          right: 16, left: 16, bottom: 5, top: 2),
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: background),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16),
                            CircularPercentIndicator(
                              animation: true,
                              backgroundColor:
                                  const Color.fromRGBO(228, 228, 228, 1),
                              animationDuration: 1500,
                              radius: 30.0,
                              lineWidth: 5.0,
                              percent: AirPollutionData.getMarks(snapshot
                                      .data!.list!.first.main!.aqi)['perc'] /
                                  100,
                              animateFromLastPercent: true,
                              startAngle: 180,
                              center: Text(
                                  "${AirPollutionData.getMarks(snapshot.data!.list!.first.main!.aqi)['perc']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AirPollutionData.getMarks(snapshot
                                        .data!.list!.first.main!.aqi)['color'],
                                  )),
                              progressColor: AirPollutionData.getMarks(snapshot
                                  .data!.list!.first.main!.aqi)['color'],
                            ),
                            const SizedBox(width: 5),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AQI -${AirPollutionData.getMarks(snapshot.data!.list!.first.main!.aqi)['name']}',
                                    style: provider.isDarkMode
                                        ? theme.subtitle2White14
                                        : theme.subtitle2black14,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      child: Text(
                                          AirPollutionData.getMarks(snapshot
                                              .data!
                                              .list!
                                              .first
                                              .main!
                                              .aqi)['description'],
                                          maxLines: 4,
                                          softWrap: true,
                                          style: provider.isDarkMode
                                              ? theme.bodyText3White.copyWith(
                                                  height: 1.2, fontSize: 12)
                                              : theme.bodyText3Brown.copyWith(
                                                  height: 1.2, fontSize: 12)))
                                ])
                          ]));
                }
                return const CircularProgressIndicator();
              }),

          Container(
            height: MediaQuery.of(context).size.height * .19,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardMoreDetail(
                        '${widget.currentSnapshot.data!.mian!.humidity} %',
                        'Humidity',
                        const Icon(
                          Remix.blaze_line,
                          size: 25,
                          color: Color.fromRGBO(60, 110, 239, 1),
                        )),
                    cardMoreDetail(
                        '${widget.currentSnapshot.data!.mian!.pressure} hPa',
                        'Air pressure',
                        const Icon(
                          Remix.haze_2_line,
                          size: 25,
                          color: Color.fromRGBO(60, 110, 239, 1),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardMoreDetail(
                        '${widget.currentSnapshot.data!.wind!.speed} km/h',
                        'Wind velocity',
                        const Icon(
                          Remix.windy_line,
                          size: 25,
                          color: Color.fromRGBO(60, 110, 239, 1),
                        )),
                    cardMoreDetail(
                        '${widget.currentSnapshot.data!.clouds!.all}%',
                        'Fog',
                        const Icon(
                          Remix.mist_line,
                          size: 25,
                          color: Color.fromRGBO(60, 110, 239, 1),
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget cardMoreDetail(String title, String subTitle, Icon icon) {
    final provider = Provider.of<WeatherProvider>(context);
    Color background = provider.isDarkMode
        ? const Color.fromRGBO(36, 36, 37, 1)
        : const Color.fromARGB(255, 245, 245, 245);
    return Container(
        padding: const EdgeInsets.only(top: 5),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: background),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              icon,
              const SizedBox(width: 12),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: provider.isDarkMode
                            ? theme.subtitle2White14
                            : theme.subtitle2black14),
                    Text(subTitle,
                        style: provider.isDarkMode
                            ? theme.bodyText3White
                            : theme.bodyText3Brown)
                  ])
            ]));
  }
}
//
