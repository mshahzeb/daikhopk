import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daikhopk/utils/prefer.dart';
import 'package:daikhopk/utils/routes.dart';

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
        systemNavigationBarColor: Colors.grey[400],
//        statusBarColor: Styles.blueColor,
        statusBarIconBrightness:
        Brightness.light //or set color with: Color(0xFF0000FF)
    ));
    return Center(
        child: MaterialApp(
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRoute,

          theme: ThemeData(
            primaryColor:Colors.black,
            fontFamily: 'FA',
          ),
        ),
      );
  }
}
