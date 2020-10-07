import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


class ImageCacheManager extends BaseCacheManager {
  static String _cacheId = "img_cache_id";
  static ImageCacheManager _instance;

  static ImageCacheManager getInstance() {
    if (_instance == null) {
      _instance = ImageCacheManager._();
    }
    return _instance;
  }

  ImageCacheManager._() : super(
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

