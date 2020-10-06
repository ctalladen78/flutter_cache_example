
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:cache_example/city.dart';
import 'package:cache_example/cache_manager.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class ApiService {
  // StreamController, MultiStreamController
  var cityListCtrl = PublishSubject<List<City>>();

  Stream getCityListStream(){
    return cityListCtrl.stream;
  }

  // get city list
  void populateCityList() async {
    var result = await CacheableApiProvider(baseUrl: "http://localhost:5000/citylist").get(params: {"":""});
    // parse json response
    var cityList = List<City>();
    for(var result in result["data"]){
      // var c = City.fromJson(result);
      var c = City(cityName: result["city_name"], country: result["country"]);
      cityList.add(c);
      // print("CITY RESULT $cityList");
    }
    cityListCtrl.sink.add(cityList);
  }

  // TODO
  // add city to state + remote (cache is updated next remote call)
  void addToCityList(City city) async {
    // cityListCtrl.sink.add(result)
    // result = CacheManager.post(city)
  }

  dispose(){
    cityListCtrl.close();
  }

}