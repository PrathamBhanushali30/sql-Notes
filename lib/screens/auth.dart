import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite/screens/homePage.dart';
import 'package:sqlite/screens/loginPage.dart';

import '../utils/string.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  var auth=false;
  Future<bool> getdata() async{
    final prefs = await SharedPreferences.getInstance();
    var gmail1=  prefs.getString(Strings.TagOfEmail);
    if(
    gmail1=="" || gmail1 == null
    ){
     return false;
    }else{
      return true;
    }
  }

 Future finaldata()async{
    auth = await getdata();
    setState(() {

    });
  }
  @override
  void initState() {
    getdata();
    finaldata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(
    auth
    ){
      return homePage();
    }else{
      return loginPage();
    }
  }
}
