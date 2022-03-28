import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/view/home.dart';


class AcceptOrder extends StatefulWidget {
  String order_no ;


  AcceptOrder(this.order_no);

  @override
  State<AcceptOrder> createState() => _AcceptOrderState(this.order_no);
}

class _AcceptOrderState extends State<AcceptOrder> {
  String order_no ;

  _AcceptOrderState(this.order_no);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2500)).then((value) {
      Get.offAll(()=>Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.main,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SvgPicture.asset("assets/icons/accept_order.svg",width: MediaQuery.of(context).size.width*0.5,),
              Text(App_Localization.of(context)!.translate("order_accepted"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(height: 10,),
              Text(App_Localization.of(context)!.translate("order_no")+order_no,style: TextStyle(fontSize: 16,color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }
}
