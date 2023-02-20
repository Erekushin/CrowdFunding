import 'package:CrowdFund/helpers/gvariables.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../dialogs/snacks.dart';
import '../helpers/backHelper.dart';
import '../screens/entrance/login.dart';

class Services extends GetConnect {
  final crowdlog = logger(Services);

  /// [postRequest] post service request
  /// [data] request body data
  /// [token] check for token usage

  Future<Response> postRequest(
      Object bodyData, String url, bool token, String msgcode) async {
    Response response = const Response();
    try {
      response = await post(
        url,
        bodyData,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization':
              token == true ? "Bearer ${GlobalVariables.token}" : "",
          'code': msgcode
        },
      );
      crowdlog.wtf(
          "postreq info: $url  bodyData: $bodyData, msgcode $msgcode, token: ${GlobalVariables.token}");
      crowdlog.wtf(
          "postreq status: ${response.status}  statusText: ${response.statusText}, response.statusCode ${response.statusCode}, response: $response ");
    } catch (e) {
      crowdlog.wtf(e);
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
    Response response = const Response();
    try {
      response = await get(url, headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'authorization': token == true ? "Bearer ${GlobalVariables.token}" : "",
        'code': msgcode
      }, decoder: (data) {
        return data;
      });
      crowdlog.wtf(
          "getreq info: $url , msgcode $msgcode, token:  ${GlobalVariables.token} ");
      crowdlog.wtf(
          "getreq status: ${response.status}  statusText: ${response.statusText} ");
    } catch (e) {
      crowdlog.wtf(e);
      errorSnack('ямар нэгэн алдаа гарлаа $e');
      //garsan aldaag tsugluuldag base heregtei bna

    }
    return response;
  }

  /// [deleteRequest] delete service request
  /// [bodyData] request body data
  /// [token] check for token usage
  Future<Response> deleteRequest(String url, bool token, String msgcode) async {
    Response response = const Response();
    try {
      response = await delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization':
              token == true ? "Bearer ${GlobalVariables.token}" : "",
          'code': msgcode
        },
      );
      if (response.statusCode == 401) {
        // storage.erase();
        Get.to(() => const LoginScreen());
      }
    } catch (e) {
      crowdlog.wtf(e);
      errorSnack('ямар нэгэн алдаа гарлаа $e');
    }
    return response;
  }

  /// [putRequest] post service request
  /// [data] request body data
  /// [token] check for token usage

  Future<Response> putRequest(
      Object bodyData, String url, bool token, String msgcode) async {
    Response response = const Response();
    try {
      response = await put(
        url,
        bodyData,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization':
              token == true ? "Bearer ${GlobalVariables.token}" : "",
          'code': msgcode
        },
      );
      if (response.statusCode == 401) {
        // storage.erase();
        Get.to(() => const LoginScreen());
      }
    } catch (e) {
      crowdlog.wtf(e);
      errorSnack('ямар нэгэн алдаа гарлаа $e');
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
        'authorization': token == true ? "Bearer ${GlobalVariables.token}" : "",
      },
    );
  }
}

class AuthByThird {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final GoogleSignInAuthentication gAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('google auth dotor aldsan $e');
    }
  }
}
