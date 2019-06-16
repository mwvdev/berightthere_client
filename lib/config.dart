class Config {
  final String beRightThereAuthority;

  Config(this.beRightThereAuthority);

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(json['beRightThereAuthority']);
  }
}
