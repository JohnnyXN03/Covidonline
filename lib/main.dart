import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import './find.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;

  fetchData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Future fetchDatAll() async {
    fetchWorldWideData();
    fetchData();
    print('fetchData');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Covid Online'), actions: <Widget>[
        IconButton(icon: Icon(Icons.new_releases), onPressed: () {})
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: Search(countryData));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'World Wide Stats',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                          Divider(),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        'Total :- ' +
                                            worldData[index]['cases']
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        'Deaths :- ' +
                                            worldData[index]['deaths']
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'Recovered :- ' +
                                            worldData[index]['recovered']
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: worldData == null ? 0 : worldData.length,
                          )
                        ],
                      )),
                );
              },
            ),
          ],
        ),
      ),
      body: countryData == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange[300],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    height: 70,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 180,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                countryData[index]['country'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Image.network(
                                countryData[index]['countryInfo']['flag'],
                                height: 35,
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Confirmed  :- ' +
                                    countryData[index]['cases'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'Active  :- ' +
                                        countryData[index]['active'].toString(),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Recovered  :- ' +
                                    countryData[index]['recovered'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                'Deaths  :- ' +
                                    countryData[index]['deaths'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: countryData == null ? 0 : countryData.length,
            ),
    );
  }
}
