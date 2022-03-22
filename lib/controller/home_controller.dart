import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/controller/introduction_controller.dart';
import 'package:zyo_shopify/controller/sub_category_controller.dart';
import 'package:zyo_shopify/controller/wishlist_controller.dart';
import 'package:zyo_shopify/model/4th_sub_category.dart';
import 'package:zyo_shopify/model/collection.dart';
import 'package:zyo_shopify/model/conector.dart';
import 'package:zyo_shopify/model/home_page.dart';
import 'package:zyo_shopify/model/product.dart';
import 'package:zyo_shopify/model/sub_categories.dart';
import 'package:zyo_shopify/view/no_internet.dart';
import 'package:zyo_shopify/view/product.dart';
import 'package:zyo_shopify/view/sub_category.dart';

class HomeController extends GetxController {


  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  CarouselController controller = CarouselController();
  IntroController introController = Get.find();
  WishListController wishlistController = Get.find();
  RxList<Collection> collections = <Collection>[].obs;
  RxList<Collection> men = <Collection>[].obs;
  RxList<Collection> women = <Collection>[].obs;
  RxList<Collection> selected_collection = <Collection>[].obs;
  RxList<Product> products = <Product>[].obs;
  RxList<Product> all_products = <Product>[].obs;
  Rx<int> selected_sub_category = 0.obs;
  // List<FourthSubCategory> forthSubCategory = <FourthSubCategory>[];
  // HomePage homePage=HomePage( category: <Category>[], slider: <MySlider>[], comingSoon: <ComingSoon>[],flashSale: <FlashSale>[],home_page_products: <Product>[],new_products: <Product>[],ages: <Brands>[],unisex: <Brands>[]);
  var select_nav_bar = 0.obs;
  var last_select_nav_bar = 0.obs;
  var loading = false.obs;
  Rx<int> select_category = 0.obs;
  Rx<int> select_sub_category = 0.obs;
  Rx<int> slider_value = 0.obs;
  var sub_category_value = 0.0.obs;
  var wishlistIcon = true.obs;
  int Selected = 0;
  var selectedFourthSubCategory = 0.obs;
  @override
  Future<void> onInit() async {
    get_data();
    super.onInit();
    // _checkVersion(super.context);
  }


  get_data(){
    // homePage=introController.homePage;
    all_products.value=introController.all_products;
    for(int i=0;i<introController.collections.length;i++){
      if(introController.collections[i].rules==null){
        collections.add(introController.collections[i]);
      }else{
        bool added = false;
        for(int j=0;j<introController.collections[i].rules!.length;j++){
          if(introController.collections[i].rules![j].condition!.toLowerCase()=="women"&&introController.collections[i].title!.toLowerCase()!="women"){
            if(introController.collections[i].title!.toLowerCase().contains("see")){
              women.insert(0,introController.collections[i]);
            }else{
              women.add(introController.collections[i]);
            }
            added=true;
            break;
          }else if(introController.collections[i].rules![j].condition!.toLowerCase()=="men"&&introController.collections[i].title!.toLowerCase()!="men"){
            if(introController.collections[i].title!.toLowerCase().contains("see")){
              men.insert(0,introController.collections[i]);
            }else{
              men.add(introController.collections[i]);
            }

            added=true;
            break;
          }
        }
        if(added==true){
          added=false;
        }else{
          if(introController.collections[i].title!.toLowerCase()=="men"||introController.collections[i].title!.toLowerCase()=="women"){
            collections.insert(0,introController.collections[i]);
          }else{
            collections.add(introController.collections[i]);
          }

        }
      }
    }
    // collections.value=introController.collections;
    get_sub_category(0);
    // print(collections.length);
    // products.value=introController.products;
    // get_fourth(introController.subCategory);
  }

  get_fourth(List<SubCategory> list){
    // forthSubCategory.clear();
    if(list.isNotEmpty)
    for(int i=0;i<list.length+3;i+=4){
      SubCategory? first=null;
      SubCategory? second=null;
      SubCategory? third=null;
      SubCategory? fourth=null;
      if(list.length>i){
        first=list[i];
      }
      if(list.length>i+1){
        second=list[i+1];
      }
      if(list.length>i+2){
        third=list[i+2];
      }
      if(list.length>i+3){
        fourth=list[i+3];
      }
      // if(first!=null)
      // forthSubCategory.add(FourthSubCategory(first, second, third, fourth));
    }
    loading.value=false;
  }

