import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  Future<List> getImages() async {
    String url = "https://jsonplaceholder.typicode.com/photos";
    var uri = Uri.parse(url);
    var res = await http.get(uri);

    return res.statusCode == 200 ? jsonDecode(res.body) : null;
  }

  Future<List> getPost() async {
    String url = "https://jsonplaceholder.typicode.com/posts";
    var uri = Uri.parse(url);
    var res = await http.get(uri);

    return res.statusCode == 200 ? jsonDecode(res.body) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: getImages(),
          builder: (context,AsyncSnapshot<List> snapshot) {
            var feeds = snapshot.data;
            // print(feeds["count"]);
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,20,10),
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
                            "Featured Images",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    MainSlider(feeds),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20,30,20,10),
                      child: Text(
                        "Featured Posts",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NewsList(),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  ));
            }
          },
        ),
      ),
      drawer: drawer(),
    );
  }

  Widget MainSlider(feeds) {
    var scHeight = MediaQuery.of(context).size.height;
    var scWidth = MediaQuery.of(context).size.width;
    return Container(
        width: scWidth,
        height: scHeight / 3 - 30,
        child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (context) => PageView.builder(
                    itemCount: feeds.length,
                      itemBuilder: (context,index) => InteractiveViewer(child: Image.network(feeds[index]["url"]))));
                },
                child: Container(
                  height: scHeight / 3,
                  width: scWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 3.0,
                                    offset: Offset(2, 2),
                                    spreadRadius: 1)
                              ]),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: Image(
                            image: NetworkImage(feeds[index]["url"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black54]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feeds[index]["title"],
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 2),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Widget DivText(text, left, top, right, bottom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Row(
        children: [
          Container(
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget NewsList() {
    var scWidth = MediaQuery.of(context).size.width;
    return Container(
      width: scWidth - 40,
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder(
        future: getPost(),
        builder: (context, AsyncSnapshot<List> snapshot) => snapshot.hasData ? ListView.builder(
            shrinkWrap: true,primary: false,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, index) {
              return  GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (context) => PageView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index) => AlertDialog(title:Text(snapshot.data![index]["title"]) ,content: Text(snapshot.data![index]["body"]),)));
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  margin: const EdgeInsets.only(bottom: 9.0),
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.red))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: SizedBox(
                          width: scWidth - 60,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index]["title"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  height: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  snapshot.data![index]["body"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    size: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                                    child: Text(
                                      "1 day ago",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                                    child: Text(
                                      "| Delhi, India",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }) :  Container(
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ),
            )),
      ),
    );
  }
}
