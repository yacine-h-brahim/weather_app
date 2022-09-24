import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controles/current_weather.dart';
import 'package:weather_app/views/pages/file.dart';

import 'package:weather_app/views/pages/home.dart';

import '../../db/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.initDB();

  await DBHelper().insert();
  //GET LAST ROW FROM RECENT SEARCH TABLE AND ATTECHE IT TO THE LOCATION PROVIDER :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherProvider>(
      create: (context) {
        return WeatherProvider();
      },
      child: MaterialApp(
        title: 'Weather Teller',
        theme: ThemeData(
          primaryTextTheme: const TextTheme(
              bodyText1: TextStyle(
            color: Colors.black,
          )),
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            // titleMedium: const TextStyle(
            //     fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20),

            headline1: TextStyle(
                fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
            headline2: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
            headline3: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),

            headline4: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      ),
    );
  }
}

const Color blue2E3A59 = Color.fromRGBO(46, 58, 89, 1);
