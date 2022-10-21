

class NotesModel{

  final int? id ;
  final String? userid;
  final String? title ;
  //final String? age :
  final String? description ;
  //final String? email ;

  NotesModel({this.id, required this.userid,required this.title, required this.description});

  NotesModel.fromMap(Map<String, dynamic> res):
        id = res['id'],
        userid = res['userid'],
      title = res['title'],
        description = res['description'];

  Map<String, Object?> toMap(){
    return {
      'id' : id,
      'userid' : userid,
      'title' : title,
      'description' : description,

    };
  }

}