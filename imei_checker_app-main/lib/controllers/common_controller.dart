import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart' show parseFragment;
import 'package:html/dom.dart' as html;
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:imei/controllers/BankTransferController.dart';
import 'package:imei/model/BankKeyModel.dart';
import 'package:imei/screens/add_fund/top_up_history_screen.dart';
import 'package:imei/screens/result/result_details_screen.dart';
import 'package:imei/widgets/TransactionPopup.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imei/controllers/InvoiceController.dart';
import 'package:imei/controllers/OrderListController.dart';
import 'package:imei/controllers/app_exception.dart';
import 'package:imei/controllers/authController.dart';
import 'package:imei/controllers/services_controller.dart';
import 'package:imei/model/AdminBankAccuonts.dart';
import 'package:imei/model/InvoiceModel.dart';
import 'package:imei/model/OrderModel.dart';
import 'package:imei/model/ServiceCatagoryModel.dart';
import 'package:imei/model/ServicesModel.dart';
import 'package:imei/model/UserModel.dart';
import 'package:imei/screens/auth/login_screen.dart';
import 'package:imei/screens/welcome_screen.dart';
import 'package:imei/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/InvoicePost.dart';
import '../model/signup_model.dart';
import '../utils/helper.dart';
import '../utils/logger.dart';
import '../widgets/InvoicePopup.dart';
import '../widgets/custom_buttom_navigation.dart';
import 'AdminAccountsController.dart';
import '../model/InvoicePost.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CommonController extends GetxController {
  final String tag = "CommonController";
  SharedPreferences? sharedPreferences;
  BuildContext? context;
  bool? userBool;
  List<String> _userNames = [];

  List<String> get userNames => _userNames;
  List <dynamic> _bulkList = [];

  List <dynamic> get bulkList => _bulkList;

  List <dynamic> _duplicateBulkList = [];

  List <dynamic> get duplicateBulkList => _duplicateBulkList;

  BankKeyModel? _bankKeyModel;

  BankKeyModel? get bankKeyModel => _bankKeyModel;

  File? _profImage;

  File? get profImage => _profImage;

  setProfImage(File? file) async {
    _profImage = file;
    update();
  }

  setBankKeys(BankKeyModel bank) async {
    _bankKeyModel = bank;
    print("BANK KEY ADDED");
    update();
  }

  setBulkData(value) async {
    _bulkList.add(value);
    update();
  }

  setDuplicateBulkData(order) async {
    _duplicateBulkList.add(order);
    update();
  }


  String? abc;

  setUserNames(List<String> usernames) async {
    _userNames = usernames;
    update();
  }

  ///Login Screen Variables
  Rx<bool> loginCheckBoxValue = false.obs;

  ///Sign Up Screen Variables
  var isSignUpCheckBoxValue = false.obs;
  var isEditProfileCheckBoxValue = false.obs;

  ///IMEI_Check Screen Variables
  Rx<bool> imeiSelectTabValue = false.obs;
  Rx<bool> bulkDuplicateCheckBoxValue = false.obs;
  Rx<bool> bulkEmailCheckBoxValue = false.obs;

  bool _searching = false;

  bool get searching => _searching;

  bool _searchingInvoices = false;

  bool get searchingInvoices => _searchingInvoices;

  setSearching(bool value) async {
    _searching = value;
    update();
  }

  setInvoiceSearching(bool value) async {
    _searchingInvoices = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    Logger.info(tag, "Inside onInit");
    getBankKeys();
    getAdminBankAccounts();
    getAllUserNames();
    // _getSharedPrefValues();
  }

  getBankKeys() async {
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    // var body = '';
    try {
      // showLoadingDialog();
      var url = Uri.parse(
        AppConstant.getBankKeysUrl,
      );
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      final response = await http.get(url, headers: header,);
      //closeLoadingDialog();
      var responseJson = jsonDecode(response.body.toString());
      // var data = SignUpModel.fromJson(responseJson);
      if (response.statusCode == 200) {
        BankKeyModel Model = BankKeyModel.fromMap(responseJson[0]);
        print(Model.paypalClientId.toString());
        await setBankKeys(Model);
      }
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  isFirstTime() async {
    // sharedPreferences = await SharedPreferences.getInstance();
    // return (sharedPreferences!
    //         .getBool(SharedPreferencesKeys.introSharedPerfKey.toString()) ??
    //     false);
  }

  Future<void> _getSharedPrefValues() async {
    // sharedPreferences = await SharedPreferences.getInstance();
    // userBool = (sharedPreferences!
    //         .getBool(SharedPreferencesKeys.loginSharedPerfKey.toString()) ??
    //     false);
    // userCountryCode = (sharedPreferences!.getString(
    //         SharedPreferencesKeys.userCountryCodeSharedPerfKey.toString()) ??
    //     'null');
    // userPhoneNumSharedPref = (sharedPreferences!.getString(
    //         SharedPreferencesKeys.userPhoneNumberSharedPerfKey.toString()) ??
    //     'null');
    Logger.info(tag, 'userBool - ${userBool.toString()}');
  }

  startSplashScreenTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, _navigatorToNextPage);
  }

  _navigatorToNextPage() async {
    Get.offAll(const WelcomeScreen());
  }

  Future updateWallet(amount) async {
    AuthController authController = Get.find<AuthController>();
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body =
        '{"username": "${authController.userModel?.userName
        .trim()}","wallet": "${amount}"}';

    try {
      showLoadingDialog();
      var url = Uri.parse(
        AppConstant.walletPostUrl,
      );
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      //closeLoadingDialog();
      var responseJson = jsonDecode(response.body.toString());
      // var data = SignUpModel.fromJson(responseJson);
      if (responseJson['success'] == 1) {
        showToast('Transaction successfully');
      }
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Sign up user method
  Future<SignUpModel?> signUpUser(
      {required String email, required String userName, required String password, required String phone}) async {
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body =
        '{"email": "${email.trim()}","username": "${userName
        .trim()}","password": "${password.trim()}","phone": "00000000000"}';

    try {
      showLoadingDialog();
      var url = Uri.parse(
        AppConstant.signUpUrl,
      );
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      //closeLoadingDialog();
      var responseJson = json.decode(response.body.toString());
      var data = SignUpModel.fromJson(responseJson);
      if (data.success == 1) {
        showToast('Successfully Sign Up. You can login now!');
        Get.offAll(const WelcomeScreen());
      }
      return data;
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Sign in user method
  Future signInUser(
      {required String userName, required String password}) async {
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body =
        '{"username": "${userName.trim()}","password": "${password.trim()}"}';

    try {
      showLoadingDialog();
      var url = Uri.parse(
        AppConstant.loginUrl +
            "?username=${userName.trim()}&password=${password.trim()}",
      );
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      // closeLoadingDialog();
      var responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        UserModel user = UserModel.fromMap(responseJson);

        if (user.status == false) {
          showToast('Invalid Username or Password!');
          closeLoadingDialog();
        } else {
          AuthController authController = Get.find<AuthController>();
          authController.setUserData(user);

          await getAllOrders(user);
          await getAllServices(user);
          showToast(user.message);
          closeLoadingDialog();
          Get.offAll(CustomBottomNavigation());
        }
      } else {
        print("Something's wrong with server. Try again later");
        closeLoadingDialog();
      }
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Get All Orders
  Future getAllOrders(UserModel userModel) async {
    List<OrderModel> allOrders = [];
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    try {
      var url = Uri.parse(
          AppConstant.getOrderUrl + '?username=${userModel.userName}');
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);
      // print(responseJson[0]['id']);
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          if (responseJson[i]["username"].toLowerCase() == userModel.userName.toLowerCase()) {
            OrderModel orderModel = OrderModel.fromMap(responseJson[i]);
            allOrders.add(orderModel);
          }
        }
        OrderListController orderListController =
        Get.find<OrderListController>();
        orderListController.setListData(allOrders);
        print("COUNT: "+allOrders.length.toString());
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
    await getAllInvoices(userModel);
  }

  Future getAllInvoices(UserModel userModel) async {
    List<InvoiceModel> allInvoices = [];
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    try {
      var url = Uri.parse(
          AppConstant.getInvoiceUrl + '?username=${userModel.userName}');
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      // var body = '{"username":"${userModel.userName}"}';

      final response = await http.get(url, headers: header,);
      var responseJson = jsonDecode(response.body);
      // print(responseJson[0]['id']);
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          // if (responseJson[i]["username"] == userModel.userName) {
          InvoiceModel invoiceModel = InvoiceModel.fromJson(responseJson[i]);
          allInvoices.add(invoiceModel);
          // }
        }
        InvoiceController invoiceController =
        Get.find<InvoiceController>();
        invoiceController.setInvoiceData(allInvoices);
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Get Admin Bank Accounts
  Future getAdminBankAccounts() async {
    List<AdminBankAccountModel> bankAccounts = [];
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    try {
      var url = Uri.parse(AppConstant.getAdminBankAccountsUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);
      // print(responseJson[0]['id']);
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (int i = 0; i < responseJson.length; i++) {
          AdminBankAccountModel data = AdminBankAccountModel.fromJson(
              responseJson[i]);
          bankAccounts.add(data);
        }
        AdminAcccountsController adminAcccountsController =
        Get.find<AdminAcccountsController>();
        await adminAcccountsController.setBanks(bankAccounts);
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Get All Services
  Future getAllServices(UserModel userModel) async {
    List<ServiceModel> allServices = [];
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };

    try {
      var url = Uri.parse(AppConstant.allServicesUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          if (userModel.group == "1") {
            ServiceModel serviceModel = ServiceModel.fromMap(responseJson[i]);
            serviceModel.cost = responseJson[i]["cost1"];
            allServices.add(serviceModel);
          } else if (userModel.group == "2") {
            ServiceModel serviceModel = ServiceModel.fromMap(responseJson[i]);
            serviceModel.cost = responseJson[i]["cost2"];
            allServices.add(serviceModel);
          } else if (userModel.group == "3") {
            ServiceModel serviceModel = ServiceModel.fromMap(responseJson[i]);
            serviceModel.cost = responseJson[i]["cost3"];
            allServices.add(serviceModel);
          }
        }
        ServicesController servicesListController =
        Get.find<ServicesController>();
        servicesListController.setListData(allServices);
        update();
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Get service catagories
  Future getServiceCatagories() async {
    List<ServiceCatagoryModel> serviceCategoryList = [];
    AuthController authController = Get.find<AuthController>();
    ServicesController servicesController = Get.find<ServicesController>();

    // await getAllServices(authController.userModel!);

    List<ServiceModel>? servicesList = servicesController.allServices;

    // print("Helloooo: "+servicesList!.length.toString());
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };

    try {
      var url = Uri.parse(AppConstant.serviceCatagoriesUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          List<ServiceModel> serve = [];
          ServiceCatagoryModel serviceCatagoryModel =
          await ServiceCatagoryModel.fromMap(responseJson[i]);
          for (ServiceModel serviceModel in servicesList!) {
            if (serviceModel.category == serviceCatagoryModel.id) {
              serve.add(serviceModel);
            }
          }
          serviceCatagoryModel.servicesList = serve;
          // print("Helloooo: "+serviceCatagoryModel.servicesList!.length.toString());

          serviceCategoryList.add(serviceCatagoryModel);
        }
        await servicesController.setAllListData(serviceCategoryList);
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  ///Order place
  Future findImeiResults(String imei, ServiceModel selectedService) async {
    try {
      var url = Uri.parse(selectedService.link + imei);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url);

      print("Hellooo: " + response.request.toString());

      var responseJson;
      try {
        responseJson = jsonDecode(response.body);
        print(response.body.toString());
        if (response.statusCode == 200) {
          if (responseJson["status"] == "Successful") {
            var result = responseJson['response'];
            // showToast(result);
            print(result.toString());
            await postOrderAPICall(result, imei, selectedService);
            closeLoadingDialog();
            Get.to(() => ResultDetailsScreen(result));
          } else if (responseJson["status"] == "Rejected") {
            var error = responseJson['error'];
            // showToast(error);
            print(error.toString());
            await postOrderAPICall(error, imei, selectedService);
            closeLoadingDialog();
            Get.to(() => ResultDetailsScreen(error));
          }else{
            var result = responseJson['result'];
            await postOrderAPICall(result, imei, selectedService);
            closeLoadingDialog();
            Get.to(() => ResultDetailsScreen(result));
          }
        } else {
          print("Hellooo: Failleedd");
        }
      }
      catch (e) {
        // var json = jsonEncode(response.body);
        var response;
        var urls = url.toString();
        // Check if format=html exists
        if (url.queryParameters.containsKey('format') &&
            (url.queryParameters['format'] == 'html'||url.queryParameters['format'] == 'json')) {
          // Replace format=html with format=json
          url = url.replace(queryParameters: {'format': 'json'});


          List<String> parts = urls.split('&');
          String firstPart = parts[0];

          var StringUrl = "${url}&${parts[1]}&${parts[2]} &${parts[3]}";
          var newUrl = Uri.parse(StringUrl);

          print('First Part: $firstPart');

          print("NEW URL: " + newUrl.toString());

          // Make the API request
          final httpResponse = await http.get(newUrl);

          if (httpResponse.statusCode == 200) {
            // Convert the response to JSON format
            response = 'JSON Response: ${httpResponse.body}';
            var json = jsonDecode(httpResponse.body);
            // showToast(json['result']);
            if (json['result'].contains("Search Term:")) {
              await postOrderAPICall(json['result'], imei, selectedService);
            } else if (json['result'].contains("Duplicate Order.")) {
              // showToast("Duplicate Error");
              await postOrderAPICall(json['result'], imei, selectedService);
            } else if (json['result'].contains("Not Found")) {
              // showToast(json['result'].toString());
              await postOrderAPICall(json['result'], imei, selectedService);
            } else {
              // showToast("Something went wrong");
              await postOrderAPICall(json['result'], imei, selectedService);
            }
            closeLoadingDialog();
            Get.to(() => ResultDetailsScreen(json['result']));
          } else {
            response = 'Request failed with status: ${httpResponse.statusCode}';
            closeLoadingDialog();
          }
        } else {
          response = 'HTML format not found in the URL';
          closeLoadingDialog();
        }
      }

      // print("Hellooo: "+responseJson.toString());
      //


    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  /// Multiple Orders places
  Future findImeiBulkResults(String imei, ServiceModel selectedService) async {
    try {
      var url = Uri.parse(selectedService.link + imei);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url);

      print("Hellooo: " + response.request.toString());

      var responseJson;
      try {
        responseJson = jsonDecode(response.body);
        if (response.statusCode == 200) {
          if (responseJson["status"] == "Successful") {
            var result = responseJson['response'];
            // showToast(result);
            await postOrderAPICall(result, imei, selectedService);
            await setBulkData(result);
            // closeLoadingDialog();
          } else if (responseJson["status"] == "Rejected") {
            var error = responseJson['error'];
            // showToast(error);
            await setBulkData(error);
            print(error.toString());
            // closeLoadingDialog();
          }else{
            var result = responseJson['result'];
            await postOrderAPICall(result, imei, selectedService);
            closeLoadingDialog();
            await setBulkData(result);
          }
        } else {
          print("Hellooo: Failleedd");
        }
      } catch (e) {
        // var json = jsonEncode(response.body);
        var response;
        var urls = url.toString();
        // Check if format=html exists
        if (url.queryParameters.containsKey('format') &&
            url.queryParameters['format'] == 'html' ||url.queryParameters['format'] == 'json') {
          // Replace format=html with format=json
          url = url.replace(queryParameters: {'format': 'json'});


          List<String> parts = urls.split('&');
          String firstPart = parts[0];

          var StringUrl = "${url}&${parts[1]}&${parts[2]} &${parts[3]}";
          var newUrl = Uri.parse(StringUrl);

          print('First Part: $firstPart');

          print("NEW URL: " + newUrl.toString());

          // Make the API request
          final httpResponse = await http.get(newUrl);

          if (httpResponse.statusCode == 200) {
            // Convert the response to JSON format
            response = 'JSON Response: ${httpResponse.body}';
            var json = jsonDecode(httpResponse.body);
            // showToast(json['result']);
            if (json['result'].contains("Search Term:")) {
              await postOrderAPICall(json['result'], imei, selectedService);
            } else if (json['result'].contains("Duplicate Order.")) {
              // showToast("Duplicate Error");
              await postOrderAPICall(json['result'], imei, selectedService);
            } else if (json['result'].contains("Not Found")) {
              // showToast(json['result'].toString());
              await postOrderAPICall(json['result'], imei, selectedService);
            } else {
              // showToast("Something went wrong");
              await postOrderAPICall(json['result'], imei, selectedService);
            }
            // closeLoadingDialog();
            // Get.to(()=>ResultDetailsScreen(json['result']));
            await setBulkData(json['result']);
          } else {
            response = 'Request failed with status: ${httpResponse.statusCode}';
            // closeLoadingDialog();
          }
        } else {
          response = 'HTML format not found in the URL';
          // closeLoadingDialog();
        }
      }

      // print("Hellooo: "+responseJson.toString());
      //


    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  Future postOrderAPICall(String result, String imei,
      ServiceModel selectedService) async {
    print("POST FUNCTION");
    AuthController authController = Get.find<AuthController>();
    try {
      Map<String, String> header = {
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };
      result = jsonEncode(result);
      // print("BEFORE: " + result.toString());

      // result = json.encode(result);

      List<String> brokenStrings = [];
      int length = result.length;
      int partSize = (length / 2).ceil();

      //
      // if (result.contains("</font>")) {
      //   // Parse the HTML string
      //   html.DocumentFragment document = parseFragment(result);
      //
      //   // Get all font elements
      //   List<html.Element> fontElements = document.querySelectorAll('font');
      //   // Remove the font elements from the document
      //   for (var fontElement in fontElements) {
      //     fontElement.remove();
      //   }
      //
      //   // Get the updated string without font tags
      //   result = document.text!;
      //
      //   print("\n\nAFTER: " + result.toString());
      // }
      // if (result.contains("</span>")) {
      //   // Parse the HTML string
      //   html.DocumentFragment document = parseFragment(result);
      //
      //   // Get all font elements
      //   List<html.Element> spanElement = document.querySelectorAll('span');
      //
      //   // Remove the font elements from the document
      //   for (var spanElement in spanElement) {
      //     spanElement.remove();
      //   }
      //
      //   // Get the updated string without font tags
      //   result = document.text!;
      //
      //   print("\n\nAFTER: " + result.toString());
      // }

      // result = json.encode(result);
      print("MY RESULT: "+result.toString());
      var body = '{"status": "Success","service": "${selectedService
          .id}","imei":"${imei.trim()}","result":${'${result}'},"credits":"${selectedService.cost
          .trim()}","username":"${authController.userModel!.userName.trim()}"}';

      var url = Uri.parse(
        AppConstant.postOrderUrl,
      );
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      // Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(url, headers: header,
        body: body,
      );
      // showToast(body.toString());

      var responseJson = jsonDecode(response.body);

      print("Post Result: " + responseJson["success"].toString());

      if (responseJson["success"] == 1) {
        print("HI:: " + responseJson.toString());
        // showToast(responseJson['message'].toString());
        var currentAmount = authController.userModel!.wallet;
        var latestAmount = double.parse(currentAmount.toString()) -
            double.parse(selectedService.cost.toString());
        authController.updateWallet(latestAmount.toString());
        await updateWallet(latestAmount);
        closeLoadingDialog();
      }
      else if (responseJson["success"] == 0) {
        print("HI:: " + responseJson.toString());
        // showToast(responseJson['message'].toString());
        var currentAmount = authController.userModel!.wallet;
        var latestAmount = double.parse(currentAmount.toString()) -
            double.parse(selectedService.cost.toString());
        authController.updateWallet(latestAmount.toString());
        await updateWallet(latestAmount);
        closeLoadingDialog();
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  Future profileUpdateApiCall(userName, TextEditingController name,
      TextEditingController email, TextEditingController phone,
      TextEditingController Password) async {
    AuthController authController = Get.find<AuthController>();

    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body =
        '{"email": "${email.text.trim()}","username": "${userName
        .trim()}","name": "${name.text.trim()}","phone": "${phone.text
        .trim()}"}';

    try {
      var url = Uri.parse(
          AppConstant.editProfileUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (responseJson['message'] == "Data Inserted Successfully.") {
          authController.userModel!.name = name.text;
          authController.userModel!.email = email.text;
          authController.userModel!.phone = phone.text;
          showToast("Profile updated successfuly");
          update();
        }
      }

      if (Password.text != null || Password.text != "") {
        var url2 = Uri.parse(
            AppConstant.editPasswordUrl);
        var body2 = '{"username": "${userName.trim()}","password":"${Password
            .text.trim()}"}';
        Logger.debug(tag, 'Verify User API URL - ${url2.toString()}');
        Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
        final response2 = await http.post(
          url2,
          headers: header,
          body: body2,
        );
        var responseJson2 = jsonDecode(response2.body);
        if (response2.statusCode == 201) {
          if (responseJson2['message'] == "Data Inserted Successfully.") {
            authController.userModel!.name = name.text;
            authController.userModel!.email = email.text;
            authController.userModel!.phone = phone.text;
            showToast("Password updated successfuly");
            update();
          }
        }
      }
      Get.back();
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  Future InvoicePost(amount, paymentType, context) async {
    InvoiceModel invoiceModel = InvoiceModel();
    AuthController authController = Get.find<AuthController>();
    BankTransferController bankTransferController = Get.find<
        BankTransferController>();
    DateTime now = DateTime.now();

    int day = now.day;
    String month = DateFormat('MMMM').format(now);
    int year = now.year;

    DateTime selectedDate = DateTime(year, now.month, day);
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000;
    while (next < 1000) {
      next *= 10;
    }
    print(next.toInt());
    var body = '{"username": "${authController.userModel
        ?.userName}", "invoice_no": "${next
        .toInt()}", "total_amount": "${amount}", "inv_date": "${selectedDate}", "due_date": "${selectedDate}","suply_date": "${selectedDate}","payment_method": "${paymentType}", "status": "UnPaid", "prof": "1049", "payment_id": "${next
        .toInt()}", "payer_id": "${authController.userModel
        ?.id}", "payer_email": "${authController.userModel?.email}"}';

    try {
      showLoadingDialog();
      var url = Uri.parse(AppConstant.invoicePostUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      // closeLoadingDialog();
      var responseJson = jsonDecode(response.body);
      print("GASAA: ${responseJson}");
      print(
          "SLAJKLSDLISADJKALKSJDLKSAJDL:SAKDJ:LSADK:LSADK:SLADKAL:SDKS:LADKS:ALDKA:SLDK:SLADK:ASLDK:ASLDK");

      print(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson['success'] == 1) {
          if (responseJson['message'] == 'Data Inserted Successfully.') {
            invoiceModel = await InvoiceModel(
                username: "${authController.userModel?.userName}",
                invoiceNo: "${next.toInt()}",
                totalAmount: "${amount}",
                invDate: "${selectedDate}",
                dueDate: "${selectedDate}",
                suplyDate: "${selectedDate}",
                paymentMethod: "${paymentType}",
                status: "UnPaid",
                prof: "1049",
                paymentId: "${next.toInt()}",
                payerId: "${authController.userModel?.id}",
                payerEmail: "${authController.userModel?.email}");
            await getAllInvoices(authController.userModel!);
            closeLoadingDialog();
            Get.to(() => TopUpHistoryScreen());
            // showDialog(context: context, builder: (builder){
            //   return TransactionPopup(invoiceModel: invoiceModel);
            //
            // });

            // await bankTransferController.setInvoiceData(invoiceModel);
          } else {
            closeLoadingDialog();
            // await bankTransferController.setInvoiceData(invoiceModel);
          }
        }
      } else {
        closeLoadingDialog();
        print("Something's wrong with server. Try again later");
      }
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  Future<InvoiceModel> InvoicePostByBank(payerId, paymentId, paymentMethod,
      payerEmail, amount) async {
    InvoiceModel invoiceModel = InvoiceModel();
    AuthController authController = Get.find<AuthController>();
    BankTransferController bankTransferController = Get.find<
        BankTransferController>();
    DateTime now = DateTime.now();


    String formattedDate = DateFormat("dd MMM yyyy").format(now);
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000;
    while (next < 1000) {
      next *= 10;
    }
    print(next.toInt());
    var body = '{"username": "${authController.userModel
        ?.userName}", "invoice_no": "${next
        .toInt()}", "total_amount": "${amount}", "inv_date": "${formattedDate}", "due_date": "${formattedDate}","suply_date": "${formattedDate}","payment_method": "${paymentMethod}", "status": "Paid", "prof": "1049", "payment_id": "${paymentId}", "payer_id": "${payerId}", "payer_email": "${payerEmail}"}';

    try {
      // showLoadingDialog();
      var url = Uri.parse(AppConstant.invoicePostUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      // closeLoadingDialog();
      var responseJson = jsonDecode(response.body);
      print(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseJson['success'] == 1) {
          if (responseJson['message'] == 'Data Inserted Successfully.') {
            // closeLoadingDialog();
            invoiceModel = await InvoiceModel(
                username: "${authController.userModel?.userName}",
                invoiceNo: "${next.toInt()}",
                totalAmount: "${amount}",
                invDate: "${formattedDate}",
                dueDate: "${formattedDate}",
                suplyDate: "${formattedDate}",
                paymentMethod: "${payerEmail}",
                status: "Paid",
                prof: "1049",
                paymentId: "${paymentId}",
                payerId: "${payerId}",
                payerEmail: "${payerEmail}");

            // closeLoadingDialog();
            CommonController common = Get.find<CommonController>();
            await bankTransferController.setCount(1, true);
            await bankTransferController.setBankInvoice(invoiceModel);
            await common.getAllInvoices(authController.userModel!);
            return invoiceModel;
          } else {
            closeLoadingDialog();
            return invoiceModel;
            // await bankTransferController.setInvoiceData(invoiceModel);
          }
        }
      } else {
        closeLoadingDialog();
        print("Something's wrong with server. Try again later");
        return invoiceModel;
      }
    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }


    return invoiceModel;
  }

  Future getAllUserNames() async {
    List<String> userNames = [];
    // AuthController authController = Get.find<AuthController>();
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };

    try {
      var url = Uri.parse(AppConstant.getAllUserNamesUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        for (int i = 0; i < responseJson.length; i++) {
          // print(responseJson[i]['username']);
          userNames.add(responseJson[i]['username']);
          // print("USERS NAME: ${responseJson[i]['username']}");
        }
        await setUserNames(userNames);
      } else {
        showToast("ERROR ${response.statusCode}");
      }
    } on SocketException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      // closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }

  Future<bool> checkUserExists(username) async {
    return userNames.any((element) => element == username);
  }

  Future<bool> updatePassword(username, password) async {
    // AuthController authController = Get.find<AuthController>();
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(AppConstant.editPasswordUrl);
    var body = '{"username": "${username.trim()}","password":"${password
        .trim()}"}';
    Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
    Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
    final response2 = await http.post(
      url,
      headers: header,
      body: body,
    );
    var responseJson2 = jsonDecode(response2.body);
    if (response2.statusCode == 201) {
      if (responseJson2['message'] == "Data Inserted Successfully.") {
        showToast("Password updated successfuly");
        update();
        return true;
      }
      else {
        return false;
      }
    } else {
      showToast("Something went wrong");
      return false;
    }
  }

  Future<File?> getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      await setProfImage(File(pickedFile.path));
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> captureImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await setProfImage(File(pickedFile.path));
      return File(pickedFile.path);
    }
    return null;
  }

  Future SendMail(List<String> imei) async {
    String userNames = "app@imeicheck.uk";
    String password = "Pakist@n@123";


    // final smtpServer = gmail(userNames, password);
    final smtpServer = SmtpServer("mail.imeicheck.uk",port: 465,ssl: true,username: userNames,password: password,allowInsecure: true,ignoreBadCertificate: true,name: "IMEI CHECK");
    AuthController authController = Get.find<AuthController>();


    final message = Message()
      ..from = Address(userNames,'IMEI CHECK')
      // ..recipients.add('huzaifamughal076@gmail.com')
      ..recipients.add(authController.userModel?.email.toString())
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'IMEI CHECK'
      ..html = "<p>You have checked these Imei<br> ${imei.toList().toString()}<br></p>\n<p><h3>Thanks for using IMEI CHECK</h3></p>";

    try {
      print("Accessing");
      final sendReport = await send(message, smtpServer);
      // showToast("We have sent you the")
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. ${e.message.toString()} / ${e.problems.toList().toString()}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<Map<String, dynamic>> postData(String id, File prof) async {
    var url = Uri.parse('https://imeicheck.uk/api/invoiceproof.php');

    var request = http.MultipartRequest('POST', url);
    request.fields['id'] = id;
    request.files.add(await http.MultipartFile.fromPath('prof', prof.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseJson = await response.stream.bytesToString();
      showToast("Proof has been uploaded");
      print(responseJson.toString());
      return {
        'success': true,
        'data': responseJson,
      };
    } else {
      showToast("Please try again");
      return {
        'success': false,
        'error': response.reasonPhrase,
      };
    }
  }


  Future deleteAccount(userName) async {
    AuthController authController = Get.find<AuthController>();

    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body = '{"username": "${userName.trim()}"}';

    try {
      showLoadingDialog();
      var url = Uri.parse(AppConstant.deleteUserAccountApi);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (responseJson['success'] == 1) {
          showToast("${responseJson['message']}");
          update();
          Get.off(()=>WelcomeScreen());
          closeLoadingDialog();
        }
      }else{
        showToast("${responseJson['message']}");
        update();
        closeLoadingDialog();
      }

    } on SocketException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Socket Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.success,
          title: "errorOccurred",
          description: "Socket Exception");
      rethrow;
    } on TimeoutException catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Timeout Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: "Timeout Exception");
      rethrow;
    } on Exception catch (e) {
      closeLoadingDialog();
      Logger.error(tag, 'Exception- ${e.toString()}');
      showAlert(
          dialogType: DialogType.error,
          title: "errorOccurred",
          description: " Exception");
      rethrow;
    }
  }



}