import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/controller/home_controller.dart';
import 'package:zyo_shopify/controller/wishlist_controller.dart';

class WishList extends StatefulWidget {

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  WishListController wishlistController = Get.find();
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.main,
        body: WillPopScope(
          onWillPop: homeController.onWillPop,
          child: Obx((){
            return SafeArea(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: AppColors.main,
                    child: SingleChildScrollView(
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
              ),

            );
          }),
        )
    );
  }

  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Center(
        child: Text(App_Localization.of(context)!.translate("wish_list"),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)
        ),
      ),
    );
  }
  _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3/5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10
            ),
            itemCount: wishlistController.wishlist.length,
            itemBuilder: (BuildContext ctx, index) {
              return _list_wishlist(context,index);
            }),
      ),
    );
  }
  _list_wishlist(BuildContext context, int index) {
    return Hero(
      tag: "product_tag"+wishlistController.wishlist[index].id.toString()+"subcategorypage",
      child: GestureDetector(
        onTap: (){
            // homeController.go_to_product_page(wishlistController.wishlist[index].id,"product_tag"+wishlistController.wishlist[index].id.toString()+"subcategorypage");
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          image: NetworkImage(
                              wishlistController.wishlist[index].image!.src!
                          ),
                          fit: BoxFit.contain
                      ),
                    ),

                  ),),
                Expanded(
                  flex: 2,
                  child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _price(context,index),
                          _title(context,index)
                        ],
                      )
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
  _price(BuildContext context,int index) {
    return  Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              wishlistController.wishlist[index].variants!.first.price!
                  +" "+App_Localization.of(context)!.translate(Global.currency_code),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),),
          ),
          GestureDetector(
              onTap: () {
                //wishlistController.wishlist.value = !wishlistController.wishlist.value;
                wishlistController.delete_from_wishlist(wishlistController.wishlist.value[index]);
                setState(() {
                  wishlistController.loading.value = !wishlistController.loading.value;
                  print(wishlistController.loading.value);
                });
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              )

          )
        ],
      ),
    );
  }
  _title(BuildContext context,int index) {
    return  Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          wishlistController.wishlist[index].title.toString(),
          maxLines: 2,
          style: TextStyle(
              color: Colors.white,
              fontSize: 10
          ),),
      ),
    );
  }
}






