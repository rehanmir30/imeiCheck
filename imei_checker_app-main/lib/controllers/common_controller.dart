import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:imei/controllers/BankTransferController.dart';
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

class CommonController extends GetxController {
  final String tag = "CommonController";
  SharedPreferences? sharedPreferences;
  BuildContext? context;
  bool? userBool;
  String? abc;

  ///Login Screen Variables
  Rx<bool> loginCheckBoxValue = false.obs;

  ///Sign Up Screen Variables
  var isSignUpCheckBoxValue = false.obs;
  var isEditProfileCheckBoxValue = false.obs;

  ///IMEI_Check Screen Variables
  Rx<bool> imeiSelectTabValue = false.obs;
  Rx<bool> bulkDuplicateCheckBoxValue = false.obs;
  Rx<bool> bulkEmailCheckBoxValue = false.obs;

  @override
  void onInit() {
    super.onInit();
    Logger.info(tag, "Inside onInit");
    getAdminBankAccounts();
    // _getSharedPrefValues();
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

  ///Sign up user method
  Future<SignUpModel?> signUpUser(
      {required String email,
      required String userName,
      required String password,
      required String phone}) async {
    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body =
        '{"email": "${email.trim()}","username": "${userName.trim()}","password": "${password.trim()}","phone": "${phone.trim()}"}';

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
      var url = Uri.parse(AppConstant.getOrderUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);
      // print(responseJson[0]['id']);
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          if (responseJson[i]["username"] == userModel.userName) {
            OrderModel orderModel = OrderModel.fromMap(responseJson[i]);
            allOrders.add(orderModel);
          }
        }
        OrderListController orderListController =
            Get.find<OrderListController>();
        orderListController.setListData(allOrders);
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
      var url = Uri.parse(AppConstant.getInvoiceUrl);
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');

      final response = await http.get(url, headers: header);
      var responseJson = jsonDecode(response.body);
      // print(responseJson[0]['id']);
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
          if (responseJson[i]["username"] == userModel.userName) {
            InvoiceModel invoiceModel = InvoiceModel.fromJson(responseJson[i]);
            allInvoices.add(invoiceModel);
          }
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
      if (response.statusCode == 200) {
        for (int i = 0; i < responseJson.length; i++) {
            AdminBankAccountModel data = AdminBankAccountModel.fromJson(responseJson[i]);
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

      print("Hellooo: "+response.request.toString());

      var responseJson;
        try{
           responseJson = jsonDecode(response.body);
           if (response.statusCode == 200) {
             if (responseJson["status"] == "Successful") {
               var result = responseJson['response'];
               showToast(result);
               print(result.toString());
               await postOrderAPICall(result, imei, selectedService);
             } else if (responseJson["status"] == "Rejected") {
               var error = responseJson['error'];
               showToast(error);
               print(error.toString());
             }
           } else {
             print("Hellooo: Failleedd");
           }
        }catch(e){
          // var json = jsonEncode(response.body);
          var response;
          var urls = url.toString();
          // Check if format=html exists
          if (url.queryParameters.containsKey('format') &&
              url.queryParameters['format'] == 'html') {
            // Replace format=html with format=json
            url = url.replace(queryParameters: {'format': 'json'});


            List<String> parts = urls.split('&');
            String firstPart = parts[0];

            var StringUrl = "${url}&${parts[1]}&${parts[2]} &${parts[3]}";
            var newUrl = Uri.parse(StringUrl);

            print('First Part: $firstPart');

            print("NEW URL: "+newUrl.toString());

            // Make the API request
            final httpResponse = await http.get(newUrl);

            if (httpResponse.statusCode == 200) {
              // Convert the response to JSON format
                response = 'JSON Response: ${httpResponse.body}';
                var json = jsonDecode(httpResponse.body);
                // showToast(json['result']);
                await postOrderAPICall(json['result'],imei,selectedService);

            } else {
                response = 'Request failed with status: ${httpResponse.statusCode}';
            }
          } else {
              response = 'HTML format not found in the URL';
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

  Future postOrderAPICall(
      String result, String imei, ServiceModel selectedService) async {
    AuthController authController = Get.find<AuthController>();
    try {
      Map<String, String> header = {
        "Accept": "application/json",
        'Content-Type': 'application/json',
      };
      var body =
          '{"status": "Success","service": "${selectedService.id.trim()}","imei":"${imei.trim()}","result":"${result}","credits":"${selectedService.cost.trim()}","username":"${authController.userModel!.userName.trim()}"}';

      var url = Uri.parse(
        AppConstant.postOrderUrl,
      );
      Logger.debug(tag, 'Verify User API URL - ${url.toString()}');
      Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );

      var responseJson = jsonDecode(response.body);

      if(responseJson["success"]==1){
        print("HI:: "+responseJson.toString());
        showToast(responseJson['message'].toString());
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

  Future profileUpdateApiCall(userName,TextEditingController name,TextEditingController email,TextEditingController phone,TextEditingController Password)async{
    AuthController authController=Get.find<AuthController>();

    Map<String, String> header = {
      "Accept": "application/json",
      'Content-Type': 'application/json',
    };
    var body =
        '{"email": "${email.text.trim()}","username": "${userName.trim()}","name": "${name.text.trim()}","phone": "${phone.text.trim()}"}';

    try{
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
      if(response.statusCode==201){
        if(responseJson['message']=="Data Inserted Successfully."){
          authController.userModel!.name=name.text;
          authController.userModel!.email=email.text;
          authController.userModel!.phone=phone.text;
          showToast("Profile updated successfuly");
          update();
        }
      }

      if(Password.text!=null||Password.text!=""){
        var url2 = Uri.parse(
            AppConstant.editPasswordUrl);
var body2='{"username": "${userName.trim()}","password":"${Password.text.trim()}"}';
        Logger.debug(tag, 'Verify User API URL - ${url2.toString()}');
        Logger.debug(tag, 'Verify User Request Body - ${body.toString()}');
        final response2 = await http.post(
          url2,
          headers: header,
          body: body2,
        );
        var responseJson2 = jsonDecode(response2.body);
        if(response2.statusCode==201){
          if(responseJson2['message']=="Data Inserted Successfully."){
            authController.userModel!.name=name.text;
            authController.userModel!.email=email.text;
            authController.userModel!.phone=phone.text;
            showToast("Password updated successfuly");
            update();

          }
        }

      }
      Get.back();



    }on SocketException catch (e) {
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

  Future InvoicePost(amount, paymentType,context)async{
    InvoiceModel invoiceModel = InvoiceModel();
    AuthController authController = Get.find<AuthController>();
    BankTransferController bankTransferController = Get.find<BankTransferController>();
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
    var body = '{"username": "${authController.userModel?.userName}", "invoice_no": "${next.toInt()}", "total_amount": "${amount}", "inv_date": "${selectedDate}", "due_date": "${selectedDate}","suply_date": "${selectedDate}","payment_method": "${paymentType}", "status": "UnPaid", "prof": "1049", "payment_id": "${next.toInt()}", "payer_id": "${authController.userModel?.id}", "payer_email": "${authController.userModel?.email}"}';

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
      print("SLAJKLSDLISADJKALKSJDLKSAJDL:SAKDJ:LSADK:LSADK:SLADKAL:SDKS:LADKS:ALDKA:SLDK:SLADK:ASLDK:ASLDK");

      print(response.statusCode.toString());

          if(response.statusCode==200 ||response.statusCode==201){
        if (responseJson['success'] == 1) {
          if (responseJson['message'] == 'Data Inserted Successfully.') {
            closeLoadingDialog();
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

            showDialog(context: context, builder: (builder){
              return TransactionPopup(invoiceModel: invoiceModel);

            });

            // await bankTransferController.setInvoiceData(invoiceModel);
          } else {
            closeLoadingDialog();
            // await bankTransferController.setInvoiceData(invoiceModel);
          }
        }
      }else {
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


}
