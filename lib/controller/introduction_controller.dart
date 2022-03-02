import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/const/store.dart';
import 'package:zyo_shopify/controller/cart_controller.dart';
import 'package:zyo_shopify/controller/wishlist_controller.dart';
import 'package:zyo_shopify/model/collection.dart';
import 'package:zyo_shopify/model/conector.dart';
import 'package:zyo_shopify/model/home_page.dart';
import 'package:zyo_shopify/model/product.dart';
import 'package:zyo_shopify/model/sub_categories.dart';
import 'package:zyo_shopify/view/home.dart';
import 'package:zyo_shopify/view/no_internet.dart';
import 'package:zyo_shopify/view/registation.dart';
import 'package:zyo_shopify/view/verification_code.dart';

class IntroController extends GetxController {
  HomePage homePage=HomePage( category: <Category>[], slider: <MySlider>[], comingSoon: <ComingSoon>[],flashSale: <FlashSale>[],home_page_products: <Product>[],new_products: <Product>[],ages: <Brands>[],unisex: <Brands>[]);
  WishListController wishlistController = Get.put(WishListController());
  CartController cartController = Get.put(CartController());
  List<Collection> collections = <Collection>[];
  List<Product> products = <Product>[];
  @override
  Future<void> onInit() async {
    super.onInit();
    get_data();
  }

  get_data(){
    Store.load_dic_code();
    Store.load_currency();
    print('API');



    Connector.check_internet().then((internet) {
      if(internet){
        // Api.get_history();
        Store.load_order().then((value) {
          cartController.my_order.value=value;
          cartController.get_total();
        });
        Store.load_address();

        Store.load_wishlist().then((wishlist) {

          wishlistController.wishlist.value=wishlist;
          Connector.get_collections().then((collections0)  {
            collections=collections0;
          });
          Future.delayed(Duration(milliseconds: 2500)).then((value) {
            get_page();
          });
        });

      }else{
            Get.to(NoInternet())!.then((value) {
              get_data();
            });
      }
    });

  }

  get_page(){
    Store.loadLogInInfo().then((info) {
      if(info.email=="non"){
        Get.offAll(()=>Registration());
      }else{
        Store.load_verificat().then((verify){
          if(verify){
            Connector.check_internet().then((internet) {
              if(internet){
                Connector.login_customers(info.email,info.pass).then((customer_id) {
                  Connector.get_customer(customer_id).then((value) {
                    // print(value.message);
                    if(value!=null){
                      Get.offAll(()=>Home());
                    }else{
                      Get.offAll(()=>Registration());
                    }

                  });

                });

              }else{
                Get.to(()=>NoInternet())!.then((value) {
                  get_page();
                });
              }
            });

          }else{
            Get.offAll(VerificatioCode());
          }
        });
      }
    });
  }




}