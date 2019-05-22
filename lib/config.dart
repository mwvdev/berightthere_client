class Config {
  final String apiEndpoint;

  Config(this.apiEndpoint);

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(json['apiEndpoint']);
  }
}
