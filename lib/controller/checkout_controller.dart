import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/controller/cart_controller.dart';
import 'package:zyo_shopify/model/conector.dart';
import 'package:zyo_shopify/model/my_order.dart';
import 'package:zyo_shopify/model/order.dart';
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
  var loading = false.obs;

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
    // cartController.clear_cart();
    validate.value=true;
    print(phone.text);//todo +971
    if(first_name.text.isEmpty||last_name.text.isEmpty||country.isEmpty||country=="non"||phone.text.isEmpty||state.text.isEmpty||city.text.isEmpty||address1.text.isEmpty||address2.text.isEmpty){


    }else{
    List<LineItem> lineItems=<LineItem>[];
      for(var elm in cartController.my_order.value){
        print(elm.varient_id);
        print(elm.quantity);
        lineItems.add(LineItem(elm.quantity.value,elm.varient_id));
      }
    print('loading');
      loading.value=true;
      if(Global.pick_up){
        Connector.add_order_pick_up(lineItems,first_name.text,last_name.text,address1.text,address2.text,phone.text,city.text,state.text,country).then((value) {
          if(value){
            loading.value=false;
            App.sucss_msg(context, App_Localization.of(context)!.translate("s_order"));
            cartController.clear_cart();
            Get.offAll(()=>Home());
          }else{
            loading.value=false;
            App.error_msg(context, App_Localization.of(context)!.translate("wrong"));
          }
        });
        loading.value=false;
      }else{
        Connector.add_order(lineItems,first_name.text,last_name.text,address1.text,address2.text,phone.text,city.text,state.text,country).then((value) {
          if(value){
            loading.value=false;
            App.sucss_msg(context, App_Localization.of(context)!.translate("s_order"));
            cartController.clear_cart();
            Get.offAll(()=>Home());
          }else{
            loading.value=false;
            App.error_msg(context, App_Localization.of(context)!.translate("wrong"));
          }
        });
        loading.value=false;
      }

      //     .catchError((err){
      //   print(err);
      //   loading.value=false;
      //   App.error_msg(context, App_Localization.of(context)!.translate("wrong"));
      // });
    }
  }

  String get_details(List<MyOrder> my_order){
    String text="";
    for(int i=0;i<my_order.length;i++){
      text+=my_order[i].product.value.title!+" X "+my_order[i].quantity.value.toString()+" X "+"\n";
    }
    return text;
  }
}

class LineItem {
  int quantity;
  int variantId;

  LineItem(this.quantity, this.variantId);
  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "variant_id": variantId,
  };


}