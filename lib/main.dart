import 'package:flutter/material.dart';
import 'package:cache_example/api_service.dart';
import 'package:cache_example/city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // TODO cache using cached_network_image
  Future<String> getPhotoRef(String pid){
    // build http request + query params
    var linkTemplate = "https://randomuser.me/api/";
          var response = await client.get(linkTemplate);
          Map<String, dynamic> parsed = jsonDecode(response.body);
      var uri = parsed["results"][0]["picture"]["large"];
    return uri;
  }

  // TODO add to city list
  // ApiService().addToCityList(
  //   City(cityName: "new city", cityPlaceId: "sdsdfsd", imageLink: "imagelink/image.jpg")
  // );
  Widget _buildNewCityForm(){return Form(child: Container());}

  Widget _buildCityItem({City city}) {
    return FutureBuilder<String>(
      future: getPhotoRef(city.cityPlaceId),
      builder: (ctx, snap){
        if(snap.hasData && snap.connectionState == ConnectionState.done){
          var photoRef = snap.data;
          
          return ListTile(
            // TODO cached_network_image
            leading: Image(image:NetworkImage(linkTemplate)),
            title: Text(city.cityName),
            subtitle: GestureDetector(
              child: Container(decoration: BoxDecoration(color: Colors.orangeAccent)),
              onTap: (){
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildCityList(){
    return StreamBuilder<List<City>>(
      stream: apiService.getCityListStream(),
      builder: (ctx, snapshot){
        print("STATUS ${snapshot.connectionState} SNAP ${snapshot.data}");
        if(snapshot.hasData && snapshot.connectionState == ConnectionState.active){
          var snapList = snapshot.data;
          print("SNAP  $snapList");
          return SliverList(
            delegate: SliverChildBuilderDelegate((context,index){
                  return _buildCityItem(city: snapList[index]);
            }, childCount: snapList.length),
          );
        }
        return SliverFillRemaining(
          child: Center(child: CircularProgressIndicator())
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // init stream state
    apiService.populateCityList();
    return Scaffold(
      body: CustomScrollView(
        slivers:[
         _buildCityList(),
        ]
      )
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
