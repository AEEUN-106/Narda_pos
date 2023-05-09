import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:narda_pos/beforeCall_screen.dart';
import 'dart:convert';
import 'api/api.dart';
import 'model/store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
  }

  Widget _userIdWidget(){
    return SizedBox(
      width: 500,
      child: TextFormField(
        controller: _idController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '아이디',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value){
          if (value!.isEmpty) {// == null or isEmpty
            return '아이디를 입력해주세요.';
          }
          return null;
        },
      )

    );
  }

  @override
  Widget build(BuildContext context) {

    login() async{
      try{
        var response = await http.post(
            Uri.parse(API.login),
            body:{
              'storeId' : _idController.text.trim(), //오른쪽에 validate 확인할 id 입력
            }
        );
        if(response.statusCode == 200){
          var responseBody = jsonDecode(response.body);
          if(responseBody['success'] == true){
            print("로그인 성공");
            Store store = Store.fromJson(responseBody['storeData']);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BeforeScreen(storeId: _idController.text)),
            );

          }
          else{
            print("로그인 실패");
          }
        }
      }catch(e){print(e.toString());}
    }



    return Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userIdWidget(),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Colors.grey[350]),
                  ),

                  onPressed: () async {
                    login();
                  },
                  child: Text('로그인'))
            ],
          ),
        )


    );
  }
}


