import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'base.dart';

class Request {
  /// 创建Dio请求头
  static Dio createDio() {
    BaseOptions _baseOptions = BaseOptions(
      baseUrl: Base.baseUrl,
      connectTimeout: Base.requestTimeout,
      receiveTimeout: Base.requestTimeout,
      contentType: Base.contenType,
    );

    Dio dio = Dio(_baseOptions);

    /// 添加请求拦截器
    dio.interceptors.add(HttpInterceptors());

    return dio;
  }

  // 处理 Dio 异常
  static String _dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return "网络连接超时，请检查网络设置";
      case DioErrorType.receiveTimeout:
        return "服务器异常，请稍后重试！";
      case DioErrorType.sendTimeout:
        return "网络连接超时，请检查网络设置";
      case DioErrorType.response:
        return "服务器异常，请稍后重试！";
      case DioErrorType.cancel:
        return "请求已被取消，请重新请求";
      case DioErrorType.other:
        return "网络异常，请稍后重试！";
      default:
        return "Dio异常";
    }
  }

  // 处理 Http 错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    EasyLoading.showError(message);
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

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    ///执行加载动画

    EasyLoading.show();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = response.data;
      print(data);
      if (Base.successCode.contains(data["code"])) {
        EasyLoading.dismiss();
        return handler.next(response);
      } else {
        /// 处理业务错误代码
        EasyLoading.showError('错误：${response.data[Base.messageName]}');
      }
    } else {
      /// 处理Http错误代码
      Request._handleHttpError(response.statusCode!);
    }
  }

  /// 请求异常时进行一些操作
  /// 注：一般针对error做一些提示性的提示弹窗和日志的输出
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    /// 处理Dio请求错误
    EasyLoading.showError(Request._dioError(err));
  }
}
