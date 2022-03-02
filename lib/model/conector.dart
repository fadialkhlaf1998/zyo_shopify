

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:zyo_shopify/model/collection.dart';
import 'package:zyo_shopify/model/customer.dart';
import 'package:zyo_shopify/model/order.dart';
import 'package:zyo_shopify/model/product.dart';

class Connector{

  // static String url="https://8d8620be60c450adfd02e691d95eedea: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@zyo-designs.myshopify.com/admin/api/2021-10/";
  static String url="https://8d8620be60c450adfd02e691d95eedea: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@zyo-designs.myshopify.com/admin/api/2022-01/";

  static Future<bool> check_internet()async{
    // return false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    }else{
      return false;
    }

  }




  static Future<bool> add_customer(String first_name,String last_name,String email,String password)async{
    try{
      FormData form_data=FormData.fromMap(

          {
            "customer": {
              "first_name": first_name,
              "last_name": last_name,
              "email": email,
              "verified_email": true,
              "addresses": []
            }
          }

      );
      Response response =await Dio().post(url+'customers.json',data: form_data,);
      print(response);
      return true;

    }catch (e){
      print(e.toString());
      return false;
    }
  }
  static Future<int> login_customers(String email,String pass)async{
    try{
      Response response =await Dio().get(url+"customers/search.json?email=$email&verified_email=true");
      var customers_json=response.data['customers'] as List;
      return customers_json[0]['id'];
    }catch (e){
      print(e.toString());
      return -1;
    }
  }
  static Future<Customer?> get_customer(int customer_id)async{
    try{
      Response response =await Dio().get(url+"customers/${customer_id}.json");

      return Customer.fromMap(response.data['customer']);
    }catch (e){
      print(e.toString());
      return null;
    }
  }
  static Future<List<Collection>> get_collections ()async{
    try {
      Response response = await Dio().get(
          url + "smart_collections.json"
      );
      return Collections
          .fromJson(response.toString())
          .smartCollections ?? <Collection>[];
    }catch(e){
      print(e.toString());
      return <Collection>[];
    }
  }
  static Future<List<Product>> get_products_by_Collection(String collection)async{
    try {
      Response response = await Dio().get(
          url + "products.json",
          queryParameters:{
            "tags":collection
          }
      );
      return Products.fromJson(response.toString()).products??<Product>[];
    }catch (e){
      return <Product>[];
    }
  }
  static Future<List<Product>> get_products(int collection_id)async{
    try {
      Response response = await Dio().get(
        url + "collections/$collection_id/products.json",
      );

      return Products.fromJson(response.toString()).products??<Product>[];

    }catch (e){
      return <Product>[];
    }
  }
  static Future<List<Order>> get_customer_orders(int cusomer_id)async{
    try {
      Response response = await Dio().get(
          url + "customers/$cusomer_id/orders.json"
      );
      return Ordres.fromJson(response.toString()).orders??<Order>[];
    }catch (e){
      return <Order>[];
    }
  }
  static create_address(Customer customer,String first_name,String last_name,String address_1,String address_2,String phone,String country,String city,String province,bool _default)async{
    try {
      FormData form_data=FormData.fromMap(
          {
            "address": {
              "address1": address_1,
              "address2": address_2,
              "city": city,
              "company": "",
              "first_name": first_name,
              "last_name": last_name,
              "phone": phone,
              "province": province,
              "country": country,
              "zip": "",
              "name": "",
              "province_code": "",
              "country_code": "",
              "country_name": "",
              "default": _default
            }
          }
      );
      Response response =await Dio().post(url+"customers/${customer.id}/addresses.json",data: form_data,);
      print(response);
    }catch (e){

    }
  }
  static update_address(Customer customer,DefaultAddress defaultAddress)async{
    try {
    FormData form_data=FormData.fromMap(
        {
          "customer_address": {
            "customer_id": 207119551,
            "zip": "90210",
            "country": "United States",
            "province": "Kentucky",
            "city": "Louisville",
            "address1": "Chestnut Street 92",
            "address2": "",
            "first_name": null,
            "last_name": null,
            "company": null,
            "phone": "555-625-1199",
            "id": 207119551,
            "name": "",
            "province_code": "KY",
            "country_code": "US",
            "country_name": "United States",
            "default": true
          }
        }
    );
    Response response =await Dio().put(url+"/admin/api/2021-07/customers/${customer.id}/addresses/${defaultAddress.id}.json",data: form_data,);
    }catch (e){
      print(e.toString());
      return <Order>[];
    }
  }
  static Future<bool> delete_address(Customer customer,int Address_id)async{
    try {
      Response response =await Dio().delete(url+"customers/${customer.id}/addresses/${Address_id}.json",);
      return true;
    }catch (e){
      return false;
    }
  }
  static Future<List<DefaultAddress>> get_address(Customer customer)async{
    try {
      List<DefaultAddress> address=<DefaultAddress>[];
      Response response =await Dio().get(url+"customers/${customer.id}/addresses.json",);

      var json_address = jsonDecode(response.toString())['addresses'] as List;
      for(int i=0 ; i<json_address.length;i++){
        address.add(DefaultAddress.fromMap(json_address[i]));
      }
      return address;
    }catch (e){
      return <DefaultAddress>[];
    }
  }
  static Future<bool> set_address_default(Customer customer,int Address_id)async{
    try {
      List<DefaultAddress> address=<DefaultAddress>[];
      Response response =await Dio().put(url+"customers/${customer.id}/addresses/${Address_id}/default.json",);
      return true;
    }catch (e){
      return false;
    }
  }

}