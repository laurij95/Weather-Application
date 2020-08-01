import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather App',
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  String _weather = "";
  String _locality = "";
  double _temp = 0.0;

  Future<Position> getPosition() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Placemark> getPlacemark(double latitude, double longitude) async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude);

    return placemark[0];
  }

  Future<String> getData(double latitude, double longitude) async{
    String api = 'http://api.openweathermap.org/data/2.5/forecast';
    String appId = '5f588c0f92ef30267fd749ceb12605d8';

    String url = '$api?lat=$latitude&lon=$longitude&APPID=$appId';

    http.Response response = await http.get(url);

    print(url);

    Map parsed = json.decode(response.body);
    return parsed['list'][0]['weather'][0]['description'];
  }

  Future<double> getTemp(double latitude, double longitude) async{
    String api = 'http://api.openweathermap.org/data/2.5/forecast';
    String appId = '5f588c0f92ef30267fd749ceb12605d8';

    String url = '$api?lat=$latitude&lon=$longitude&APPID=$appId';

    http.Response response = await http.get(url);

    print(url);

    Map parsed = json.decode(response.body);
    return(parsed['list'][0]['main']['temp']);
  }

  @override
  void initState(){
    super.initState();
    getPosition().then((position){
      getPlacemark(position.latitude, position.longitude).then((data){
        getData(position.latitude, position.longitude).then((weather){
          getTemp(position.latitude, position.longitude).then((temp){
            setState(() {
              _locality = data.locality;
              _weather = weather;
              _temp = temp;
              print(_temp);
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Weather App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: TextField(
                    style: TextStyle(color:  Colors.black, fontSize: 25),
                    decoration: InputDecoration(
                      hintText: 'Search another location...',
                      hintStyle: TextStyle(color:  Colors.black, fontSize: 18.0),
                      suffixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
           Column(
             children: [
               Center(
                 child: Text('$_temp', style:  TextStyle(color: Colors.black, fontSize: 40.0))
               ),

                Center(
                    child: Text('$_locality', style: TextStyle(color: Colors.black, fontSize: 40.0))
                ),
              ],
            )
          ],
      ),

    );
  }










}
