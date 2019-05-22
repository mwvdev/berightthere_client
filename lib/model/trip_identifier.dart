class TripIdentifier {
  final String identifier;

  TripIdentifier(this.identifier);

  factory TripIdentifier.fromJson(Map<String, dynamic> json) {
    return TripIdentifier(json['identifier']);
  }
}
