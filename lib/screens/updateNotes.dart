import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqlite/screens/bd_handler.dart';
import 'package:sqlite/screens/homePage.dart';
import 'package:sqlite/screens/notes.dart';

class dataupdate extends StatefulWidget {
  const dataupdate({Key? key, required this.notesModel}) : super(key: key);

  final NotesModel notesModel;

  @override
  State<dataupdate> createState() => _dataupdateState();
}

class _dataupdateState extends State<dataupdate> {

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDiscription = TextEditingController();

  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  loadData()async{
    notesList = dbHelper!.getNotesList();
  }

  void retrive(){
    controllerTitle.text=widget.notesModel.title??"";
    controllerDiscription.text=widget.notesModel.description??"";
  }

  @override
  void initState() {
    dbHelper = DBHelper();
    loadData();
    retrive();
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
                dbHelper!.update(NotesModel(id: widget.notesModel.id,userid: widget.notesModel.userid,title: controllerTitle.text, description: controllerDiscription.text)
                );
                // dbHelper!.insert(NotesModel(title: controllerTitle.text, description: controllerDiscription.text)).then((value) { print('data added');
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => homePage()), (route) => false);
                // }).onError((error, stackTrace){ print(error.toString());});
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