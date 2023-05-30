import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/order.dart';
import 'api/api.dart';
import 'model/orderDetail.dart';

Order order = new Order(1, 1, "", "pickupTime", "deliveryTime", 1, 10, "deliveryLocation", "deliveryRequest", "1", "1", 1, "orderInfo", "customerNum", 1);
Duration? duration;
class OrderHistoryDetailScreen extends StatefulWidget {
  const OrderHistoryDetailScreen(
  {Key? key, required this.orderId, required, required this.storeId})
: super(key: key);
final int orderId;
final String storeId;
@override
State<OrderHistoryDetailScreen> createState() =>
    _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  @override
  void initState() {
    orderDetail();
    super.initState();
  }

  orderDetail() async {
    try {
      var response = await http.post(Uri.parse(API.orderDetail), body: {
        'orderId': widget.orderId.toString(),
        'storeId': widget.storeId
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("오더 디테일 불러오기 성공");
          print(responseBody['userData']);
          order = Order.fromJson(responseBody['userData']);
          DateTime orderTime = DateTime.parse(order!.orderTime);
          DateTime current = DateTime.now();

          duration = current.difference(orderTime);
          print("duration : $duration");
        } else {
          print("오더 디테일 불러오기 실패");
        }
      } else {
        print("오더 디테일 불러오기 실패2");
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String deliveryState = "";
    String payment = "";
    if (order.state != 4) {
      deliveryState = "배달이 진행 중입니다.";
    } else {
      deliveryState = "배달이 완료되었습니다.";
    }
    if (order.payment == 0) {
      payment = "선결제";
    } else if (order.payment == 1) {
      payment = "카드결제";
    } else {
      payment = "현금결제";
    }

    return GestureDetector(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            backgroundColor: Color(0xff4B60F6),
            title: Text(
              "주문내역",
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        deliveryState,
                        style: TextStyle(fontSize: 30, color: Colors.red),
                      ),
                      SizedBox(height: 15),
                      Text("주문일시 : ${order?.orderTime}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("주문번호 : ${order?.orderId}"),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(order!.orderInfo),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('배달정보', style: TextStyle(fontSize: 25)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            order!=null?
                            Text(order.deliveryLocation):Text(""),
                            SizedBox(height: 5),
                            order!=null?
                            Text(order!.customerNum.substring(0, 3) +
                                '-' +
                                order!.customerNum.substring(3, 7) +
                                '-' +
                                order!.customerNum.substring(7)):Text("010-1234-5678"),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('요청사항', style: TextStyle(fontSize: 25)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              order!=null?  (order.deliveryRequest!=""?  Text(order!.deliveryRequest):
                                  Text("없음")) : Text("없음")

                             ,
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('결제수단', style: TextStyle(fontSize: 25)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(payment),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('결제금액', style: TextStyle(fontSize: 25)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(order!.orderValue.toString() + '원'),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}