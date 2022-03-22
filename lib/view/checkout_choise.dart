import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/view/checkout.dart';

class CheckoutChoise extends StatelessWidget {
  const CheckoutChoise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: AppColors.main,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _header(context),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      onTap: (){
                        Global.pick_up=false;
                        Get.to(()=>Checkout());
                      },
                      title: Text(App_Localization.of(context)!.translate("cod"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      subtitle: Text(App_Localization.of(context)!.translate("cod_sub_title"),style: TextStyle(color: Colors.grey,fontSize: 12),),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.drive_eta,color: AppColors.main,),
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        Global.pick_up=true;
                        Get.to(()=>Checkout());
                      },
                      title: Text(App_Localization.of(context)!.translate("pick_up"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      subtitle: Text(App_Localization.of(context)!.translate("pick_up_content"),style: TextStyle(color: Colors.grey,fontSize: 12),),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.shopping_bag_outlined,color: AppColors.main,),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,)),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Text(App_Localization.of(context)!.translate("checkout"),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
          )
        ],
      ),
    );
  }
}
