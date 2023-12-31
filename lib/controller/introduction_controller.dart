import 'package:get/get.dart';
import 'package:http/http.dart';
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
  List<Product> all_products = <Product>[];
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
            if(collections0.isNotEmpty){
              collections=collections0;
              get_products().then((value) {
                Future.delayed(Duration(milliseconds: 2000)).then((value) {
                  get_page();
                });
              });
            }else{
              get_data();
            }

          });

        });

      }else{
            Get.to(NoInternet())!.then((value) {
              get_data();
            });
      }
    });

  }
  Future<bool> get_products() async {
    // for(int i=0;i<collections.length;i++){
    //   collections[i].products.value.clear();
    //   collections[i].products.value = await Connector.get_products_by_Collection(wishlistController.wishlist,collections[i].id!);
    //   // all_products.addAll(collections[i].products.value);
    // }
    //collections.first.products.value = await Connector.get_products_by_Collection(wishlistController.wishlist,collections.first.id!);
    all_products.addAll(await Connector.get_all_products(wishlistController.wishlist));
    return true;
  }
  get_page(){
    Store.loadLogInInfo().then((info) {
      if(info.email=="non"){
        // Get.offAll(()=>Registration());
        Get.offAll(()=>Home());
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
                      Get.offAll(()=>Home());
                      // Get.offAll(()=>Registration());
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
            // Get.offAll(VerificatioCode());
            Get.offAll(()=>Home());
          }
        });
      }
    });
  }




}