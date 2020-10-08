
import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:cache_example/city.dart';
import 'package:cache_example/cache_manager.dart';

class ApiService {
  // StreamController, MultiStreamController
  var cityListCtrl = PublishSubject<List<City>>();
  var randomUser;
  var client = http.Client();

  Stream getCityListStream(){
    return cityListCtrl.stream;
  }

  // randomuser returns a different json response per call
  // ideally you want a deterministic response
  // get city list
  void populateCityList() async {
    var result = await CacheableApiProvider().getList("http://localhost:5000/citylist");
    var cityList = List<City>();
    for(var result in result["data"]){
      // var c = City.fromJson(result);
      var c = City(cityName: result["city_name"], country: result["country"], imageLink: result["image_link"]);
      cityList.add(c);
      // print("CITY RESULT $cityList");
    }
    cityListCtrl.sink.add(cityList);
  }

  // add city to state + remote (cache is updated next remote call)
  void addToCityList(City city) async {
    // cityListCtrl.sink.add(result)
    // result = CacheManager.post(city)
  }

  dispose(){
    cityListCtrl.close();
  }

}