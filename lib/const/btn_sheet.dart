import 'package:flutter/material.dart';

class BtnSheet {

  static Color main2 = Color(0xffA7A7A7);

  btn_sheet(BuildContext context , String text1 , String text2) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1,style: TextStyle(color: Colors.white,fontSize: 15),)
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text2,style: TextStyle(color: main2,fontSize: 15),)
            ],
          ),
        ),
        Column(),
      ],
    );
  }

}
