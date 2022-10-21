import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite/screens/registorPage.dart';
import '../utils/string.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sqlite/screens/db_handler.dart';
import 'homePage.dart';
import 'package:sqlite/screens/users.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginState();
}

class _loginState extends State<loginPage> {

  // String? name;
  // String? surname;
  // String? mob;
  String? gmail;
  String? pass;
  UserDBHelper? dbHelper;
  late Future<List<UserModel>> userList;

  bool loaded=false;

  TextEditingController controllerMail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  bool ValidateEmail() {
    var isValid = EmailValidator.validate(controllerMail.text);
    return isValid;
  }


  Future getdata() async{
    final prefs = await SharedPreferences.getInstance();
    // var name1= await prefs.getString(Strings.TagOfFirstName);
    // var surName1= await prefs.getString(Strings.TagOfLastName);
    // var mob1= await prefs.getString(Strings.TagOfMob);
    var gmail1=  prefs.getString(Strings.TagOfEmail);
    var pass1= prefs.getString(Strings.TagOfPassword);

    // name=name1!;
    // surname=surName1!;
    // mob=mob1!;
    gmail=gmail1;
    pass=pass1;
    setState(() {
      loaded=true;
    });
  }

  Future<bool> isExist(String email, String password)async{
    var isExist=false;
    var data=await dbHelper!.getUsersList();
    data.forEach((element) {
     // print(element.eMail);
      if(element.eMail==email && element.password==password){
        isExist=true;
      }
    });
    return isExist;
  }

  @override
  void initState() {
    dbHelper = UserDBHelper();
    loadData();
    getdata();
    super.initState();
  }

  loadData() async{
    userList = dbHelper!.getUsersList();

  }

  Future storeCredentials({ required String email}) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.TagOfEmail, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded?SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.grey,
                  ]
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 200.0,),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Container(
                  height: 400.0,
                  width: MediaQuery.of(context).size.width-40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white70,
                        Colors.white54,
                        Colors.white24,
                      ]
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: .5,
                        blurRadius: .3,
                      ),
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0,),
                      Center(child: Text("Login",style: TextStyle(color: Colors.black,fontSize: 30.0,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 30.0,),
                      _commonView(text: "Email", icon: Icons.person,dots: false,controller: controllerMail),
                      SizedBox(height: 20.0,),
                      _commonView(text: "Password", icon: Icons.vpn_key,dots: true,controller: controllerPassword),
                      SizedBox(height: 60.0,),
                      SizedBox(
                        height: 40.0,
                        width: 100.0,
                        child: ElevatedButton(
                          onPressed: ()async{
                            //var email = ValidateEmail();
                            /*if(email == false){
                              Fluttertoast.showToast(msg: Strings.msg_mail);
                            }*/
                            // if(controllerMail.text != gmail){
                            //   Fluttertoast.showToast(msg: Strings.msg_mail);
                            // }
                            // if (controllerPassword.text == '') {
                            //   Fluttertoast.showToast(msg: Strings.msg);
                            // }
                            // else if (controllerPassword.text != pass) {
                            //   Fluttertoast.showToast(msg: Strings.msg_pass_check);
                            // }
                            if (!await isExist(controllerMail.text,controllerPassword.text)) {
                              Fluttertoast.showToast(msg: Strings.msg_log_match);
                            }
                            else{
                              storeCredentials(email: controllerMail.text);
                              Timer(
                                  Duration(seconds: 2),(){ Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => homePage()));}
                              );

                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          child: Text("Login"),),
                      ),
                      SizedBox(height: 20.0,),
                      InkWell(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                        },
                        child: Text("Register Now",style: TextStyle(color: Colors.blue,fontSize: 15.0,fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ):Container(),
    );
  }
}

Widget _commonView({required String text, required IconData icon, required dots,required TextEditingController controller}){
  return Padding(
    padding: EdgeInsets.only(left: 10.0,right: 10.0),
    child: TextFormField(
      controller: controller,
      obscureText: dots,
      decoration: InputDecoration(
        prefixIcon: Icon(icon,color: Colors.black,),
        hintText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black,),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black,)
        ),
      ),
    ),
  );
}