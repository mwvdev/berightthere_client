import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key('loadingScreen'),
        appBar: AppBar(
          title: Text('Be right there'),
        ),
        body: Center(
          child: CircularProgressIndicator(key: Key('progressIndicator')),
        ));
  }
}
