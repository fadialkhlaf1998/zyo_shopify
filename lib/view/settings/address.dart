import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zyo_shopify/const/app_colors.dart';
import 'package:zyo_shopify/const/app_localization.dart';
import 'package:zyo_shopify/controller/address_controller.dart';

class AddressView extends StatelessWidget {
  AddressView({Key? key}) : super(key: key);

  AddressController checkoutController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
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
      )),
    );
  }

  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,)),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Text(App_Localization.of(context)!.translate("shopping_address"),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
          )
        ],
      ),
    );
  }
  _body(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        _country(context),
        SizedBox(height: 20),
        _names_and_phone(context),
        SizedBox(height: 20),
        _state_city_and_address(context),
        // SizedBox(height: 20),
        // _make_default(context),
        SizedBox(height: 35),
        _save(context),
        SizedBox(height: 20),
      ],
    );
  }
  _country(BuildContext context) {
    return Container(
      color: AppColors.main3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: Text(App_Localization.of(context)!.translate("country_region"),
              style: TextStyle(
                  color: AppColors.main2,
                  fontSize: 16
              ),),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                CountryListPick(
                  pickerBuilder: (context,code) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(" " +code!.name.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios,color: AppColors.main2,size: 20,),
                        ],
                      ),
                    );
                  },
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: Text(
                        App_Localization.of(context)!.translate("choose_a_country")
                    ),
                  ),
                  theme: CountryTheme(
                    labelColor: AppColors.main,
                    alphabetTextColor: Colors.transparent,
                    alphabetSelectedBackgroundColor: Colors.transparent,
                    isShowFlag: false,
                    isShowTitle: true,
                    isShowCode: false,
                    isDownIcon: true,
                    showEnglishName: true,
                  ),
                  initialSelection: checkoutController.country_code,
                  onChanged: (CountryCode? code) {
                    checkoutController.country=code!.name.toString();
                    checkoutController.country_code=code.dialCode.toString();
                    print(code.dialCode.toString());
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  _names_and_phone(BuildContext context) {
    return Container(
      color: AppColors.main3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
              width: MediaQuery.of(context).size.width * 0.93,
              child:IntlPhoneField(
                style: TextStyle(color: Colors.white),
                controller: checkoutController.phone,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  errorText:
                  checkoutController.validate.value && checkoutController.phone.text.isEmpty?
                  App_Localization.of(context)!.translate("phone_is_required") : null,
                  errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: App_Localization.of(context)!.translate("phone_number"),
                  hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main2),
                  ),
                ),
                initialCountryCode: checkoutController.phone_init,
                countryCodeTextColor: Colors.white,
                showDropdownIcon: false,
                onCountryChanged: (phone){
                  checkoutController.phone_code=phone.countryCode!;
                  print(phone.countryCode);
                },
              )
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }
  _state_city_and_address(BuildContext context) {
    return Container(
      color: AppColors.main3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: checkoutController.state,
              cursorColor: Colors.white,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                errorText:
                checkoutController.validate.value && checkoutController.state.text.isEmpty ?
                App_Localization.of(context)!.translate("state_province_is_required") : null,
                errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                hintText: App_Localization.of(context)!.translate("state_province"),
                hintStyle: TextStyle(color: Colors.white,fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: checkoutController.city,
              cursorColor: Colors.white,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                errorText:
                checkoutController.validate.value && checkoutController.city.text.isEmpty ?
                App_Localization.of(context)!.translate("city_is_required") : null,
                errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                hintText:  App_Localization.of(context)!.translate("city"),
                hintStyle: TextStyle(color: Colors.white,fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: checkoutController.address1,
              cursorColor: Colors.white,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                errorText:
                checkoutController.validate.value && checkoutController.address1.text.isEmpty ?
                App_Localization.of(context)!.translate("address1_is_required") : null,
                errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                hintText:  App_Localization.of(context)!.translate("address_1"),
                hintStyle: TextStyle(color: Colors.white,fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: checkoutController.address2,
              cursorColor: Colors.white,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                errorText:
                checkoutController.validate.value && checkoutController.address2.text.isEmpty ?
                App_Localization.of(context)!.translate("address2_is_required"): null,
                errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main2),
                ),
                hintText: App_Localization.of(context)!.translate("address_2"),
                hintStyle: TextStyle(color: Colors.white,fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
  _make_default(BuildContext context) {
    return Container(
      color: AppColors.main3,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(App_Localization.of(context)!.translate("make_default"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                Switch(
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: Colors.grey,
                  activeColor: Colors.white,
                  value: checkoutController.isSwitched.value,
                  onChanged: (value) {
                    checkoutController.isSwitched.value = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _save(BuildContext context) {
    return GestureDetector(
      onTap: () => checkoutController.save(context),
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.93,
        height: MediaQuery.of(context).size.height * 0.08,
        child: Center(
          child: Text(App_Localization.of(context)!.translate("save"),
            style: TextStyle(
                color: AppColors.main,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}