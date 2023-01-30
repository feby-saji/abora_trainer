import 'package:abora/constants/vars.dart';
import 'package:abora/pages/home_page.dart';
import 'package:abora/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

bool _userLoggedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(SharedPrefVal().userLoggedIn) != null) {
    _userLoggedIn = prefs.getBool(SharedPrefVal().userLoggedIn)!;
  } else {
    _userLoggedIn = false;
  }
  if (prefs.getStringList(SharedPrefVal().availableSession) != null) {
    print('shared has dates getting it');
    prefs.getStringList(SharedPrefVal().availableSession)!.forEach((element) {
      var stringDate = element;
      DateTime parsedDate = DateTime.parse(stringDate);
      specialDates.value.add(parsedDate);
      specialDates.notifyListeners();
    });
  } else {}
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.green, // Sets color for all the descendant ElevatedButtons
        )),
        primarySwatch: Colors.blue,
      ),
      home: _userLoggedIn ? const HomeScreen() : const LoginPage(),
    );
  }
}
