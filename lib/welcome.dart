import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/main.dart';
import 'package:test_app/myhomepage.dart';
import 'package:timezone/data/latest.dart' as tZone;
import 'package:timezone/timezone.dart' as tZone;
import 'package:http/http.dart' as http;

import 'firstpage.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

final _formKey = GlobalKey<FormState>();

class _WelcomeState extends State<Welcome> {

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _hidePass = true;

  addUser(token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "$token");
    print("Data added");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  showNoti() async {
    tZone.initializeTimeZones();
    var tzName = tZone.local;
    var timeZone = tZone.TZDateTime.from(DateTime.now().add(Duration(minutes: 1)), tzName);
    var androidNotiDetails = AndroidNotificationDetails("channelId", "channelName", "channelDescription",importance: Importance.max,priority: Priority.max);
    var IosNotiDetails = IOSNotificationDetails(presentAlert: true,presentSound: true);
    var notiDetails = NotificationDetails(android: androidNotiDetails,iOS: IosNotiDetails);
    await localNoti!.show(1, "Welcome", "You have successfully Logged In", notiDetails);
    await localNoti!.zonedSchedule(2, "Hello", "We hope you are enjoying our app.", timeZone,notiDetails,androidAllowWhileIdle: true,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Widget build(BuildContext context) {

    Future checkLogin(user,pass) async {
      Uri uri = Uri.parse("https://reqres.in/api/login");
      var res = await http.post(uri,body: {
        "email": "$user",
        "password": "$pass"
      });
      if(res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        if(data["token"] != ""){
          addUser(data["token"]);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FirstPage()));
          showNoti();
          // print("LoggedIn");
        } else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please check Username or Password...")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please check Username or Password...")));
        print("Something is wrong");
      }
      // print(res.body);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: (){FocusScope.of(context).unfocus();},
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: SweepGradient(colors: [
            Colors.blue,
            Color(0x0f3773db),
            Colors.blue,
          ])),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text("Hello Guest,",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20,top: 20),
                        child: TextFormField(
                          controller: _username,
                          validator: (val) =>
                            val!.isNotEmpty ? null : "Please Enter Username",
                          decoration: const InputDecoration(
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white70,
                              filled: true,
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          controller: _password,
                          validator: (val) =>
                            val!.isNotEmpty ? null : "Please Enter Password",
                          obscureText: _hidePass ? true : false,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white70,
                              filled: true,
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: (){
                                  if(_hidePass == true) {
                                    setState(() {
                                      _hidePass = false;
                                    });
                                  } else {
                                    setState(() {
                                      _hidePass = true;
                                    });
                                  }
                                },
                                icon:Icon(Icons.remove_red_eye_outlined,color: Colors.white,))
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                checkLogin(_username.text,_password.text);
                              }
                            }, child: const Text("Login")),
                      ),
                      const Divider(
                        color: Colors.white70,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text(
                            "SignUp",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
