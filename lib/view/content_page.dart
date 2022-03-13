import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';

class ContentPage extends StatelessWidget {

  String title;
  String content;

  ContentPage(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(

      backgroundColor: AppColors.main,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.93,
                  height: MediaQuery.of(context).size.height*0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: (){Get.back();},),
                      SizedBox(width: 5,),
                      Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),

                      // IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.transparent,),onPressed: (){Get.back();},),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/logo/logo.svg")
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Html(
                    data: content,
                    style: {
                      "p": Style(
                        color: Colors.white,
                      ),
                      "h2": Style(
                        color: Colors.white,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
