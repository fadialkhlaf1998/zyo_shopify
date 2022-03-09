import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/controller/cart_controller.dart';
import 'package:zyo_shopify/controller/categories_controller.dart';
import 'package:zyo_shopify/controller/home_controller.dart';
import 'package:zyo_shopify/view/cart.dart';


class Categories extends StatelessWidget {
  Categories({Key? key}) : super(key: key);

  CategoriesController categoriesController = Get.put(CategoriesController());
  HomeController homeController = Get.find();
  CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.main,
      body: WillPopScope(
        onWillPop: homeController.onWillPop,
        child: SafeArea(
          child:Obx((){
            return  Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: AppColors.main,
                  child: Center(
                    child: Column(
                      children: [
                        _header(context),
                        _body(context)
                      ],
                    ),
                  ),
                ),
                Positioned(child: homeController.loading.value?Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white,),
                  ),
                ):Center())
              ],
            );
          }),
        ),
      )
    );
  }

  _header(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.93,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [

                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          homeController.select_nav_bar.value=3;
                        },
                        child: SvgPicture.asset('assets/icons/wishlist2.svg',
                          width: 20,height: 20, color: Colors.white,
                        ),
                      )

                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //todo something
                        },
                        child: SvgPicture.asset('assets/icons/noun_message.svg',width: 20,height: 20,color: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 35,
                        child: TextField(
                          controller: categoriesController.search_controller,
                          cursorColor: Colors.grey,
                          onSubmitted: (query){
                            homeController.go_to_search_page_with_loading(query);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: App_Localization.of(context)!.translate("search"),
                            contentPadding: EdgeInsets.all(5),
                            hintStyle: TextStyle(color: Colors.black26),
                            prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black26,
                                size: 20)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Stack(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(()=>Cart());
                            },
                            child: Container(
                                height: 50,
                                width: 20,
                                child: Icon(Icons.shopping_bag_outlined,color: Colors.white,)),
                          ),
                        ],
                      ),
                      Positioned(
                          top: 28,
                          child: cartController.my_order.length==0?Center():Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Text(cartController.my_order.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      )
    );
  }
  _body(BuildContext context) {
    return Column(
      children: [
        // _categories(context),
        _categories(context),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              homeController.selected_collection.length==0?Center():_sub_categories(context),
              homeController.selected_collection.length==0?Center():SizedBox(width: 10,),
              homeController.selected_collection.length==0?Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: _products_list(context),):_products_list(context),
             
            ],
          ),
        )
      ],
    );
  }
  _categories(BuildContext context){
    return Container(
      height: 40,
      child: ListView.builder(
          itemCount: homeController.collections.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
        return GestureDetector(
          onTap: (){
            homeController.get_sub_category(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Container(
              child: Text(homeController.collections[index].title!,style: TextStyle(color: homeController.select_category.value==index?Colors.white:Colors.grey),),
            ),
          ),
        );

      }),
    );
  }
  _sub_categories(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.37,
        child: Center(
            child: ListView.builder(
              itemCount: homeController.selected_collection.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _sub_categories_drawer(context, index),
                  ],
                );
              },
            )
        )
    );
  }
  _sub_categories_drawer(BuildContext context , int index) {
    return Obx(()=> GestureDetector(
      onTap: () {
        // categoriesController.select_sub_category.value = index;
        // homeController.get_product_by_sub_category(index);
        homeController.get_product(index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        height: 50,
        color: homeController.selected_sub_category.value == index ?
        Colors.white :
        AppColors.main3,
        child: Center(
          child: Text(
            homeController.selected_collection.value[index].title.toString(),
            style:  TextStyle(
                color: homeController.selected_sub_category.value == index ? AppColors.main3 : Colors.white,
                fontSize: 11,
            ),
          ),
        ),
      ),
    ));
  }
  _products_list(BuildContext context) {
    return Container(
      width:  homeController.selected_collection.length==0?MediaQuery.of(context).size.width-20:MediaQuery.of(context).size.width * 0.58,
      height: MediaQuery.of(context).size.height*0.9-50-70,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),

              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:  homeController.selected_collection.length==0?3:2,
                      childAspectRatio: 4/7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10
                  ),
                  itemCount: homeController.products.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.white),
                      ),
                      child: Column(
                        children: [
                         Expanded(
                           flex: 3,
                           child: _products(context,index),),
                          Expanded(
                            flex: 1,
                            child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black
                              ),
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // color: Colors.black
                                      ),
                                      child: Text(
                                        homeController.products.value[index].variants!.first.price!+" "+App_Localization.of(context)!.translate("AED"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      homeController.products[index].title!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,),
                                      maxLines: 2,
                                    ),),
                                ],
                              ),
                            ),
                          ),),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
  _products(BuildContext context , int index) {
    return Hero(
      tag: "product_tag"+homeController.products[index].id.toString()+"categorypage",
      child: GestureDetector(
        onTap: () {
         //Get.to(()=>ProductInfo(homeController.products[index]));
          homeController.go_to_product_page(homeController.products[index].id!,"product_tag"+homeController.products[index].id.toString()+"categorypage");
        },
        child:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(homeController.products[index].image!.src!),
            ),
          ),
        ),
      ),
    );
  }

}
