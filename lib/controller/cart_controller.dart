import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/const/store.dart';
import 'package:zyo_shopify/model/conector.dart';
import 'package:zyo_shopify/model/my_order.dart';
import 'package:zyo_shopify/model/product.dart';
import 'package:zyo_shopify/view/checkout.dart';
import 'package:zyo_shopify/view/no_internet.dart';

class CartController extends GetxController{
  // Rx<Order> order=Order(lineItems: <OrderLineItem>[]).obs;
  Rx<String> total="0.00".obs,sub_total="0.00".obs,shipping="10.00".obs,coupon="0.0".obs;
  var my_order = <MyOrder>[].obs;
  var rate = <MyOrder>[].obs;
  var loading = false.obs;
  TextEditingController code = TextEditingController();


  Apply_code(BuildContext context,String code){
    Connector.check_internet().then((net) {
      if(net){
        loading.value=true;
        App.error_msg(context, "make api");
        // Connector.Apply_dis_code(code).then((value) {
        //   loading.value=false;
        //   get_total();
        //   if(value==0){
        //     App.error_msg(context, "error_code");
        //   }else{
        //     App.sucss_msg(context, "succ_code");
        //   }
        // });
      }else{
        Get.to(NoInternet())!.then((value) {
          Apply_code(context,code);
        });
      }
    });

  }

  bool add_to_cart(Product product,int selected_varient , int count,BuildContext context){
    print(selected_varient);
    print(product.variants![selected_varient].id!);
    if(count<=product.variants![selected_varient].inventoryQuantity!){

      for(int i=0;i<my_order.length;i++){
        if(my_order[i].varient_id==product.variants![selected_varient].id){
          if(my_order[i].quantity.value+count<=product.variants![selected_varient].inventoryQuantity!){
            my_order[i].quantity.value=my_order[i].quantity.value+count;
            my_order[i].price.value = product.variants!.first.price! + " X " + my_order[i].quantity.value.toString();
            get_total();
            return true;
          }else{
            App.error_msg(context, App_Localization.of(context)!.translate("out_of_stock"));
            return false;
          }
        }
      }
      my_order.add(MyOrder(product: product.obs,price: count == 1?(product.variants!.first.price!).obs:(product.variants!.first.price!+" X "+count.toString()).obs,quantity: count.obs,varient_id: product.variants![selected_varient].id!,color: product.variants![selected_varient].option1!,size: product.variants![selected_varient].option2));
      get_total();
      return true;
    }else{
      App.error_msg(context, App_Localization.of(context)!.translate("out_of_stock"));
      return false;

    }
  }

  // add_to_rate(Product product , int count){
  //   for(int i=0;i<rate.length;i++){
  //     if(rate[i].product.value.id==product.id){
  //       rate[i].quantity.value = rate[i].quantity.value + count;
  //       // double x = (my_order[i].quantity.value * double.parse(product.price.toString())) as double;
  //       rate[i].price.value = "0.0";
  //       get_total();
  //       return ;
  //     }
  //   }
  //   // double x = (count * double.parse(product.price.toString())) as double;
  //   MyOrder myOrder = MyOrder(product:product.obs,quantity:count.obs,price:"0.0".obs,);
  //   rate.add(myOrder);
  // }

  clear_cart(){
    my_order.clear();
    get_total();
  }

  increase(MyOrder myOrder,index){
    // if(myOrder.product.>my_order[index].quantity.value){
      my_order[index].quantity.value++;
      double x =  (my_order[index].quantity.value * double.parse(my_order[index].product.value.variants!.first.price.toString())) as double;
      my_order[index].price.value=x.toString();
      get_total();
    // }

  }

  decrease(MyOrder myOrder,index){
    if(my_order[index].quantity.value>1){
      my_order[index].quantity.value--;
      double x =  (my_order[index].quantity.value *double.parse(my_order[index].product.value.variants!.first.price!.toString())) as double;
      my_order[index].price.value=x.toString();
      get_total();
    }else{
      remove_from_cart(myOrder);
    }

  }
  remove_from_cart(MyOrder myOrder){
    my_order.removeAt(my_order.indexOf(myOrder));
    get_total();
  }

  get_total(){
    double x=0,y=0;
    for (var elm in my_order) {
      x +=( double.parse(elm.product.value.variants!.first.price!)*elm.quantity.value);
      // y += double.parse(elm.shipping.value);
    }
    y = (x*(Global.dis_code))/100;
    coupon.value=y.toString();
    sub_total.value=x.toString();
    // total.value = (x+double.parse(shipping.value.toString())-double.parse(coupon.value.toString())).toString();
    Store.save_order(my_order.value);
  }
}
