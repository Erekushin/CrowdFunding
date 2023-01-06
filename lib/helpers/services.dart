import 'package:gerege_app_v2/helpers/gvariables.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/route_manager.dart';

import '../helpers/backHelper.dart';
import '../screens/entrance/login.dart';

class Services extends GetConnect {
  final crowdlog = logger(Services);

  /// [postRequest] post service request
  /// [data] request body data
  /// [token] check for token usage

  Future<Response> postRequest(
      Object bodyData, String url, bool token, String msgcode) async {
    var response;
    try {
      response = await post(
        url,
        bodyData,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': token == true
              ? "Bearer ${GlobalVariables.gStorage.read("token")}"
              : "",
          'code': msgcode
        },
      );
      crowdlog.wtf(
          "status: ${response.status}  statusText: ${response.statusText}, response.statusCode ${response.statusCode} ");
      if (response.hasError) {
        switch (response.statusCode) {
          case null:
            response = const Response(
                statusCode: 444, body: {'message': "Интэрнэт ээ шалгана уу!"});
            break;
          case 401:
            Get.to(() => const LoginScreen());
            break;
        }
      }
    } catch (e) {
      //garsan aldaag tsugluuldag base heregtei bna
      response = const Response(statusCode: 500, body: {
        'message': "Ямар нэгэн алдаа гарлаа түр хүлээгээд дахин оролднуу!"
      });
    }
    return response;
  }

  /// [getRequest] get service request
  /// [bodyData] request body data
  /// [token] check for token usage
  Future<Response> getRequest(String url, bool token, String msgcode) async {
    var response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token == true
          ? "Bearer ${GlobalVariables.gStorage.read("token")}"
          : "",
      'code': msgcode
    }, decoder: (data) {
      return data;
    });
    crowdlog
        .wtf("status: ${response.status}  statusText: ${response.statusText} ");
    if (response.hasError) {
      switch (response.statusCode) {
        case null:
          response = const Response(
              statusCode: 444, body: {'message': "Интэрнэт ээ шалгана уу!"});
          break;
        case 401:
          Get.to(() => const LoginScreen());
          break;
      }
    }
    return response;
  }

  /// [deleteRequest] delete service request
  /// [bodyData] request body data
  /// [token] check for token usage
  Future<Response> deleteRequest(String url, bool token, String msgcode) async {
    final response = await delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': token == true
            ? "Bearer ${GlobalVariables.gStorage.read("token")}"
            : "",
        'code': msgcode
      },
    );
    if (response.statusCode == 401) {
      // storage.erase();
      Get.to(() => const LoginScreen());
    }
    return response;
  }

  /// [putRequest] post service request
  /// [data] request body data
  /// [token] check for token usage

  Future<Response> putRequest(
      Object bodyData, String url, bool token, String msgcode) async {
    final response = await put(
      url,
      bodyData,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': token == true
            ? "Bearer ${GlobalVariables.gStorage.read("token")}"
            : "",
        'code': msgcode
      },
    );
    if (response.statusCode == 401) {
      // storage.erase();
      Get.to(() => const LoginScreen());
    }
    return response;
  }

  /// [url] service url
  /// [formData] upload image formdata
  ///
  Future<Response> uploadImages(filePath, fileName, String url, bool token) {
    final form = FormData({
      'file': MultipartFile(filePath, filename: fileName),
    });
    return post(
      url,
      form,
      headers: <String, String>{
        'authorization': token == true
            ? "Bearer ${GlobalVariables.gStorage.read("token")}"
            : "",
      },
    );
  }

  // GetSocket userMessages() {
  //   return socket('https://yourapi/users/socket');
  // }
}
