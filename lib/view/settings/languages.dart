import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/global.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/controller/settings/languages_controller.dart';

class Languages extends StatelessWidget {
  Languages() {
    if(Global.language_code == "en") {
      languagesController.select_value.value = 0;
    }
    else if(Global.language_code == "ar"){
      languagesController.select_value.value = 1;
    }
    else if(Global.language_code == "ru"){
      languagesController.select_value.value = 2;
    }
    else if(Global.language_code == "hi"){
      languagesController.select_value.value = 3;
    }else{
      languagesController.select_value.value = 4;
    }
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: AppColors.main,
      body: Obx(() => SafeArea(
        child: Container(
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
      ))
    );
  }

  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,)),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Text(App_Localization.of(context)!.translate("languages"),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
          ),
        ],
      ),
    );
  }
  _body(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        _languages(context),
        SizedBox(height: 20)
      ],
    );
  }
  _languages(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.93,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: languagesController.languages.length,
            itemBuilder: (context,index) {
              return Obx(()=> GestureDetector(
                onTap: () {
                  print(languagesController.languages[index]['id']);
                      Global.set_language(context, languagesController.languages[index]['id']);
                  languagesController.select_value.value = index;
                  if(languagesController.languages[index]['id'] == "en" ) {
                    languagesController.value = languagesController.languages[index]["name"];
                  }
                  else {
                    languagesController.value = languagesController.languages[index]["name"];
                  }
                  },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      color: AppColors.main,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.languages[index]['name'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                          ),
                          Icon(
                              Icons.check,
                              color: languagesController.select_value.value == index ?
                              Colors.white : Colors.transparent,size: 20,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                    )
                  ],
                ),
              ));
            },
          ),
        )
      ],
    );
  }

}
