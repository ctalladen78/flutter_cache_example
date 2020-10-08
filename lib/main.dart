import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cache_example/api_service.dart';
import 'package:cache_example/city.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cache_example/image_cache_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      // root screens
      routes: {

        "/": (context) => CityList()
        // "/city_detail": (context) => CityDetail()
      },
    );
  }
}

class CityList extends StatelessWidget {

  var apiService = ApiService();
  var imgCacheManager = ImageCacheManager.getInstance();


  // TODO add to city list
  // ApiService().addToCityList(
  //   City(cityName: "new city", cityPlaceId: "sdsdfsd", imageLink: "imagelink/image.jpg")
  // );
  Widget _buildNewCityForm(){return Form(child: Container());}


  Widget _buildCityItemLink(City city) {
          return ListTile(
            // leading: Image(image:NetworkImage(photoRef)),
            leading:CachedNetworkImage(imageUrl:city.imageLink, height: 100.0, width: 100, cacheManager: imgCacheManager),
            title: Text(city.cityName),
            subtitle: GestureDetector(
              child: Container(decoration: BoxDecoration(color: Colors.orangeAccent)),
              onTap: (){
              },
            ),
          );
  }


  Widget _buildCityList(){
    return StreamBuilder<List<City>>(
      stream: apiService.getCityListStream(),
      builder: (ctx, snapshot){
        print("STATUS ${snapshot.connectionState} SNAP ${snapshot.hasData}");
        if(snapshot.hasData && snapshot.connectionState == ConnectionState.active){
          var snapList = snapshot.data;
          print("SNAPLIST  $snapList");
          return ListView.builder(
            itemCount: snapList.length,
            itemBuilder: (ctx, index){
              return _buildCityItemLink(snapList[index]);
            },
          ); 
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // init stream state
    apiService.populateCityList();
    return Scaffold(
      body: _buildCityList(),
    );
  }

}

class UserAvatar {
  Future<Widget> _getUserImageAvatar(http.Client client) async {
    var response = await client.get('https://randomuser.me/api/'); // returns json
    if(response.statusCode == 200){
      Map<String, dynamic> parsed = jsonDecode(response.body);
      var uri = parsed["results"][0]["picture"]["large"];
      return new CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.white,
        child: new CircleAvatar(
            radius: 28.0,
            backgroundImage: new NetworkImage(uri)
        ),
      );
    }
    print("Image Uri error");
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _getDefaultAvatar(){
    return CircleAvatar(
        radius: 28.0,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 40.0)
    );
  }

  Widget getAvatar(){
    return FutureBuilder<Widget>(
      future: _getUserImageAvatar(http.Client()),
      initialData: _getDefaultAvatar(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // print("AVATAR ${snapshot.connectionState}");
        if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){

        }
        return snapshot.data;
      },
    );
  }

  Future<String> _getUserImageUri(http.Client client) async{
    String uri = "";
    var response = await client.get('https://randomuser.me/api/'); // returns json
    if(response.statusCode == 200){
      Map<String, dynamic> parsed = jsonDecode(response.body);
      uri = parsed["results"][0]["picture"]["large"];
    }
    return uri;
  }

  Widget getCoverAvatar(){
    return FutureBuilder<String>(
      future: _getUserImageUri(http.Client()),
      // initialData: _getDefaultAvatar(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
          var url = snapshot.data;
          return Container(
            height: 100,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              // image: DecorationImage(
              //   fit: BoxFit.cover,
                // image: CachedNetworkImageProvider(city.imageLink)
              // ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          );
        }
        return LinearProgressIndicator();
        // return CircularProgressIndicator();
      },
    );
  }
}
