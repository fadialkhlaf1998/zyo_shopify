import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/store.dart';
import 'package:zyo_shopify/model/product.dart';

class WishListController extends GetxController{
  RxList<Product> wishlist = <Product>[].obs;
  var loading = false.obs;
  // List<MyProduct> recently = <MyProduct>[].obs;
  List<Product> rate = <Product>[].obs;

  add_to_wishlist(Product product,BuildContext context){
    App.sucss_msg(context, App_Localization.of(context)!.translate("wishlist_msg"));
    // product.favorite.value=true;
    wishlist.value.add(product);
    Store.save_wishlist(wishlist.value);
  }
  delete_from_wishlist(Product product){
    // product.favorite.value=false;
    for( int i=0 ;i < wishlist.length ; i++){
      if(wishlist.value[i].id==product.id){
        wishlist.value.removeAt(i);
        break;
      }
    }
    Store.save_wishlist(wishlist.value);
  }

  add_to_rate(Product myProduct,double rating){
    rate.add(myProduct);
    Store.save_rate(rate);
  }
  bool is_favorite(Product product){
    for(int i=0;i<wishlist.length;i++){
      if(product.id==wishlist[i].id){
        // product.is_favoirite.value=true;
        return true;
      }
    }
    // product.is_favoirite.value=false;
    return false;
  }

}