import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:berightthere_client/config.dart';

class ConfigLoader {
  Future<Config> load(AssetBundle assetBundle) async {
    return await assetBundle.loadStructuredData('config.json',
        (String s) async {
      return Config.fromJson(json.decode(s));
    });
  }
}
