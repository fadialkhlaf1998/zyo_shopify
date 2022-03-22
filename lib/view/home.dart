import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/controller/cart_controller.dart';
import 'package:zyo_shopify/controller/home_controller.dart';
import 'package:zyo_shopify/controller/wishlist_controller.dart';
import 'package:zyo_shopify/view/cart.dart';
import 'package:zyo_shopify/view/categories.dart';
import 'package:zyo_shopify/view/settings.dart';
import 'package:zyo_shopify/view/wishlist.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  ScrollController _scrollController = ScrollController();

  HomeController homeController = Get.put(HomeController());
  CartController cartController = Get.find();
  WishListController wishListController = Get.find();
  String _url = 'https://flutter.dev';

  _checkVersion(BuildContext context)async{
    //todo change IDS
    final newVersion = NewVersion(
      iOSId: "",
      androidId: 'com.maxart.zyo_shopify',
    );
    final state = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(context: context, versionStatus: state!);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _checkVersion(context);
    return Scaffold(
      key: homeController.key,
      backgroundColor: AppColors.main,
      bottomNavigationBar: _btnNavBar(context),
      body: Obx(() {
        return  homeController.select_nav_bar == 0 ? _home(context) :
        homeController.select_nav_bar == 1 ? Categories() :
        homeController.select_nav_bar == 2 ? WishList() : Settings();
      }),
    );
  }

  _btnNavBar(BuildContext context) {
    return Obx(() => Container(
      width: MediaQuery.of(context).size.width,
      child: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(fontSize: 11),
        selectedLabelStyle: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
        selectedItemColor: AppColors.main,
        unselectedItemColor: Colors.black87,
        currentIndex: homeController.select_nav_bar.value,
        onTap: (index) {
          if(index==0&&homeController.select_nav_bar==0){
            _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
          homeController.last_select_nav_bar.value=homeController.select_nav_bar.value;
            homeController.set_nav_bar(index);
        },
        items: [
          BottomNavigationBarItem(
            icon:
            homeController.select_nav_bar.value==0 ?
            Icon(Icons.home, size: 25) :
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/Icon_home.svg',width: 15,height: 15,
              ),
            ),
            label: App_Localization.of(context)!.translate("home"),
          ),
          BottomNavigationBarItem(
            icon: homeController.select_nav_bar.value == 1 ?
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/categories2.svg',width: 15,height: 15,
              ),
            ) :
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/categories.svg',width: 15,height: 15,
              ),
            ),
            label: App_Localization.of(context)!.translate("categories"),
          ),
          // BottomNavigationBarItem(
          //   icon: homeController.select_nav_bar.value == 2 ?
          //   Padding(
          //     padding: const EdgeInsets.all(3),
          //     child: SvgPicture.asset('assets/icons/new_collection2.svg',width: 18,height: 18,
          //     ),
          //   ) :
          //   Padding(
          //     padding: const EdgeInsets.all(3),
          //     child: SvgPicture.asset('assets/icons/new_collection.svg', width: 18,height: 18
          //     ),
          //   ),
          //   label: App_Localization.of(context)!.translate("new"),
          // ),
          BottomNavigationBarItem(
            icon: homeController.select_nav_bar.value == 2 ?
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/wishlist2.svg',width: 15,height: 15,
              ),
            ) :
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/wishlist_icon.svg',width: 15,height: 15,
              ),
            ),
            label: App_Localization.of(context)!.translate("wishlist"),
          ),
          BottomNavigationBarItem(
            icon: homeController.select_nav_bar.value == 3 ?
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/settings2.svg',width: 15,height: 15,
              ),
            ) :
            Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset('assets/icons/Icon_settings.svg',width: 15,height: 15,
              ),
            ),
            backgroundColor: Colors.white,
            label: App_Localization.of(context)!.translate("settings"),
          ),
        ],
      ),
    ),
    );
  }

  _home(BuildContext context) {
    return WillPopScope(
      onWillPop: homeController.onWillPop,
      child: SafeArea(
        child: Obx((){
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColors.main,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [

                      SizedBox(height: MediaQuery.of(context).size.height * 0.12,),
                      // _slider(context),
                      _raduce_category(context),
                      homeController.selected_collection.value.length==0?
                      Center()
                      :_sub_category(context),
                      _products(context)
                    ],
                  ),
                ),
              ),
              Positioned(child:   _header(context),),
              Positioned(child: homeController.loading.value?Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(1),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white,),
                ),
              ):Center())
            ],
          );
        }),
      ),
    );
  }
  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      height: MediaQuery.of(context).size.height *0.12,
      color: AppColors.main,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            homeController.select_nav_bar.value =2;
                          },
                          child: Icon(Icons.favorite_border,color: Colors.white,),
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
                    SizedBox(width: 15),
                  ],
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child:  SvgPicture.asset("assets/logo/logo.svg",),
                  )

                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.search,
                            color: Colors.white),
                        onPressed: () => _pressed_on_search(context)
                    ),
                    cartController.my_order.length==0?Center(): Stack(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _sub_category(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20,bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,

        child: Column(
          children: [
            Row(
              children: [
                Text(App_Localization.of(context)!.translate("categories"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)
              ],
            ),
            Container(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: homeController.selected_collection.length,
                  itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  child: GestureDetector(
                    onTap: (){
                      homeController.get_product(index);
                    },
                    child: Column(
                      children: [
                        Container(
                         child: Column(
                            children: [
                              Text(homeController.selected_collection[index].title!,style: TextStyle(color: homeController.selected_sub_category.value==index?Colors.white:Colors.grey,fontSize: 11),),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
  _products(BuildContext context){
    return Padding(
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: homeController.selected_collection.value.length==0?20:0),
        child: homeController.products.value.length==0?
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.4,
              child: Center(
                child: Text(App_Localization.of(context)!.translate("no_content"),style: TextStyle(fontSize: 14,color: Colors.white),),
              ),
            )
            :Container(
          child: GridView.builder(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: homeController.products.value.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4/7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20
              ),
              itemBuilder: (context,index){
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        homeController.go_to_product(homeController.products[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Expanded(
                                flex: 5,
                                  child: Container(

                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: NetworkImage(homeController.products.value[index].image!.src!,),
                                        fit: BoxFit.contain
                                      )
                                    ),
                                  )
                              ),

                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                     Text(homeController.products.value[homeController.selected_sub_category.value].title!,style: TextStyle(color: Colors.white,fontSize: 11,),textAlign: TextAlign.left,maxLines: 2,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(homeController.products.value[homeController.selected_sub_category.value].variants!.first.price!+" "+ App_Localization.of(context)!.translate("AED"),style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),

                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,

                        child: Obx((){
                          return IconButton(
                            onPressed: (){
                              if(homeController.products[index].favorite.value){
                                wishListController.delete_from_wishlist(homeController.products[index]);

                              }else{
                                wishListController.add_to_wishlist(homeController.products[index], context);
                              }
                            },
                            icon: Icon(homeController.products[index].favorite.value?Icons.favorite:Icons.favorite_border,color: homeController.products[index].favorite.value?Colors.red:Colors.black,),
                          );
                        }))
                  ],
                );
          }),
        ),
    );
  }
  _slider(BuildContext context){
    return
      Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.65,
            child: ImageSlideshow(

              /// Width of the [ImageSlideshow].
              width: double.infinity,

              /// Height of the [ImageSlideshow].
              height: MediaQuery.of(context).size.height*65,

              /// The page to show when first creating the [ImageSlideshow].
              initialPage: homeController.select_category.value,

              /// The color to paint the indicator.
              indicatorColor: Colors.transparent,

              /// The color to paint behind th indicator.
              indicatorBackgroundColor: Colors.transparent,

              /// The widgets to display in the [ImageSlideshow].
              /// Add the sample image file into the images folder
              children:homeController.collections.map((e){
                return Stack(
                  children: [
                    Container(
                        // margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(children: <Widget>[
                      InkResponse(
                      child: Image.network(e.image==null?"https://w0.peakpx.com/wallpaper/611/707/HD-wallpaper-nazriya-nose-hair.jpg":e.image!.src!,
                      fit: BoxFit.cover, width: 1000.0),)]))),
                   Positioned(
                       bottom: 20,
                       child:  Container(
                         width: MediaQuery.of(context).size.width,
                         child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                         Text(e.title!,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),)
                     ],
                   ),
                       ))
                  ],
                );
              }).toList(),

              /// Called whenever the page in the center of the viewport changes.
              onPageChanged: (value) {
                print('Page changed: $value');
                homeController.select_category.value=value;
                          homeController.get_sub_category(value);
              },

              /// Auto scroll interval.
              /// Do not auto scroll with null or 0.
              autoPlayInterval: 0,

              /// Loops back to first slide.
              isLoop: true,

            ),
          ),
          _header(context)
        ],

      );
  }

  _raduce_category(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.2,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: homeController.collections.value.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context , index){
            return GestureDetector(
              onTap: (){
                homeController.select_category.value=index;
                homeController.get_sub_category(index);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.height*0.2-40,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.2-40,
                        width: MediaQuery.of(context).size.height*0.2-40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(homeController.collections.value[index].image==null?"https://w0.peakpx.com/wallpaper/611/707/HD-wallpaper-nazriya-nose-hair.jpg":homeController.collections.value[index].image!.src!),
                            fit: BoxFit.fill
                          )
                        ),
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.height*0.2-40,
                        child: Center(
                          child: Text(homeController.collections.value[index].title!,style: TextStyle(fontWeight: FontWeight.bold,color:homeController.select_category.value==index?Colors.white:Colors.grey ),maxLines: 2,textAlign: TextAlign.center,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  _pressed_on_search(BuildContext context) async {
    final result = await showSearch(
        context: context,
        delegate: SearchTextField(suggestion_list: Global.suggestion_list,homeController: homeController));
    // homeController.go_to_search_page(result!);
    // print(result);
  }

}




class SearchTextField extends SearchDelegate<String> {
  final List<String> suggestion_list;
  String? result;
  HomeController homeController;

  SearchTextField(
      {required this.suggestion_list, required this.homeController});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isEmpty
          ? Visibility(
        child: Text(''),
        visible: false,
      )
          : IconButton(
        icon: Icon(Icons.close, color: Colors.white,),
        onPressed: () {
          // close(context, query);
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    );
  }


  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: AppBarTheme(
        color: AppColors.main, //new AppBar color
        elevation: 0,
      ),
      hintColor: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.white
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = suggestion_list.where((name) {
      return name.toLowerCase().contains(query.toLowerCase());
    });
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(App_Localization.of(context)!.translate("fail_search"),style: TextStyle(fontSize: 12,color: Colors.white),),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = homeController.all_products.value.where((elm) {
      return elm.title!.toLowerCase().contains(query.toLowerCase());
    });
    return Container(
      color: AppColors.main,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              suggestions.elementAt(index).title!,
              style: TextStyle(color: AppColors.main2),
            ),
            subtitle: Text(
              suggestions.elementAt(index).tags!,
              style: TextStyle(color: AppColors.main2.withOpacity(0.5),fontSize: 12),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(suggestions.elementAt(index).image!.src!)
                    )
                ),
              ),
            ),
            onTap: () {
              // query = suggestions.elementAt(index).title!;
              homeController.go_to_product(suggestions.elementAt(index));
            },
          );
        },
      ),
    );
  }
}



