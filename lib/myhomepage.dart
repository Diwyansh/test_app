import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/welcome.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const baseColor = Color(0xFF0A42D2);


  showNoti() async {
    var androidNotiDetails = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.max, priority: Priority.max);
    var IosNotiDetails =
        IOSNotificationDetails(presentAlert: true, presentSound: true);
    var notiDetails =
        NotificationDetails(android: androidNotiDetails, iOS: IosNotiDetails);
    await localNoti!
        .show(3, "Goodbye...", "Hope to see you Back Soon..", notiDetails);
  }

  List demoData = [
    {"img":"demoImg.png","title":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"},
    {"img":"demoImg1.jpg","title":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"},
    {"img":"demoImg2.jpg","title":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"},
  ];

  List demoData2 = [
    {"img":"demoImg3.jpg","title":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"},
    {"img":"demoImg4.jpg","title":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"},
  ];

  @override
  Widget build(BuildContext context) {
    var scWidth = MediaQuery.of(context).size.width;
    var scHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 0,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Scaffold.of(context).openDrawer();
                                          },
                                          child: Image.asset(
                                            "assest/icon.png",
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            "Home",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    )),
                                Flexible(
                                    flex: 0,
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.search_rounded,size: 26,),
                                        ),
                                        Image.asset(
                                          "assest/avatar.png",
                                          width: 40,
                                          height: 40,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const Text(
                            "Featured Articles",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: scWidth,
                        height: scHeight / 2.7,
                        margin: const EdgeInsets.only(top: 10, left: 20,bottom: 30),
                        child: ListView.builder(
                            itemCount: demoData.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: scWidth - scWidth / 1.8,
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 15, 15, 20),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                        child: Image(
                                          image: AssetImage("assest/${demoData[index]["img"]}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        height: 90,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    10.0)),
                                            gradient: LinearGradient(
                                                begin:
                                                Alignment.centerLeft,
                                                end:
                                                Alignment.centerRight,
                                                colors: [
                                                  Color(0xFF8BA4EE),
                                                  Color(0xFF6287F6),
                                                  Color(0xFF265CF3),
                                                  baseColor
                                                ]),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10.0,
                                                vertical: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  demoData[index]["title"],
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Read now"
                                                          .toUpperCase(),
                                                      style:
                                                      const TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                    Container(
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              100),
                                                          color: Colors
                                                              .white,
                                                        ),
                                                        padding:
                                                        const EdgeInsets
                                                            .all(5),
                                                        child: Center(
                                                            child:
                                                            SvgPicture
                                                                .asset(
                                                              "assest/Fav_Star.svg",
                                                              width: 20,
                                                              height: 20,
                                                              color: index
                                                                  .isOdd
                                                                  ? baseColor
                                                                  : Colors
                                                                  .black12,
                                                            ))),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: index == 0 ? false : true,
                                        child: Positioned(
                                          height: 40,
                                          width: 40,
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                BorderRadius.only(topLeft: Radius.circular(
                                                    10.0),bottomRight: Radius.circular(
                                                    15.0)),
                                                gradient: LinearGradient(
                                                    begin:
                                                    Alignment.topLeft,
                                                    end:
                                                    Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFF8BA4EE),
                                                      Color(0xFF6287F6),
                                                      Color(0xFF265CF3),
                                                      baseColor
                                                    ]),
                                              ),
                                              child: Center(
                                                  child: SvgPicture
                                                      .asset(
                                                    "assest/Premium.svg",
                                                    width: 20,
                                                    height: 20,
                                                    color: Colors
                                                        .white,
                                                  ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                       "Featured Videos",
                       style: TextStyle(
                           fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                    ),
                    Container(
                        width: scWidth,
                        height: scHeight / 4.7,
                        margin: const EdgeInsets.only(top: 10, left: 20,bottom: 50),
                        child: ListView.builder(
                            itemCount: demoData2.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: scWidth / 1.5,
                                      height: scHeight / 4.7,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 15, 0),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                                  child: Image(
                                                    image: AssetImage("assest/${demoData2[index]["img"]}"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  height: 40,
                                                  width: 40,
                                                  left: 0,
                                                  bottom: 0,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            100),
                                                        color: Colors
                                                            .white,
                                                      ),
                                                      margin: const EdgeInsets.only(left: 10,bottom: 10),
                                                      padding:
                                                      const EdgeInsets
                                                          .all(5),
                                                      child: Center(
                                                          child:
                                                          SvgPicture
                                                              .asset(
                                                            "assest/Fav_Star.svg",
                                                            width: 20,
                                                            height: 20,
                                                            color: index
                                                                .isEven
                                                                ? baseColor
                                                                : Colors
                                                                .black12,
                                                          ))),
                                                ),
                                                Positioned(
                                                  height: 30,
                                                  width: 70,
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      decoration: const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(topLeft: Radius.circular(
                                                            10.0),bottomRight: Radius.circular(
                                                            15.0)),
                                                        gradient: LinearGradient(
                                                            begin:
                                                            Alignment.topLeft,
                                                            end:
                                                            Alignment.bottomRight,
                                                            colors: [
                                                              Color(0xFF8BA4EE),
                                                              Color(0xFF6287F6),
                                                              Color(0xFF265CF3),
                                                              baseColor
                                                            ]),
                                                      ),
                                                      child: const Center(
                                                          child: Text("01:25:00",style: TextStyle(color: Colors.white),))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            demoData2[index]["title"],
                                            maxLines: 1,overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              height: 1.5,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                  ],
                ),
              ),
            );
          }
        ),
      drawer: drawer(),
        bottomNavigationBar: BottomAppBar(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Icon(Icons.home_outlined,color: baseColor,size: 24,)),
              Expanded(child: Image.asset("assest/MaskGroup19.png",width: 20,height: 20,)),
              Expanded(child: Image.asset("assest/MaskGroup18.png",width: 20,height: 20,)),
            ],
          ),
        ),),
    );
  }
}
