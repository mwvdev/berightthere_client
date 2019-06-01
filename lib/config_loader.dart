import 'dart:convert';

import 'package:berightthere_client/config.dart';
import 'package:flutter/services.dart';

class ConfigLoader {
  Future<Config> load(AssetBundle assetBundle) async {
    return await assetBundle.loadStructuredData('config.json',
        (String s) async {
      return Config.fromJson(json.decode(s));
    });
  }
}
