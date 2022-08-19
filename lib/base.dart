class Base {

  static const bool inProduction = const bool.fromEnvironment("dart.vm.product");

  static const String baseUrl = 'http://127.0.0.1/api';
  static const String contenType = 'application/json; charset=utf-8';
  static const int requestTimeout = 100000000;
  static const List<int> successCode = [200, 0];
  static const String statusName = 'code';
  static const String messageName = 'message';

}