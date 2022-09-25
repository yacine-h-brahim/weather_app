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
  String? lastUpdateTime = '';

  @override
  void initState() {
    // DBHelper().selecetLastUpdate().then((value) {
    //   setState(() {
    //     lastUpdateTime = value;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WeatherProvider>(context);
    var theme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          child: const Icon(
            Coolicons.chevron_left,
            size: 25,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${widget.recentSearch.name}',
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
            size: 25,
          ),
          SizedBox(width: 16)
        ],
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: provider.isNight()
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
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    Image.network(
                      "http://openweathermap.org/img/w/${widget.currentSnapshot.data!.weather!.first.icon!}.png",
                    ),
                    const SizedBox(height: 15),
                    Text('${widget.currentSnapshot.data!.mian!.feelsLike}° C',
                        style: theme.headline2),
                    Text(
                        '${widget.currentSnapshot.data!.weather!.first.description}',
                        style: theme.headline3),
                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: DBHelper().selecetLastUpdate(),
                        builder: (context, snapshot) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Last update ${snapshot.data}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
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
              const Text(
                'Hourly Weather',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 20),
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
                                  color:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  borderRadius: BorderRadius.circular(7.5)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        'http://openweathermap.org/img/w/${snapshot.data!.lst![index].weather!.first.icon!}.png'),
                                    Text(
                                        '${snapshot.data!.lst![index].main!.temp}° C',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(32, 28, 28, 1),
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        DateFormat('Hm').add_Md().format(
                                            DateTime.parse(snapshot
                                                .data!.lst![index].dtTxt!)),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(73, 67, 67, 1)))
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
              const Text(
                'Information Details',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 20),
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
                          color: const Color.fromRGBO(250, 250, 250, 1)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              animation: true,
                              backgroundColor:
                                  const Color.fromRGBO(228, 228, 228, 1),
                              animationDuration: 1500,
                              radius: 30.0,
                              lineWidth: 5.0,
                              percent: AirPollutionData.getMarks(
                                  snapshot.data!.list!.first.main!.aqi)['perc'],
                              animateFromLastPercent: true,
                              startAngle: 180,
                              center: Text(
                                "${AirPollutionData.getMarks(snapshot.data!.list!.first.main!.aqi)['perc'] * 100}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      //TODO: GREEN IF AQI IN GOOD STATE ELSE RED OR ORANG
                                      AirPollutionData.getMarks(snapshot.data!
                                          .list!.first.main!.aqi)['color'],
                                ),
                              ),
                              progressColor: AirPollutionData.getMarks(snapshot
                                  .data!.list!.first.main!.aqi)['color'],
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AQI -${AirPollutionData.getMarks(snapshot.data!.list!.first.main!.aqi)['name']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .7,
                                      child: Text(
                                          AirPollutionData.getMarks(snapshot
                                              .data!
                                              .list!
                                              .first
                                              .main!
                                              .aqi)['description'],
                                          maxLines: 4,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            height: 1.2,
                                          )))
                                ])
                          ]));
                }
                return const CircularProgressIndicator();
              }),
          Expanded(
            flex: 1,
            child: Padding(
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
            ),
          )
        ],
      ),
    );
  }

  Widget cardMoreDetail(String title, String subTitle, Icon icon) => Container(
        padding: const EdgeInsets.only(top: 5),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromRGBO(250, 250, 250, 1)),
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
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(subTitle,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w400))
                ],
              )
            ]),
      );
}
//
