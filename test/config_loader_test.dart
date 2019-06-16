import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:test_api/test_api.dart';

import 'package:berightthere_client/config_loader.dart';

class TestAssetBundle extends CachingAssetBundle {
  final _configJson = '{ "beRightThereAuthority": "https://localhost:8080" }';

  @override
  Future<ByteData> load(String key) async {
    if (key == 'config.json') {
      return ByteData.view(Uint8List.fromList(utf8.encode(_configJson)).buffer);
    }

    return null;
  }
}

void main() {
  test('load returns a Config instance', () async {
    var config = await ConfigLoader().load(TestAssetBundle());

    expect(config.beRightThereAuthority, equals('https://localhost:8080'));
  });
}
