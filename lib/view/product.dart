import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/api.dart';
import 'package:zyo_shopify/const/app.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/controller/cart_controller.dart';
import 'package:zyo_shopify/controller/product_controller.dart';
import 'package:zyo_shopify/controller/wishlist_controller.dart';
import 'package:zyo_shopify/model/product.dart';
import 'package:zyo_shopify/view/cart.dart';
import 'package:zyo_shopify/view/content_page.dart';
import 'package:zyo_shopify/view/no_internet.dart';
import 'package:zyo_shopify/view/registation.dart';

class ProductInfo extends StatelessWidget {
  Product product;


  ProductController productController = Get.put(ProductController());
  WishListController wishListController = Get.find();
  CartController cartController = Get.find();
  ProductInfo(this.product){
    print(product.options![0].values![0]);
    print(product.variants!.length);

    productController.select_color.value=product.options![0].values!.first;
    try{
      productController.select_size.value=product.options![1].values!.first;
    }catch(err){
      productController.select_size.value="no size";
    }
    get_varint();
    // for(int i=0;i<wishListController.wishlist.length;i++){
    //   if(wishListController.wishlist[i].id==product.id){
    //     product.favorite.value=true;
    //     break;
    //   }
    // }

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        body:Obx(()=> SafeArea(
          child: Container(
              child:SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        _slider_images(context),
                        _header(context),
                      ],
                    ),
                    _black_body(context),
                  ],
                ),
              )
          ),
        ))
    );
  }

  Variant? get_varint(){
    print(product.variants!.length.toString()+"-*-*-*-*-*-*-*-*");
    for(int i=0 ; i< product.variants!.length;i++){
      if(product.variants![i].option1==productController.select_color.value&&product.variants![i].option2==productController.select_size.value){
        productController.selected_varient=product.variants![i].obs;
        productController.selected_varient_index=i;
        // print("***************************");
        // print(productController.selected_varient_index=i);
        return product.variants![i];
      }
    }
    return null;
  }
  _black_body(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.4-MediaQuery.of(context).padding.top,
      color: AppColors.main,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.variants!.first.price!+" "+App_Localization.of(context)!.translate("AED"),style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
            Container(
              width: MediaQuery.of(context).size.width,
              child:Text(product.title!,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.normal),textAlign: TextAlign.left,),
            ),

            Row(
              mainAxisAlignment: product.options!.length<=1?MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
              children: [
                product.options!.length<=1?Center():
                  Container(
                    width: MediaQuery.of(context).size.width*0.42,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white)
                    ),
                    child:DropdownButton<String>(
                      icon: Icon(Icons.add,color: Colors.transparent,size: 0),
                      style: TextStyle(color: Colors.black),
                      hint: Container(
                        width:MediaQuery.of(context).size.width*0.42-5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(App_Localization.of(context)!.translate("size"),style: TextStyle(color: Colors.white,fontSize: 17),),
                            SizedBox(width: 1,),
                            SizedBox(width: 1,),
                            Text(productController.select_size.value,style: TextStyle(color: Colors.white,fontSize: 17),),
                          ],
                        ),
                      ) ,
                      underline: Container(height: 0,),
                      items: product.options![1].values!.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (e) {
                        print(e);
                        productController.select_size.value=e.toString();
                        get_varint();
                        // productController.select_size.value=product.options![1].values.indexOf(e);
                    },
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width*0.42,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white)
                  ),
                  child:DropdownButton<String>(
                    icon: Icon(Icons.add,color: Colors.transparent,size: 0),
                    style: TextStyle(color: Colors.black),
                    hint: Container(
                      width:MediaQuery.of(context).size.width*0.42-5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(App_Localization.of(context)!.translate("color"),style: TextStyle(color: Colors.white,fontSize: 17),),
                          SizedBox(width: 1,),
                          SizedBox(width: 1,),
                          Text(productController.select_color.value,style: TextStyle(color: Colors.white,fontSize: 17),),
                        ],
                      ),
                    ) ,
                    underline: Container(height: 0,),
                    items: product.options![0].values!.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (e) {
                      print(e);
                      productController.select_color.value=e.toString();
                      get_varint();
                      // productController.select_size.value=product.options![1].values.indexOf(e);
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    cartController.add_to_cart(product, productController.selected_varient_index, 1,context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.42,
                    height: 40,
                    color: Colors.white,
                    child:Center(
                      child: Text(App_Localization.of(context)!.translate("add_to_bag"),style: TextStyle(color: AppColors.main,fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 1,),
          ],
        ),
      ),
    );
  }

  Widget build0(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: Obx(()=> SafeArea(
        child:  CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: AppColors.main,
                  child: Column(
                    children: [
                      _header(context),
                      _body(context),
                    ],
                  ),
                ),
              ),
              backgroundColor: AppColors.main,
              expandedHeight: MediaQuery.of(context).size.height,
            ),
            Container(
              child: SliverList(delegate: SliverChildListDelegate.fixed([

                Obx(() =>  Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height*0.8,
                  color: AppColors.main,
                  child: Column(
                    children: [
                       _goods(context) ,
                      _footer(context),
                      _reviews(context),
                    ],
                  ),
                ))
              ])),
            )
          ],
        ),
      )),
    );
  }

  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )
                )
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
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
                                  child: Icon(Icons.shopping_bag_outlined,color: Colors.black,)),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _footer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx((){
                 return GestureDetector(
                      onTap: () {
                        if(!product.favorite.value){
                          wishListController.add_to_wishlist(product, context);
                         product.favorite.value=true;
                        }else {
                          wishListController.delete_from_wishlist(product);
                          product.favorite.value = false;
                        }
                      },
                      child: !product.favorite.value ?
                      Icon(Icons.favorite_border,color: AppColors.main,size: 30,) :
                      Icon(Icons.favorite, color: Colors.red,size: 30,)
                  );
                })
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                      App.sucss_msg(context, App_Localization.of(context)!.translate("just_added_to_your_bag"));
                  },
                  child: Container(
                    color: AppColors.main,
                    width: MediaQuery.of(context).size.width * 0.78,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Center(
                      child: Text(App_Localization.of(context)!.translate("add_to_bag"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  _body(BuildContext context) {
    return Column(
      children: [
        _slider_images(context),
        SizedBox(height: 20),
        _title2(product,context),
        SizedBox(height: 10),
        _price_and_rating(product,context),
      ],
    );
  }
  _slider_images(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: productController.controller,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.6,
              autoPlay:product.images!.length>1
                  ? true
                  : false,
              viewportFraction: 1,
              autoPlayInterval: Duration(seconds: 3),
              onPageChanged: (index, reason) {

                productController.set_index(index);
              }),

          itemCount: product.images!.length,
          itemBuilder: (BuildContext context,
              int index, int realIndex) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration:BoxDecoration(
                color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                        product.images![index].src!
                    ),
                    fit: BoxFit.contain,
                  )),
            );
          },
        ),
        Positioned(
          bottom: 20,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.main
                            ),
                            child:   Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                                  child: Text(
                                    (productController.activeIndex.value+1).toString()+
                                        "/" +
                                        product.images!.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),),
                                )
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          )
        )
      ],
    );
  }
  _price_and_rating(Product product, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              product.variants!.first.price!+ " " + App_Localization.of(context)!.translate(Global.currency_code),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),),
          ),
        ],
      ),
    );
  }
  _goods(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // _header2(context),
          // _product_image(context),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height * 0.15,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(App_Localization.of(context)!.translate("goods"),
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 18,
          //               decoration: productController.selected.value==0 ?
          //               TextDecoration.underline : TextDecoration.none
          //           )
          //       ),
          //       SizedBox(width: 50,),
          //       GestureDetector(
          //         onTap: () {
          //           productController.selected.value ++;
          //         },
          //         child: Text(App_Localization.of(context)!.translate("reviews"),
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 18,
          //             )
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 10),
          _title2(product,context),
          SizedBox(height: 10),
          _price_and_rating(product,context),
          SizedBox(height: 10),
          _list_of_color(context),
          SizedBox(height: 10),
          _list_of_size(context),
          SizedBox(height: 10),
          Divider(
            color: Colors.white12,
            thickness: 5,
          ),
          GestureDetector(
           onTap: () {
             Get.to(()=>ContentPage(App_Localization.of(context)!.translate("return_police"), App_Localization.of(context)!.translate("return_policy_content")));
            },
           child:  Container(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   children: [
                     Row(
                       children: [
                         Transform.scale(
                           scale: 1.1,
                           child: Checkbox(
                             side: MaterialStateBorderSide.resolveWith(
                                   (states) => BorderSide(width: 1.0,
                                   color: productController.checked.value ? Colors.transparent : Colors.white),
                             ),
                             activeColor: Colors.green,
                             checkColor: Colors.black,
                             shape: CircleBorder(),
                             value: productController.checked.value,
                             onChanged: (value) {
                               productController.checked.value = value!;
                             },
                           ),
                         ),
                         Center(
                           child: Text(App_Localization.of(context)!.translate("return_police"),
                             style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 15
                             ),),
                         ),
                       ],
                     )
                   ],
                 ),
                 Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(10),
                       child: Icon(Icons.arrow_forward_ios,
                         color: Colors.white,size: 20,),
                     )
                   ],
                 ),
               ],
             ),
           ),
         ),
          Divider(
            color: Colors.white12,
            thickness: 5,
          ),
          _description(context),
          Divider(
            color: Colors.white12,
            thickness: 1,
          ),
          _size_information(context),
          SizedBox(height: 10)
        ],
      ),
    );
  }
  _header2(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width * 0.93,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
  _product_image(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration:BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: NetworkImage(product.image!.src!),
                fit: BoxFit.fill,
              )),
        )
      ],
    );
  }
  _title2(Product product,BuildContext context) {
    return Column(
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.93,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.93-100,
                        child: Text(
                          product.title.toString(),
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                          ),),
                      ),

                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ],
    );
  }
  _list_of_color(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child:  Wrap(
          children: product.options![0].values!.map((e) =>   Text(e.toString()+(product.options![0].values!.indexOf(e)==product.options![0].values!.length-1?"":" | "),style: TextStyle(fontSize: 20,color: Colors.black),)).toList()
      ),
    );
  }
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  _list_of_size(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      child: Wrap(
          children: product.options![1].values!.map((e) =>   Text(e.toString()+(product.options![1].values!.indexOf(e)==product.options![1].values!.length-1?"":" | "),style: TextStyle(fontSize: 20,color: Colors.black),)).toList()
      ),
    );
  }
  _description(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child:GestureDetector(
            onTap: () {
              _btm_sheet_desc(context);
            },
            child:  Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width * 0.93,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(App_Localization.of(context)!.translate("description"),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.arrow_forward_ios,
                        color: Colors.white,size: 20,)
                    ],
                  ),
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
  _size_information(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,

    );
  }
  _reviews(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,

    );
  }


  _btm_sheet_desc(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context)
      {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: AppColors.main,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(App_Localization.of(context)!.translate("description"),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.close,color: Colors.white,))

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Divider(
                  thickness: 2,
                  color: Colors.white12,
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(data:product.bodyHtml)
                    ],
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      },
    );
  }
}



