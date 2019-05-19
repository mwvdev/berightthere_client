import 'package:flutter/material.dart';

void main() => runApp(BeRightThereApp());

class BeRightThereApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be right there',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartTripPage(),
    );
  }
}

class StartTripPage extends StatelessWidget {
  void _handleStartPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be right there"),
      ),
      body: Center(
        child: Text(
          'Ready to start trip!',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleStartPressed,
        tooltip: 'Start trip',
        child: Icon(Icons.location_on),
      ),
    );
  }
}
