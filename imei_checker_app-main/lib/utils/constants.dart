import 'package:flutter/material.dart';

class AppConstant {
  static const String appName = "IMEI";
  static const String googleMapApiKey = 'AIzaSyAdGc2L2VjOlGeRQ8ITHix3Q1t-oGoXFfU';
  static const String languagesFilePath = 'assets/translations';
  static String supportEmail = "sikanderjutt4745@gmail.com";

  // Utility
  static final List<Map> servicesTypeList = [
    {"id": '1',  "name": "265\$- 50\$"},
    {"id": '2',  "name": "265\$- 50\$"},
    {"id": '3',  "name": "265\$- 50\$"},
  ];
  static const mobileDataText = "Specifications Physical specifications Dimensions 160.8 x 78.1 x 7.7 mm Specifications Physical specifications Dimensions 160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 gSpecifications \nPhysical specifications \nDimensions	160.8 x 78.1 x 7.7 mm \nWeight	240 g ";

  // API Urls
  static String serverUrl = 'https://imeicheck.uk/';
  static String baseUrl = serverUrl;
  static String apiUrl = "${baseUrl}api/";
  static String signUpUrl = "${apiUrl}userp.php";
  static String loginUrl='${apiUrl}users/login.php';
  static String getOrderUrl = "${apiUrl}orderg.php";
  static String allServicesUrl="${apiUrl}serg.php";
  static String serviceCatagoriesUrl="${apiUrl}catg.php";
  static String postOrderUrl="${apiUrl}orderp.php";
  static String getAdminBankAccountsUrl = "${apiUrl}accountsg.php";
  static String getInvoiceUrl = "${apiUrl}creditsg.php";
  static String editProfileUrl = "${apiUrl}profileu.php";
  static String editPasswordUrl = "${apiUrl}passwordu.php";
  static String invoicePostUrl = "${apiUrl}creditsp.php";
  static String walletPostUrl = "${apiUrl}walletp.php";
  static String getAllUserNamesUrl = "${apiUrl}userg.php";
  static String getBankKeysUrl = "${apiUrl}authg.php";
  static String invoiceProfApi = "${apiUrl}invoiceproof.php";

}