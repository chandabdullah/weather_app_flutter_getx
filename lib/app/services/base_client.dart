import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/environment/environment.dart';
import '/app/routes/app_pages.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../config/translations/strings_enum.dart';
import '../components/custom_snackbar.dart';
import 'api_exceptions.dart';

enum RequestType {
  get,
  post,
  put,
  patch,
  delete,
}

class BaseClient {
  static final Dio _dio = Dio()
    ..options.headers = {
      // 'Authorization': "Bearer ${MySharedPref.getToken()}",
      'content-type': 'application/json',
      // 'Accept':contentType?? 'application/json',
    }
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ))
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (DioError error, handler) async {
          // if ((error.response?.statusCode == 401 &&
          //     (error.response?.data?["message"] == 'No authorization!' ||
          //         error.response?.data?["message"] == 'Invalid token!' ||
          //         error.response?.data?["message"] ==
          //             'Token has expired please login again!' ||
          //         error.response?.data?["message"] == 'No token found!'))) {
          //   if (error.response?.data?["message"] ==
          //       'Token has expired please login again!') {
          //     CustomSnackBar.showCustomSnackBar(
          //       title: Strings.ERROR.tr,
          //       message: Strings.TOKEN_HAS_EXPIRED_PLEASE_LOGIN_AGAIN.tr,
          //       color: Colors.red,
          //     );
          //   }

          //   if (Get.currentRoute == '/login') {
          //     return;
          //   }
          //   MySharedPref.removeToken();
          //   Get.deleteAll();
          //   Get.offAllNamed(Routes.LOGIN);
          // }
          return handler.next(error);
        },
      ),
    );

  // request request
  static safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      await onLoading?.call();
      // 2) try to perform http request
      late Response response;
      String base_url = EnvironmentConfig.BASE_URL;

      String apiUrl = url.contains(base_url) ? url : "$base_url/$url";
      if (requestType == RequestType.get) {
        response = await _dio.get(
          apiUrl,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              // ...headers,
              // 'Authorization': "Bearer ${MySharedPref.getToken()}",
              'content-type': 'application/json',
            },
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          apiUrl,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              // ...headers,
              // 'Authorization': "Bearer ${MySharedPref.getToken()}",
              'content-type': 'application/json',
            },
          ),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          apiUrl,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              // ...headers,
              // 'Authorization': "Bearer ${MySharedPref.getToken()}",
              'content-type': 'application/json',
            },
          ),
        );
      } else if (requestType == RequestType.patch) {
        response = await _dio.patch(
          apiUrl,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              // ...headers,
              // 'Authorization': "Bearer ${MySharedPref.getToken()}",
              'content-type': 'application/json',
            },
          ),
        );
      } else {
        response = await _dio.delete(
          apiUrl,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              // ...headers,
              // 'Authorization': "Bearer ${MySharedPref.getToken()}",
              'content-type': 'application/json',
            },
          ),
        );
      }
      // 3) return response (api done successfully)
      await onSuccess(response);
    } on SocketException catch (_) {
      Logger().e("- Socket: ${_.message}");
      // No internet connection
      _handleSocketException(url: url, onError: onError);
    } on DioError catch (error) {
      Logger().e("- Dio: ${error.error}");
      // dio error (api reach the server but not performed successfully
      _handleDioError(error: error, url: url, onError: onError);
    } on TimeoutException {
      // Api call went out of time
      _handleTimeoutException(url: url, onError: onError);
    } catch (error) {
      Logger().e("- Error: ${error}");
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  /// download file
  static download(
      {required String url, // file url
      required String savePath, // where to save file
      Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      required Function onSuccess}) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),

          // receiveTimeout: const Duration(
          //   seconds: 60,
          // ),
          // sendTimeout: const Duration(
          //   seconds: 60,
          // ),
        ),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException(
      {Function(ApiException)? onError,
      required String url,
      required Object error}) {
    if (onError != null) {
      onError(ApiException(
        message: error.toString(),
        url: url,
      ));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static _handleTimeoutException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
        message: Strings.serverNotResponding.tr,
        url: url,
      ));
    } else {
      _handleError(Strings.serverNotResponding.tr);
    }
  }

  /// handle timeout exception
  static _handleSocketException({
    Function(ApiException)? onError,
    required String url,
  }) {
    if (onError != null) {
      onError(ApiException(
        message: Strings.noInternetConnection.tr,
        url: url,
      ));
    } else {
      _handleError(Strings.noInternetConnection.tr);
    }
  }

  /// handle Dio error
  static _handleDioError(
      {required DioError error,
      Function(ApiException)? onError,
      required String url}) {
    // no internet connection
    if (error.error.toString().toLowerCase().contains('socket')) {
      if (onError != null) {
        return onError(ApiException(
          message: Strings.noInternetConnection.tr,
          url: url,
        ));
      } else {
        print("IN ELSE");
        return _handleError(Strings.noInternetConnection.tr);
      }
    }

    // check if the error is 500 (server problem)
    if (error.response?.statusCode == 500) {
      var exception = ApiException(
        message: Strings.serverError.tr,
        url: url,
        statusCode: 500,
      );

      if (onError != null) {
        return onError(exception);
      } else {
        return handleApiError(exception);
      }
    }

    var exception = ApiException(
        url: url,
        message: error.message.toString(),
        response: error.response,
        statusCode: error.response?.statusCode);
    if (onError != null) {
      return onError(exception);
    } else {
      return handleApiError(exception);
    }
  }

  /// handle error automaticly (if user didnt pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason
  static handleApiError(ApiException apiException) {
    String errorMessage = apiException.response?.data?["message"] ?? "";

    if (errorMessage.isNotEmpty) {
      CustomSnackBar.showCustomSnackBar(
        title: "Error",
        message: errorMessage,
        snackbarType: SnackbarType.danger,
      );
      return;
    }

    String msg = apiException.message;
    if (msg.isEmpty) return;
    CustomSnackBar.showCustomToast(
      message: msg,
      snackbarType: SnackbarType.danger,
    );
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    if (msg.isEmpty) return;
    CustomSnackBar.showCustomToast(
      message: msg,
      snackbarType: SnackbarType.danger,
    );
  }
}
