import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/controles/current_weather.dart';
import 'package:weather_app/views/pages/home.dart';
import 'package:weather_app/views/themes.dart';

import 'db/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await DBHelper().insert();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(const RestartWidget(child: MyApp()));
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  // ignore: library_private_types_in_public_api
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      builder: (context, child) {
        final provider = Provider.of<WeatherProvider>(context, listen: false);
        getMode().then((value) {
          context.read<WeatherProvider>().toggleThemeMode(value);
        });

        return MaterialApp(
          title: 'Weather Teller',
          themeMode: provider.themeMode,
          theme: AllThemes.light,
          darkTheme: AllThemes.dark,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
        );
      },
    );
  }
}

const Color blue2E3A59 = Color.fromRGBO(46, 58, 89, 1);

Future<void> setMode(bool mode) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('darkMode', mode);
}

Future<bool> getMode() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool('darkMode') ?? false;
}
