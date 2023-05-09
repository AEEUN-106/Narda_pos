import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:narda_pos/complete_screen.dart';
import 'delivery_screen.dart';
import 'menu_left.dart';
import 'model/store.dart';
import 'package:narda_pos/menu_left.dart'as menu;

import 'model/order.dart';
import 'dart:convert';
import 'api/api.dart';
import 'package:narda_pos/orderHistoryDetail_screen.dart';

List<Order> orders = [];

class TextStyles {
  static const timeTextStyle = TextStyle(fontSize: 50,fontWeight: FontWeight.bold);
  static const mainTextStyle = TextStyle(fontSize: 25);
  static const paymentTextStyle = TextStyle(fontSize: 12);
  static const menuTextStyle = TextStyle(fontSize: 20, color: Colors.grey);
  static const clickButtonStyle = TextStyle(fontSize: 25, color: Colors.white);

}

class BeforeScreen extends StatefulWidget {
  const BeforeScreen({Key? key, required this.storeId}) : super(key: key);
final String storeId;
  @override
  _BeforeScreenState createState() => _BeforeScreenState();
}

class _BeforeScreenState extends State<BeforeScreen> {

  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    orderList();
    super.initState();
  }

  setOrderState(orderId,newState) async{
    try{
      var response = await http.post(
          Uri.parse(API.orderSet),
          body:{
            'orderId' : orderId.toString(),
            'newState' : newState.toString(),
          }
      );
      if(response.statusCode == 200){
        var responseBody = jsonDecode(response.body);
        if(responseBody['success'] == true){
          print("오더 State 변경 완료");

          setState(() {
            orderList();
          });
        }
        else{
          print("오더 State 변경 실패");
        }
      }
    }catch(e){print(e.toString());}
  }


  Widget _navigationWidget(BuildContext context, String storeId) {
    return Column(
      children: <Widget>[
        Expanded(child:SizedBox(
            child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:  MaterialStateProperty.all(Colors.blue[400]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)
                        ))

                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, Animation<double> animation1,
                          Animation<double> animation2) {
                        return BeforeScreen(storeId:storeId);
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Text('호출전')
            )
        )

        )
        ,Expanded(child: SizedBox(child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:  MaterialStateProperty.all(Colors.grey[800]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)
                    ))
            ),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation1,
                      Animation<double> animation2) {
                    return new DeliveryScreen(storeId:storeId);
                  },
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Text('진행중')
        ),) ,)
        ,Expanded(child: SizedBox(
            width: 82,
            child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:  MaterialStateProperty.all(Colors.grey[800]),

                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)
                        ))
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context, Animation<double> animation1,
                          Animation<double> animation2) {
                        return CompleteScreen(storeId:storeId);
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Text('완료')
            ))
        )



      ],


    );
  }
  orderList() async{
    try{
      var response = await http.post(
          Uri.parse(API.orderList),
          body:{
            'storeId' : widget.storeId,
            'state': 0.toString()
          }
      );
      if(response.statusCode == 200){
        orders = [];
        var responseBody = jsonDecode(response.body);
        if(responseBody['success'] == true){
          print(" 오더 리스트 불러오기 성공");
          print(" response.body : " + response.body);
          print("===============\n" + responseBody['userData'].toString());


          List<dynamic> responseList =  responseBody['userData'] ;
          print(" after");
          for(int i=0; i<responseList.length; i++){
            print("~~~~~");
            //print(Order.fromJson(responseList[i]));
            orders.add(Order.fromJson(responseList[i]));
          }
          print("ORDER LENGTH : " + orders.length.toString());
        }
        else {
          print("오더 리스트 불러오기 실패");
        }
        setState(() {});
        return orders;
      }
      else
        {print("오더 리스트 불러오기 실패2 ${response.statusCode}");}
    }catch(e){print(e.toString());}
  }

  @override
  Widget build(BuildContext context) {

    var _listView = ListView.separated(

      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {

        String payment;
        String menu = "";
        int menuNum= 0;
        String location = "";
        String time="";
        int orderID;
        var valueFormat = NumberFormat('###,###,###,###');
        if(orders[index].payment == 0) payment = "결제완료";
        else if(orders[index].payment == 1) payment = "카드결제";
        else payment = "현금결제";


        if(orders[index].orderInfo.length > 18)
          {
            menu = orders[index].orderInfo.substring(0,18);
            menu +="...";
          }
        else
          {
            menu = orders[index].orderInfo;
          }
        print("menu : " + menu);
        time = orders[index].orderTime.substring(11,16);
        menuNum = orders[index].deliveryLocation.split(",").length+1;
List<String> lodationTexts = orders[index].deliveryLocation.split(" ");
        location +=lodationTexts[0];
        location +=" " + lodationTexts[2];
        orderID = orders[index].orderId;
        return Card(child: ListTile(
          leading: Text(time, style: TextStyles.timeTextStyle),
          title: Row(
              children: [
                Text("[메뉴${menuNum}개]",
                    style: TextStyles.mainTextStyle),
                SizedBox(width: 10),
                Text("${valueFormat.format(orders[index].orderValue)}원",
                    style: TextStyles.mainTextStyle),
                SizedBox(width: 10),
                Container(
                    padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),

                    ),
                    child: Text(payment,
                        style: TextStyles.paymentTextStyle)
                )
              ]
          ),
          subtitle:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [      Text(menu,
                style: TextStyles.menuTextStyle) ,
              Text(location,
                  style: TextStyles.mainTextStyle) ,],
          ),
          trailing:  TextButton(onPressed: () async {
setOrderState(orders[index].orderId, 1);
          }, child: Text("호출하기",
            style: TextStyles.clickButtonStyle,),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
          ),
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderHistoryDetailScreen(orderId: orders[index].orderId, storeId: widget.storeId)));
          },),);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );




    return Scaffold(
      body:Row(
          children: [

          _navigationWidget(context, widget.storeId),
      SizedBox(width: 40),
            Expanded(child:  _listView)

           ])

      ,
    );
  }
}


