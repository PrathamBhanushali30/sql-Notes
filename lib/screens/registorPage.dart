import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite/screens/db_handler.dart';
//import 'package:sqlite/screens/homePage.dart';
import 'package:sqlite/screens/users.dart';
import 'package:sqlite/utils/string.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:email_validator/email_validator.dart';
import 'loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  var citylist = ['Select Your City','Ahmedabad', 'Surat', "Amreli", "Bhavnagar"];
  var currentValue = 'Select Your City';
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerMob = TextEditingController();
  TextEditingController controllerMail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

  bool ValidateEmail() {
    var isValid = EmailValidator.validate(controllerMail.text);
    return isValid;
  }

  bool checkedValue = false;

  final snackBar1 = SnackBar(content: Text(Strings.msg));

  Future storeCredentials({required String firstName, required String lastname, required String mobile, required String email, required String password}) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.TagOfFirstName, firstName);
    await prefs.setString(Strings.TagOfLastName, lastname);
    await prefs.setString(Strings.TagOfMob, mobile);
    await prefs.setString(Strings.TagOfEmail, email);
    await prefs.setString(Strings.TagOfPassword, password);
  }

  UserDBHelper? dbHelper;
  late Future<List<UserModel>> userList;

  @override
  void initState() {
    dbHelper = UserDBHelper();
    loadData();
    super.initState();
  }

  loadData() async{
    userList = dbHelper!.getUsersList();
  }

  // Future getdata() async{
  //   final prefs = await SharedPreferences.getInstance();
  //  var name= await prefs.getString(Strings.TagOfFirstName);
  //   var surName= await prefs.getString(Strings.TagOfLastName);
  //   var mob= await prefs.getString(Strings.TagOfMob);
  //   var gmail= await prefs.getString(Strings.TagOfEmail);
  //   var pass= await prefs.getString(Strings.TagOfPassword);
  //   print(name);
  //   print(surName);
  //   print(mob);
  //   print(gmail);
  //   print(pass);
  // }

  Future printdata()async{
    var finaldata=await dbHelper!.getUsersList();
    finaldata.forEach((element) {
      //print(element.fName);
      //print(element.id);
      //print(element.password);
    });
  }

  Future<bool> isExist(String email)async{
    var isexist=false;
    var data=await dbHelper!.getUsersList();
    data.forEach((element) {
      if(element.eMail==email){
        isexist=true;
      }else{
        isexist=false;
      }
    });
    return isexist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: Appclipper(),
                child: Container(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.lightBlueAccent,
                            Colors.blueAccent,
                            Colors.blue,
                          ])),
                  child: Center(child: Text("Register",style: TextStyle(fontSize: 50.0,color: Colors.white,fontWeight: FontWeight.bold),),),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: [
                    _commonView(
                        title: Strings.fName,
                        icon: Icons.person,
                        controller: controllerFirstName,
                        dots: false,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _commonView(
                        title: Strings.lName,
                        icon: Icons.person,
                        controller: controllerLastName,
                        dots: false),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Stack(
                  children: [
                    Container(height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          offset: Offset(0.0, 5.0),
                          blurRadius: .6,
                          spreadRadius: .5,
                        )],
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),
                    IntlPhoneField(
                      controller: controllerMob,
                      decoration: InputDecoration(
                        hintText: Strings.mob,
                        //labelText: string.mob,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      initialCountryCode: 'IN',
                      // onChanged: (phone) {
                      //   //print(phone.completeNumber);
                      // },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: _commonView(
                      title: Strings.mail,
                      icon: Icons.email,
                      controller: controllerMail,
                      dots: false)),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        offset: Offset(0.0, 5.0),
                        blurRadius: .6,
                        spreadRadius: .5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                    child: DropdownButton(
                      underline: Container(),
                        isExpanded: true,
                        value: currentValue,
                        items: citylist.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            currentValue = value!;
                          });
                        }),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: _commonView(
                      title: Strings.pass,
                      icon: Icons.vpn_key,
                      controller: controllerPassword,
                      dots: true)),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: _commonView(
                      title: Strings.confirm_pass,
                      icon: Icons.vpn_key,
                      controller: controllerConfirmPassword,
                      dots: true)),
              SizedBox(height: 10.0),
              CheckboxListTile(
                title: Text('Agree all terms and conditions*',style: TextStyle(fontSize: 20.0,color: Colors.grey),),
                  value: checkedValue,
                  onChanged: (bool? value){
                setState(() {
                  checkedValue = value!;
                });
              }),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                child: Container(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async{
                        var email = ValidateEmail();
                        /*  if(controllerFirstName.text != ""){
                          firstName = true;
                        }
                        if(controllerLastName.text != ""){
                          lastName = true;
                        }
                        if(controllerMail.text != ""){
                          email = true;
                        }
                        if(controllerPassword.text != ""){
                          password = true;
                        }
                        if(controllerConfirmPassword.text == controllerPassword.text){
                          confirmPassword = true;
                        }*/
                        if (controllerFirstName.text.trim() == '') {
                          Fluttertoast.showToast(msg: Strings.msg);
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                        } else if (controllerLastName.text.trim() == '') {
                          Fluttertoast.showToast(msg: Strings.msg);
                        } else if (controllerMob.text.trim() == '') {
                          Fluttertoast.showToast(msg: Strings.msg);
                        } else if (email == false) {
                          Fluttertoast.showToast(msg: Strings.msg_mail);
                        } else if (controllerPassword.text == '') {
                          Fluttertoast.showToast(msg: Strings.msg);
                        }
                        else if (currentValue == 'Select Your City') {
                          Fluttertoast.showToast(msg: Strings.city);
                        }
                        else if (controllerPassword.text.length < 8) {
                          Fluttertoast.showToast(msg: Strings.msg_pass_length);
                        } else if (controllerConfirmPassword.text !=
                            controllerPassword.text) {
                          Fluttertoast.showToast(msg: Strings.msg_pass);
                        }else if (checkedValue == false) {
                          Fluttertoast.showToast(msg: Strings.msg_check);
                        }
                        else if (await isExist(controllerMail.text)) {
                          Fluttertoast.showToast(msg: Strings.msg_mail_exist);
                        }
                        else {
                          storeCredentials(firstName: controllerFirstName.text,
                              lastname: controllerLastName.text,
                              mobile: controllerMob.text,
                              email: controllerMail.text,
                              password: controllerPassword.text,
                          );
                          dbHelper!.insert(UserModel(
                              fName: controllerFirstName.text,
                              lName: controllerLastName.text,
                              mob: controllerMob.text,
                              eMail: controllerMail.text,
                              city: currentValue,
                              password: controllerPassword.text)).then((value){
                               // print('data added');
                                printdata();
                                Timer(
                                    Duration(seconds: 2),(){ Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => loginPage()), (route) => false);}
                                );
                              });
                          //getdata();
                        }

                        /*if(firstName == false && lastName == false && email == false && password == false && confirmPassword == false){
                           Fluttertoast.showToast(msg: string.msg);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                        }*/
                      },
                      child: Center(
                        child: Text(
                          Strings.submit,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonView({required String title,
      required IconData icon,
      required TextEditingController controller,
      required dots}) {
    return Container(
      height: 50.0,
      width: 370.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              offset: Offset(0.0, 5.0),
              blurRadius: .6,
              spreadRadius: .5,
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30.0,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: controller,
                obscureText: dots,
                decoration: InputDecoration(
                    hintText: title /*'First Name'*/,
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class Appclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    //throw UnimplementedError();
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width, size.height * 0.8299400);
    path0.quadraticBezierTo(size.width * 0.8594500, size.height * 0.9924800,
        size.width * 0.7396750, size.height * 0.9966600);
    path0.cubicTo(
        size.width * 0.6150125,
        size.height * 1.0288800,
        size.width * 0.6024125,
        size.height * 0.9320600,
        size.width * 0.2785250,
        size.height * 0.8455400);
    path0.quadraticBezierTo(
        size.width * 0.1190500, size.height * 0.8579000, 0, size.height);
    path0.lineTo(0, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
