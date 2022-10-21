import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite/screens/bd_handler.dart';
import 'package:sqlite/screens/homePage.dart';
import 'package:sqlite/screens/notes.dart';
import 'package:sqlite/utils/string.dart';

class dataAdd extends StatefulWidget {
  const dataAdd({Key? key}) : super(key: key);

  @override
  State<dataAdd> createState() => _dataAddState();
}

class _dataAddState extends State<dataAdd> {

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDiscription = TextEditingController();
  
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  loadData()async{
    notesList = dbHelper!.getNotesList();
  }

  String email="";
  //String lastName="";

  Future getdata() async{

    final prefs = await SharedPreferences.getInstance();
    var mail = prefs.getString(Strings.TagOfEmail);
    //var lastName1 = await prefs.getString(Strings.TagOfLastName);


        email = mail??"";
        print(email);

  }

  @override
  void initState() {
    getdata();
    dbHelper = DBHelper();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.0,),
          _commonTextField("Title", controllerTitle),
          SizedBox(height: 20.0,),
          _commonTextField("Discription", controllerDiscription),
          SizedBox(height: 30.0,),
          ElevatedButton(
              onPressed: (){
                dbHelper!.insert(NotesModel(title: controllerTitle.text,userid: email, description: controllerDiscription.text)).then((value) { print('data added');
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => homePage()), (route) => false);
                }).onError((error, stackTrace){ print(error.toString());});
                //Navigator.pop(context);
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}

Widget _commonTextField(String text, TextEditingController controller){
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: text,
    ),
  );
}