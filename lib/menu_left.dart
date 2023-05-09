import 'package:flutter/material.dart';
import 'beforeCall_screen.dart';
import 'complete_screen.dart';
import 'delivery_screen.dart';

class Menu{
  int num = 4;
  late Widget widget;

  void func ()
  {
    print("fdfs");
  }
Widget _widget()
{
  return widget;
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
                    return DeliveryScreen(storeId:storeId);
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
}

