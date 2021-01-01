import 'package:daikhopk/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daikhopk/utils/prefer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();
  runApp(MyApp());
}


class MyApp extends StatefulWidget{
  // Initialize Firebase
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState()');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness:
        Brightness.light //or set color with: Color(0xFF0000FF)
    ));
    return Center(
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (_) => Splash(),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor:Colors.black,
            fontFamily: 'FA',
          ),
        ),
      );
  }
}