  get_delay(){
    loading.value=true;
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      loading.value=false;
    });
  }

  get_sub_category(int index){
    get_delay();
    select_category.value=index;
    selected_sub_category.value=0;
    if(collections[index].title!.toLowerCase()=="men"){
      selected_collection=men;
      products.value=men.first.products;
      // get_product_by_collection(selected_collection.first.id!);
    }else if(collections[index].title!.toLowerCase()=="women"){
      selected_collection=women;
      products.value=women.first.products;
      // get_product_by_collection(selected_collection.first.id!);
    }else{
      selected_collection=<Collection>[].obs;
      products.value=collections[select_category.value].products;
      // get_product_by_collection(collections[select_category.value].id!);
    }
  }

  get_product (int index){
    get_delay();
    // loading.value=false;
    selected_sub_category.value=index;
    products.value=selected_collection[index].products;
    print(products.length.toString()+"+++++++++");
  }

  go_to_product(Product product){
    Get.to(()=>ProductInfo(product));
  }

  // get_product_by_collection(int title){
  //   print(title);
  //   Connector.check_internet().then((net) {
  //     if(net){
  //       loading.value=true;
  //       Connector.get_products_by_Collection(title).then((value){
  //         products.value=value;
  //         loading.value=false;
  //       }).catchError((err){
  //         print(err);
  //         loading.value=false;
  //       });
  //     }else{
  //       Get.to(NoInternet())!.then((value) {
  //         get_product_by_collection(title);
  //       });
  //     }
  //   });
  // }

  get_sub_category_and_product(int index){
    // App.error_msg(context, "api");
    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.get_sub_category(homePage.category[index].id).then((value) {
    //       subCategory.value=value.subCategory;
    //       if(value.subCategory.isNotEmpty){
    //         Api.getProducts(wishlistController.wishlist, subCategory.value.first.id).then((value) {
    //           products.value=value;
    //           loading.value=false;
    //         });
    //       }else{
    //         products.value.clear();
    //         loading.value=false;
    //       }
    //       // get_fourth(value.subCategory);
    //
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       get_sub_category_and_product(index);
    //     });
    //   }
    // });


  }

  get_product_by_sub_category(int index){
    // App.error_msg(context, "api");
    print('API');
    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.getProducts(wishlistController.wishlist,subCategory.value[index].id).then((value) {
    //       products.value=value;
    //       loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       get_product_by_sub_category(index);
    //     });
    //   }
    // });

  }

  go_to_product_page(int id,String tag){
    // App.error_msg(context, "api");
    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.get_product_info(id).then((value) {
    //       Get.to(()=>ProductInfo(value!,tag));
    //       loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_product_page(id,tag);
    //     });
    //   }
    // });

  }

  go_to_sub_category_page(SubCategory subCategory){
    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.getProducts(wishlistController.wishlist,subCategory.id).then((value) {
    //       Get.to(()=>SubCategoryView(subCategory.title,value.obs));
    //       loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_sub_category_page(subCategory);
    //     });
    //   }
    // });

  }
  go_to_search_page(String query){
    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     //loading.value=true;
    //     Api.getProductsSearch(wishlistController.wishlist,query).then((value) {
    //       Get.to(()=>SubCategoryView(query,value.obs));
    //       // loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_search_page(query);
    //     });
    //   }
    // });

  }
  go_to_search_page_sub_category(String query){

    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     print(query);
    //     Api.getProductsSearch(wishlistController.wishlist,query).then((value) {
    //       print('***************');
    //       SubCategoryController subCategoryController = Get.find();
    //       subCategoryController.title=query;
    //       subCategoryController.products = value;
    //       loading.value=false;
    //       Get.back();
    //
    //       //Get.off(()=>SubCategoryView(query,value.obs));
    //       // loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_search_page(query);
    //     });
    //   }
    // });

  }
  go_to_search_page_by_age(Brands brands){

    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.getProductsByBrand(wishlistController.wishlist,brands.id).then((value) {
    //       Get.to(()=>SubCategoryView(brands.title,value.obs));
    //       loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_search_page_by_age(brands);
    //     });
    //   }
    // });

  }

  go_to_search_page_by_unisex(Brands brands){

    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.getProductsByUnisex(wishlistController.wishlist,brands.id).then((value) {
    //       Get.to(()=>SubCategoryView(brands.title,value.obs));
    //       loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_search_page_by_age(brands);
    //     });
    //   }
    // });

  }
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Double tap to exit");
      // select_nav_bar.value=last_select_nav_bar.value;
      return Future.value(false);
    }
    return Future.value(true);
  }

  go_to_search_page_with_loading(String query){

    print('API');

    // Api.check_internet().then((net) {
    //   if(net){
    //     loading.value=true;
    //     Api.getProductsSearch(wishlistController.wishlist,query).then((value) {
    //       Get.to(()=>SubCategoryView(query,value.obs));
    //       loading.value=false;
    //     });
    //   }else{
    //     Get.to(NoInternet())!.then((value) {
    //       go_to_search_page_with_loading(query);
    //     });
    //   }
    // });


  }

  set_index(int selected){
    selectedFourthSubCategory.value=selected;
  }

  set_nav_bar(int select) {
    select_nav_bar.value=select;
  }


}