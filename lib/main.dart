import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/welcome.dart';

import 'firstpage.dart';

FlutterLocalNotificationsPlugin? localNoti = FlutterLocalNotificationsPlugin();
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final androidSetting = AndroidInitializationSettings('app_icon');
  const IosSettings = IOSInitializationSettings(
                        requestAlertPermission: true,
                        requestBadgePermission: true,
                        requestSoundPermission: true,
                      );
  final initSetting = InitializationSettings(android: androidSetting,iOS: IosSettings);
  await localNoti!.initialize(initSetting);
  var prefs = await SharedPreferences.getInstance();
  var login = prefs.getString("token");
  if(login == null){
    isLoggedIn = false;
    print(login);
  }else {
    isLoggedIn = true;
    print("token $login");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green House',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? FirstPage() : Welcome(),
    );
  }
}
