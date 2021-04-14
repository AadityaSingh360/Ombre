import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF0D111A),
        scaffoldBackgroundColor: Color(0xFF0D111A),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore;
  String name = "";
  TextEditingController searchController = TextEditingController();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor("#283444"),
                          border: Border.all(),
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      width: 300.0,
                      height: 55.0,
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            name = val.toLowerCase().trim();
                          });
                        },
                        cursorColor: Colors.blue,
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: HexColor("#283444")),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          filled: true,
                          hintText: 'Search for events, artists, or fans',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        controller: searchController,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor("#283444"),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
        // ignore: missing_required_param
        body: StreamBuilder<QuerySnapshot>(
          stream: (name != "" && name != null)
              ? FirebaseFirestore.instance
                  .collection('events')
                  .where('searchkeyword', arrayContains: name)
                  .snapshots()
              : FirebaseFirestore.instance.collection("events").snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      debugPrint('data reteieved ' + data['title']);
                      return Card(
                        color: Color(0xFF0D111A),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.network(
                                'https://smaller-pictures.appspot.com/images/dreamstime_xxl_65780868_small.jpg',
                                width: 110,
                                height: 70,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data['genre'],
                                      style: TextStyle(
                                        color: Color(0xFFF65C7C),
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data['title'],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
          },
        ),

        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: HexColor("0d111a"),
          buttonBackgroundColor: Color(0xFFF65C7C),
          height: 60.0,
          color: HexColor("#283444"),
          items: <Widget>[
            Icon(Icons.dashboard, size: 25, color: Colors.white),
            Icon(Icons.add, size: 25, color: Colors.white),
            Icon(Icons.event_seat, size: 25, color: Colors.white),
            Icon(Icons.search, size: 35, color: Colors.white),
          ],
          onTap: (index) {
            debugPrint("Current index is $index");
          },
        ),
      ),
    );
  }
}
