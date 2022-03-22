import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class App{

  static String phone = "+971 56 828 8092";

  static sucss_msg(BuildContext context,String msg){
    return showTopSnackBar(
      context,
      CustomSnackBar.success(
        message:
        msg,
        backgroundColor: Colors.grey,
      ),
    );
  }
  static error_msg(BuildContext context,String err){
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message:
        err,
      ),
    );
  }

  static openwhatsapp(BuildContext context,String msg) async{
    var whatsapp ="971568288092";
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=$msg";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse(msg)}";

    String url = WA_url(whatsapp,msg);

    if( await canLaunch(url)){
      await launch(url);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Can not open whatsapp")));

    }
  }

  static String WA_url(String phone,String message) {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    }
  }
}