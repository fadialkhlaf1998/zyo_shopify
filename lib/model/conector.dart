

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:zyo_shopify/model/collection.dart';
import 'package:zyo_shopify/model/customer.dart';
import 'package:zyo_shopify/model/order.dart';
import 'package:zyo_shopify/model/product.dart';
import 'package:http/http.dart' as http;
import 'package:zyo_shopify/controller/checkout_controller.dart';
//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

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
      Response response =await Dio().get(url+"customers/?email=$email&verified_email=true");
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
  static Future<List<Product>> get_products_by_Collection(List<Product> wishlist,int collection)async{
    try {
      Response response = await Dio().get(
          url + "products.json",
          queryParameters:{
            "collection_id":collection
          }
      );
      return get_favorite(wishlist,Products.fromJson(response.toString()).products??<Product>[]);
    }catch (e){
      return <Product>[];
    }
  }

  static Future<List<Product>> get_all_products(List<Product> wishlist)async{
    try {
      Response response = await Dio().get(
          url + "products.json",

      );
      return get_favorite(wishlist,Products.fromJson(response.toString()).products??<Product>[]);
    }catch (e){
      return <Product>[];
    }
  }
  static Future<List<Product>> get_products(List<Product> wishlist,int collection_id)async{
    try {
    print('*********-------***********');
      Response response = await Dio().get(
        url + "collections/$collection_id/products.json",
      );
      print(response.toString());
      List<Product> ps= Products.fromJson(response.toString()).products??<Product>[];
      print('*********-------***********');
      print(ps.length);
      return get_favorite(wishlist,ps) ;

    }catch (e){
      return <Product>[];
    }
  }
  static List<Product> get_favorite(List<Product> wishlist,List<Product> prods){

    for(int i=0 ; i<wishlist.length;i++){
      for(int j=0 ; j<prods.length;j++){
        if(prods[j].id==wishlist[i].id){
          prods[j].favorite.value=true;
          wishlist[i]=prods[j];
        }
      }
    }
    return prods;
  }
  // static Future<List<Product>> get_all_products()async{
  //   try {
  //     Response response = await Dio().get(
  //       url + "products.json",
  //     );
  //     List<Product> ps= Products.fromJson(response.toString()).products??<Product>[];
  //     return ps;
  //
  //   }catch (e){
  //     return <Product>[];
  //   }
  // }

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

  static Future<int> add_order(List<LineItem> lineitems,String first_name,String last_name,String address_1,String address_2,
      String phone,String city,String state,String country)async{

    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('https://8d8620be60c450adfd02e691d95eedea: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@zyo-designs.myshopify.com/admin/api/2022-01/orders.json'));


    var data= json.encode({
      "order": {
        "line_items": List<dynamic>.from(lineitems.map((x) => x.toMap())),
        "gateway": "Cash on Delivery (COD)",
        "payment_gateway_names": [
          "Cash on Delivery (COD)"
        ],
        "shipping_address": {
          "first_name": first_name,
          "address1": address_1,
          "address2": address_2,
          "phone": "+971"+phone,
          "city": city,
          "province": state,
          "country": country,
          "last_name": last_name,
          "name": first_name + " " + last_name
        },
        "billing_address": {
          "first_name": first_name,
          "address1": address_1,
          "address2": address_2,
          "phone": "+971"+phone,
          "city": city,
          "province": state,
          "country": country,
          "last_name": last_name,
          "name": first_name + " " + last_name
        },
        "financial_status":"pending",
        "total_shipping_price_set": {
          "shop_money": {
            "amount": "15.00",
            "currency_code": "AED"
          },
          "presentment_money": {
            "amount": "15.00",
            "currency_code": "AED"
          }
        },
      }
    });
    request.body=data;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200||response.statusCode == 201) {
      String data = await response.stream.bytesToString();
      print(data);
      print("**********************************************");
      Order order = Order.fromMap(json.decode(data)["order"]);
      ///orderCode
      print(order.id!);
      ///orderType 100: Delivery order
      ///consignor imile
      ///consigneeContact Receiving contact
      ///consigneePhone Recipient's mobile phone number
      ///consigneeCountry UAE
      ///consigneeCity Receiving city
      ///consigneeAddress Recipient's detailed address
      ///goodsValue Declared value: It is recommended to keep at most two decimal places
      ///collectingMoney Collection of money (Local currency): It is recommended to keep at most two decimal places
      ///paymentMethod 200: COD (Cash On Delivery)
      ///totalCount 1
      ///totalWeight 3/4
      ///totalVolume 1
      ///skuTotal Total number of all SKUs: must be an integer greater than 0
      ///skuName SKU1*2+SKU2*3+SKU3*1
      ///batterType Battery properties
      // Normal	General cargo without electricity
      ///currency local
      ///skuNo sku encoding (EGY required)
      ///skuName sku name(KWT,EGY required)
      ///skuDesc sku description(EGY required)
      ///skuQty number of sku(KWT,EGY required)
      ///skuUrl sku url(EGY required)
      ///skuGoodsValue sku total declared amount(KWT is required)

      int count = 0;
      int total_count = 0;

      String skuName = "";

      for(int i=0;i<order.lineItems!.length;i++){
        count++;
        total_count+=order.lineItems![i].quantity!;
        if(i!=order.lineItems!.length-1){
          skuName += order.lineItems![i].sku! + "*" + order.lineItems![i].quantity!.toString()+" + ";
        }else{
          skuName += order.lineItems![i].sku! + "*" + order.lineItems![i].quantity!.toString();
        }
      }
      print(DateTime.now().millisecondsSinceEpoch);

      String token = await _get_token();
      add_order_to_shipping(token,order.id!.toString(),count,total_count,skuName, first_name, last_name, address_1, address_2,
           phone, city, state, country,order.totalPrice!);
      //todo change ture
      return order.id!;
    }
    else {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
      return -1;
    }

  }
  static Future<String> get_token()async{
    print('***********token************');
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://openapi.imile.com/auth/accessToken/grant'));
    request.body = json.encode({
      "customerId": "C2106654",
      "sign": "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJ+pYUN9Y9c7lYkz",
      // "accessToken": "9f805e5a-1edd-4c1a-bd9d-84dcbd467c4a",
      "signMethod": "SimpleKey",
      "format": "json",
      "version": "1.0.0",
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "timeZone": "+4",
      "param": {
        "grantType": "clientCredential"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('*****************');
      var data = (await response.stream.bytesToString());
      var jsondata = jsonDecode(data);
      print(jsondata["data"]["accessToken"]);
      return jsondata["data"]["accessToken"];
    }
    else {
      print(response.reasonPhrase);
      return "non";
    }

  }

  static Future<String> _get_token()async{
    var data = await get_token();
    if(data=="non"){
      return await _get_token();
    }else{
      return data;
    }
  }

  static add_order_to_shipping(String token,String order_id,int count,int total_count,String skuName,
      String first_name,String last_name,String address_1,String address_2,
      String phone,String city,String state,String country,String price) async{
    print('***********order************');
    print('order ID:' + order_id );
    print('skuName:' + skuName );
    print('count:' + count.toString() );
    print('total_count:' + total_count.toString());
    print('price:' + price);
    price = (double.parse(price)+15.00).toString();
    print('price:' + price);
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://openapi.imile.com/client/order/createOrder'));
    request.body = json.encode({
      "customerId": "C2106654",
      "sign": "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJ+pYUN9Y9c7lYkz",
      // "accessToken": "9f805e5a-1edd-4c1a-bd9d-84dcbd467c4a",
      "accessToken": token,
      "signMethod": "SimpleKey",
      "format": "json",
      "version": "1.0.0",
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "timeZone": "+4",
      "param": {
        "orderCode": order_id,
        "orderType": "100",
        //"oldExpressNo": "",
        "consignor": "ZYO Collection",
        // "consignorAddress": "DubaiPickup",
        // "consignee": "fadi alkhlaf",
        "consigneeContact": first_name+" "+last_name,
        //"consigneeMobile": "+971589655651",
        "consigneePhone": phone,
        //"consigneeEmail": "test@testing.com",
        "consigneeCountry": country,
        "consigneeProvince": state,
        "consigneeCity": city,
        //"consigneeArea": "test",
        "consigneeAddress": address_1+" / "+address_2,
        "goodsValue": price,
        "collectingMoney": price,
        "paymentMethod": "200",
        "totalCount": total_count,
        "totalWeight": "3.500",
        "totalVolume": 1,
        "skuTotal": count,
        "skuName": skuName,
        "batterType":"Normal",
        "currency": "Local",
        // "skuZh": "Face towel",
        // "deliveryRequirements": "",
        // "orderDescription": "remarks here",
        // "buyerId": "",
        // "platform": "",
        // "isInsurance": 0,
        // "pickDate": "",
        // "pickType": "0",
        // "batterType": "",

      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

  }

  static Future<int> add_order_pick_up(List<LineItem> lineitems,String first_name,String last_name,String address_1,String address_2,
      String phone,String city,String state,String country)async{

    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('https://8d8620be60c450adfd02e691d95eedea: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@zyo-designs.myshopify.com/admin/api/2022-01/orders.json'));


    var data= json.encode({
      "order": {
        "line_items": List<dynamic>.from(lineitems.map((x) => x.toMap())),
        "gateway": "Cash on Delivery (COD)",
        "billing_address": {
          "first_name": first_name,
          "address1": address_1,
          "address2": address_2,
          "phone": "+971"+phone,
          "city": city,
          "province": state,
          "country": country,
          "last_name": last_name,
          "name": first_name + " " + last_name
        },
        "financial_status":"pending"
      }
    });
    request.body=data;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200||response.statusCode == 201) {
      String data = await response.stream.bytesToString();
      Order order = Order.fromMap(json.decode(data)["order"]);
      print(order.id!);
      return order.id!;
    }
    else {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
      return -1;
    }

  }

}

