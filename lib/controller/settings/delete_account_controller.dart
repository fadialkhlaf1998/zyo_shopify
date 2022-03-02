import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/app_colors.dart';

class DeleteAccountController extends GetxController {

  submit(BuildContext context , String text) {
    return GestureDetector(
      onTap: () {
        if(text == "No") {
          print('no');
          //delete account
        }
        else {
          print('yes');
          // account still
        }
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.93,
        height: MediaQuery.of(context).size.height * 0.08,
        child: Center(
          child: Text(text,
            style: TextStyle(
                color: AppColors.main,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}