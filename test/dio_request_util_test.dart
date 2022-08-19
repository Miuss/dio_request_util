import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:dio_request_util/dio_request_util.dart';

void main() {
  test('test get request', () async {
    Response response = await Request.get('http://www.baidu.com/');
    print(response);
  });
}
