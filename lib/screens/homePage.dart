import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite/screens/addNotes.dart';
import 'package:sqlite/screens/bd_handler.dart';
import 'package:sqlite/screens/db_handler.dart';
import 'package:sqlite/screens/loginPage.dart';
import 'package:sqlite/screens/notes.dart';
import 'package:sqlite/screens/profilepage.dart';
import 'package:sqlite/screens/updateNotes.dart';
import 'package:sqlite/screens/users.dart';
import '../utils/string.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  UserModel? person;
  DBHelper dbHelper = DBHelper();
  UserDBHelper userDBHelper = UserDBHelper();
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {

    loadData();
    super.initState();
    getData();
    getboolsteps();
  }



  loadData()async{
   notesList= dbHelper.getNotesList();

  }

  Future getData() async{
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString(Strings.TagOfEmail);
    //print('check');
    List<UserModel>? userlist = await userDBHelper.getUsersList();
    //print(email);
    for(var user in userlist){
      if(user.eMail == email){
        person = user;
        setState(() {

        });
      }
    }
  }

  List<bool> finalstep = [];

  Future getboolsteps() async {
    List<NotesModel> list = await dbHelper.getNotesList();
    List<bool> steplist = List<bool>.generate(list.length, (index) => false);
    finalstep = steplist;
  }


  Future storeCredentials({ required String email}) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.TagOfEmail, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blue,
                  Colors.blueAccent,
                  Colors.grey
                ]
              )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: Icon(Icons.menu,color: Colors.white,),
                        iconSize: 30.0,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },);
                    }
                  ),
                  SizedBox(width: 100.0,),
                  Text(
                  AppLocalizations.of(context)!.notes,style: TextStyle(color: Colors.white,fontSize: 30.0,fontWeight: FontWeight.bold),)
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: notesList,
                    builder: (context,AsyncSnapshot<List<NotesModel>> snapshot){

                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          reverse: false,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                // dbHelper!.update(
                                //   NotesModel(id: snapshot.data![index].id,
                                //       title: 'note2', description: 'heyaa')
                                // );
                                // setState(() {
                                //   notesList = dbHelper!.getNotesList();
                                // });
                                Navigator.push(context, MaterialPageRoute(builder: (context) => dataupdate(notesModel: NotesModel(id: snapshot.data![index].id,userid: snapshot.data![index].userid,title: snapshot.data![index].title, description: snapshot.data![index].description),)));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Dismissible(
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          color: Colors.red,
                                          child: Icon(Icons.delete_forever),
                                        ),
                                        onDismissed: (DismissDirection direction){
                                          setState(() {
                                            dbHelper.delete(snapshot.data![index].id!);
                                            notesList = dbHelper.getNotesList();
                                            snapshot.data!.remove(snapshot.data![index]);
                                            finalstep.removeAt(index);
                                          });
                                        },
                                        key: ValueKey<int>(snapshot.data![index].id!),
                                        child: ExpansionPanelList(
                                          children: [
                                            ExpansionPanel(
                                            isExpanded:finalstep[index],
                                              headerBuilder: (context, isExpanded){
                                              return Card(
                                                child: ListTile(
                                                  title: Text(snapshot.data![index].title.toString()),
                                                  // subtitle: Text(snapshot.data![index].description.toString()),
                                                ),
                                              );
                                            }, body: ListTile(
                                              subtitle: Text(snapshot.data![index].description.toString()),
                                            ),
                                            ),
                                          ],
                                          expansionCallback: (panelIndex, isExpanded){
                                            setState((){
                                              finalstep[index] = !isExpanded;
                                          });
                                        }
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }else{
                      return CircularProgressIndicator();
                    }
                    }),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.blue,
        onPressed: (){
          // dbHelper!.insert(NotesModel(title: "second list", description: "hi am flutter developer")).then((value) { print('data added');
          // setState(() {
          //   notesList = dbHelper!.getNotesList();
          // });
          // }).onError((error, stackTrace){ print(error.toString());});
          Navigator.push(context, MaterialPageRoute(builder: (context) => dataAdd()));
        },
        child:const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width*.50,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.0,),
                Padding(padding: EdgeInsets.only(left: 20.0),child: Text("Hello ${person?.fName} ${person?.lName}",style: TextStyle(fontSize: 30.0, color: Colors.black,fontWeight: FontWeight.bold),)),
                SizedBox(height: 30.0,),
               InkWell(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => profilePage(person: person??UserModel(fName: "", lName: "", mob: "", eMail: "", city: "", password: ""),)));
                 },
                   child: _commonDrawer(
                       text: AppLocalizations.of(context)!.profile,
                       icon: Icons.person)),
               SizedBox(height: 20.0,),
               InkWell(
                 onTap: (){
                   storeCredentials(email: "");
                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => loginPage()), (route) => false);
                 },
                   child: _commonDrawer(text: AppLocalizations.of(context)!.logout, icon: Icons.logout)),
                SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: (){
                    dbHelper.deleteForever();
                    userDBHelper.delete(person!.id ?? 1);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => loginPage()), (route) => false);
                  },
                    child: _commonDrawer(text: AppLocalizations.of(context)!.delete, icon: Icons.delete)),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _commonDrawer({required String text, required IconData icon}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon),
      SizedBox(width: 20.0,),
      Text(text,style: TextStyle(fontSize: 20.0),),
    ],
  );
}