
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Logger{

  static void  info(String? tag, infoMessage ){
    debugPrint("$tag-$infoMessage");
  }

  static void  debug(String? tag, infoMessage){
    debugPrint("$tag-$infoMessage");
  }

  static void warning(String? tag, infoMessage){
    debugPrint("$tag-$infoMessage");
  }

  static void  error(String? tag, infoMessage){
    debugPrint("$tag-$infoMessage");
  }

  static void server(String? tag, infoMessage){
    debugPrint("$tag-$infoMessage");
  }
  static void  logData(String? tag, logMessage ){
    log("$tag-$logMessage");
  }

}