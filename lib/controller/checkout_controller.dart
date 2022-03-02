import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/controller/cart_controller.dart';
import 'package:zyo_shopify/model/my_order.dart';
import 'package:zyo_shopify/view/home.dart';

class CheckoutController extends GetxController{


  CartController cartController = Get.find();

  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  String country="United Arab Emirates";
  String country_code="+971";
  String phone_init= "AE";
  String phone_code="+971";
  var validate = false.obs;
  var isSwitched = false.obs;

  @override
  void onInit() {
    if(Global.address!=null){
      phone.text=Global.address!.phone;
      state.text=Global.address!.state;
      city.text=Global.address!.city;
      address1.text=Global.address!.address1;
      address2.text=Global.address!.address2;
      country=Global.address!.country;
      country_code=Global.address!.country_code;
      phone_init=Global.address!.phone_init;
      phone_code=Global.address!.phone_code;
    }
    super.onInit();
  }

  add_order(BuildContext context){
    // Api.add_order(Global.customer!.firstname, Global.customer!.lastname, address1.text, address2.text, city.text, country, state.text, phone_code+phone.text,get_details(cartController.my_order.value), double.parse(cartController.sub_total.value), double.parse(cartController.shipping.value), double.parse(cartController.total.value), false,cartController.coupon.toString());
    cartController.clear_cart();
    // App.sucss_msg(context, App_Localization.of(context)!.translate("s_order"));
    App.error_msg(context, "api");
    Get.offAll(()=>Home());
  }

  String get_details(List<MyOrder> my_order){
    String text="";
    for(int i=0;i<my_order.length;i++){
      text+=my_order[i].product.value.title!+" X "+my_order[i].quantity.value.toString()+" X "+"\n";
    }
    return text;
  }
}