import 'package:meta/meta.dart';

@immutable
class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}
