import 'package:dio/dio.dart';

class Request {
  /// 创建Dio请求头
  static Dio createDio() {
    BaseOptions _baseOptions = BaseOptions(
      baseUrl: 'http://127.0.0.1',
      connectTimeout: 30000,
      receiveTimeout: 40000,
      contentType: 'application/json; charset=utf-8',
    );

    Dio dio = Dio(_baseOptions);

    /// 添加请求拦截器
    dio.interceptors.add(HttpInterceptors());

    return dio;
  }

  /// get 请求
  static Future<dynamic> get(String path) async {
    Dio dio = Request.createDio();
    Response response = await dio.get(path);
    return response;
  }

  /// post 请求
  static Future<dynamic> post(String path, {dynamic data}) async {
    Dio dio = Request.createDio();
    Response response = await dio.post(path, data: data);
    return response;
  }

  /// put 请求
  static Future<dynamic> put(String path, {dynamic data}) async {
    Dio dio = Request.createDio();
    Response response = await dio.put(path, data: data);
    print(response);
  }

  /// delete 请求
  static Future<dynamic> delete(String path, {dynamic data}) async {
    Dio dio = Request.createDio();
    Response response = await dio.delete(path, data: data);
    print(response);
  }

  /// head 请求
  static Future<dynamic> head(String path, {dynamic data}) async {
    Dio dio = Request.createDio();
    Response response = await dio.head(path, data: data);
    return response;
  }

  ///patch 请求
  static Future<dynamic> patch(String path, {dynamic data}) async {
    Dio dio = Request.createDio();
    Response response = await dio.patch(path, data: data);
    return response;
  }

  /// download 请求
  static Future<dynamic> download(String urlPath, String savePath,
      {required Function(int, int) onReceiveProgress}) async {
    Dio dio = Request.createDio();
    Response response = await dio.download(urlPath, savePath,
        onReceiveProgress: onReceiveProgress);
    return response;
  }
}

/// 请求拦截器 请按照Api的规范自行封装
class HttpInterceptors extends Interceptor {
  /// 请求前做一些操作
  /// 注：一般针对请求头部以及封装token进行一些处理
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  /// 请求结束后返回数据前做一些操作
  /// 注：针对返回的数据进行进行一些返回的封装
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  /// 请求异常时进行一些操作
  /// 注：一般针对error做一些提示性的提示弹窗和日志的输出
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
