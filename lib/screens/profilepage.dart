import 'package:flutter/material.dart';
import 'package:sqlite/screens/bd_handler.dart';
import 'package:sqlite/screens/db_handler.dart';
import 'package:sqlite/screens/homePage.dart';
import 'package:sqlite/screens/notes.dart';
import 'package:sqlite/screens/users.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key, required this.person}) : super(key: key);
  final UserModel person;

  @override
  State<profilePage> createState() => _profilePageState();
}





class _profilePageState extends State<profilePage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50.0,),
          _commonProfile(text: "${widget.person.fName}"),
          SizedBox(height: 20.0,),
          _commonProfile(text: "${widget.person.lName}"),
          SizedBox(height: 20.0,),
          _commonProfile(text: "${widget.person.eMail}"),
          SizedBox(height: 20.0,),
          _commonProfile(text: "${widget.person.mob}"),
          SizedBox(height: 20.0,),
          _commonProfile(text: "${widget.person.city}"),
        ],
      ),
    );
  }
}

_commonProfile({required String text}){
  return Padding(
    padding: EdgeInsets.only(left: 20.0),
    child: Container(
      height: 50.0,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey,
      ),
      child: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Center(child: Text(text,style: TextStyle(fontSize: 20.0,color: Colors.white),))),
    ),
  );
}