import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CacheableApiProvider {
  CacheableApiProvider();

  Future<dynamic> getItem(String baseUrl) async{
    var cache = CacheManager1.getInstance();
    // build http request string
    // var urlString = baseUrl + params; 
    // cache.getSingleFile(urlString);
    // print('Api GET, url $urlString');
    var responseJson;
    try {
      var file = await cache.getSingleFile(baseUrl);
      if (file != null && await file.exists()) {
        var res = await file.readAsString();
        // return _returnResponse(new http.Response(res, 200));
        // String responseJson = json.decode(utf8.decode(res.bodyBytes));
        // responseJson = json.decode(res.body.toString());
        responseJson = json.decode(res);
        return responseJson;
      }
      // return _returnResponse(new http.Response(null, 404));
      // final response = await http.get(_baseUrl + url);
      // responseJson = _returnResponse(response);
    } on SocketException {
      // 'No Internet connection'
      throw Error();
    }
    return responseJson;
  }
  // TODO 
  Future<dynamic> getList(String baseUrl, {Map<String, dynamic> params}) async{
    var cache = CacheManager.getInstance();
    // build http request string
    // var urlString = baseUrl + params; 
    // cache.getSingleFile(urlString);
    // print('Api GET, url $urlString');
    var responseJson;
    try {
      var file = await cache.getSingleFile(baseUrl);
      if (file != null && await file.exists()) {
        var res = await file.readAsString();
        // return _returnResponse(new http.Response(res, 200));
        // String responseJson = json.decode(utf8.decode(res.bodyBytes));
        // responseJson = json.decode(res.body.toString());
        responseJson = json.decode(res);
        return responseJson;
      }
      // return _returnResponse(new http.Response(null, 404));
      // final response = await http.get(_baseUrl + url);
      // responseJson = _returnResponse(response);
    } on SocketException {
      // 'No Internet connection'
      throw Error();
    }
    return responseJson;
  }
}

class CacheManager1 extends BaseCacheManager {
  static String _cacheId = "cache_id1";
  static CacheManager1 _instance1;

  static CacheManager1 getInstance() {
    if (_instance1 == null) {
      _instance1 = CacheManager1._();
    }
    return _instance1;
  }

  CacheManager1._() : super(
    _cacheId,
    maxAgeCacheObject: Duration(days: 10),
    maxNrOfCacheObjects: 100,
    fileFetcher: _getRemote
  );

  @override
  Future<String> getFilePath() async {
    var dir = await getTemporaryDirectory();
    return path.join(dir.path, _cacheId);
  }

  static Future<FileFetcherResponse> _getRemote(String url, {Map<String, String> headers}) async{
    try {
      var res = await http.get(url, headers: headers);
      // in case remote response doesn't provide cache-control
      res.headers.addAll({'cache-control': 'private, max-age=120'});
      return HttpFileFetcherResponse(res);
    } on SocketException {
      print('No internet connection');
    }
  }
}
class CacheManager extends BaseCacheManager {
  static String _cacheId = "cache_id";
  static CacheManager _instance;

  static CacheManager getInstance() {
    if (_instance == null) {
      _instance = CacheManager._();
    }
    return _instance;
  }

  CacheManager._() : super(
    _cacheId,
    maxAgeCacheObject: Duration(days: 10),
    maxNrOfCacheObjects: 100,
    fileFetcher: _getRemote
  );

  @override
  Future<String> getFilePath() async {
    var dir = await getTemporaryDirectory();
    return path.join(dir.path, _cacheId);
  }

  static Future<FileFetcherResponse> _getRemote(String url, {Map<String, String> headers}) async{
    try {
      var res = await http.get(url, headers: headers);
      // in case remote response doesn't provide cache-control
      res.headers.addAll({'cache-control': 'private, max-age=120'});
      return HttpFileFetcherResponse(res);
    } on SocketException {
      print('No internet connection');
    }
  }
}

