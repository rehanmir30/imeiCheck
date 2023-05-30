// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../controllers/common_controller.dart';
// import '../utils/constants.dart';
// import '../utils/helper.dart';
//
//
// class BaseClient {
//   final String tag = "BaseClient";
//   final CommonController controller = Get.find<CommonController>();
//
//   Future<bool> checkInternet() async {
//     try {
//       var response = await http
//           .get(Uri.parse("https://google.com"), headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Accept': 'application/json',
//       }).timeout(const Duration(seconds: timeOutDuration));
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         return false;
//       }
//     } on SocketException {
//       return false;
//     } on TimeoutException {
//       return false;
//     }
//   }
//
//   noInternet() async {
//     var res = await checkInternet();
//     closeLoadingDialog();
//     if (res) {
//       showAlert(
//           dialogType: DialogType.error,
//           title: "Unable To Connect To Server",
//           description:
//               "${"Unable To Connect To Server Description"} ${AppConstant.supportEmail}");
//     } else {
//       showAlert(
//           dialogType: DialogType.error,
//           title: "noInternet",
//           description: "");
//     }
//   }
//
//   connectionTimeOut() {
//     closeLoadingDialog();
//     showAlert(
//         dialogType: DialogType.error,
//         title: "Time Out Error",
//         description: "Check Internet Connection");
//   }
//
//   unAuthenticatedError(http.Response response, [bool isFromLogin = false]) {
//     if (isFromLogin) {
//       processRes(response: response, title: "Login Failed");
//     } else {
//       AwesomeDialog(
//         context: Get.context as BuildContext,
//         dialogType: DialogType.error,
//         width: 400,
//         onDismissCallback: (dismissType) {},
//         autoDismiss: false,
//         animType: AnimType.bottomSlide,
//         title: "Un-Authenticated Error Occurred",
//         desc: "Token Expired",
//         btnOkText: "Login Again",
//         btnOkOnPress: () {
//           // controller.logOutUser();
//           //use shared-Preference or (getStorage) for save local storage data
//         },
//       ).show();
//     }
//   }
//
//   static const int timeOutDuration = 20;
//
//   // GET
//   Future<dynamic> get(String url) async {
//     var uri = Uri.parse(url);
//     log("Url: $url");
//     log("Request Type: GET");
//     try {
//       var response = await http.get(uri, headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Accept': 'application/json',
//       }).timeout(const Duration(seconds: timeOutDuration));
//       log("Response StatusCode: ${response.statusCode}");
//       log("Response Body: ${response.body}");
//       return processResponse(response,);
//     } on SocketException {
//       // noInternet();
//     } on TimeoutException {
//       connectionTimeOut();
//     }
//   }
//
//   // POST
//   Future<dynamic> post(String url, dynamic jsonBody) async {
//     var uri = Uri.parse(url);
//     try {
//       log("Url: $url");
//       log("Request Type: POST");
//       log("Request Body: $jsonBody");
//       var response = await http.post(
//         uri,
//         body: jsonBody,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Accept': 'application/json',
//         },
//       ).timeout(const Duration(seconds: timeOutDuration));
//       log("Response StatusCode: ${response.statusCode}");
//       log("Response Body: ${response.body}");
//
//       return processResponse(response );
//     } on SocketException {
//       noInternet();
//     } on TimeoutException {
//       connectionTimeOut();
//     }
//   }
//
//
//   dynamic processResponse(http.Response response,) {
//     switch (response.statusCode) {
//       case 200:
//         return processRes(response: response);
//       case 201:
//         log("Response Body:  2${response.body}");
//         return processRes(response: response);
//       case 400:
//         processRes(response: response, title: "Bad Request Error Occurred");
//         return null;
//       case 401:
//         // Un Authorized
//         unAuthenticatedError(
//             response, false);
//             // response, url.contains("student/login") ? true : false);
//         return null;
//       case 403:
//         // Access Denied
//         processRes(response: response, title: "Access Denied Error Occurred");
//         return null;
//       case 405:
//         // Method Not Allowed
//         closeLoadingDialog();
//         showAlert(
//             dialogType: DialogType.error,
//             title: "Method Not Allowed Error",
//             description: "");
//         return null;
//       case 422:
//         // Un-Processable Entity
//         processRes(response: response, title: "Bad Request Error Occurred");
//         return null;
//       case 500:
//         // Server Error
//         processRes(response: response, title: "Server Error");
//         return null;
//       default:
//         // Unknown Error
//         processRes(response: response, title: "Unknown Error Occurred");
//         return null;
//     }
//   }
//
//   void parseErrorOccurred(String error) {
//     showAlert(
//         dialogType: DialogType.error,
//         title: "Data Parsing Error",
//         description: error);
//   }
//
//   processRes({String? title, required http.Response response}) {
//     try {
//       var data = jsonDecode(response.body);
//       if (data['status'].runtimeType == bool) {
//         if (!data['status']) {
//           var description = data['message'];
//           closeLoadingDialog();
//           showAlert(
//               dialogType: DialogType.error,
//               title: title ?? "Error Occurred",
//               description: description ?? "unknown Error Occurred");
//           return null;
//         } else {
//           closeLoadingDialog();
//           log("Response For Model: ${jsonEncode(data['data'])}");
//           return data['data'];
//         }
//       }
//     } catch (e, stacktrace) {
//       if (kDebugMode) {
//         print(stacktrace);
//       }
//       parseErrorOccurred(e.toString());
//     }
//     closeLoadingDialog();
//     return null;
//   }
// }
