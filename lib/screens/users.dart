

class UserModel{

  final int? id;
  final String? fName;
  final String? lName;
  final String? mob;
  final String? eMail;
  final String? city;
  final String? password;

  UserModel({this.id,required this.fName,required this.lName,required this.mob,required this.eMail,required this.city,required this.password});

  UserModel.fromMap(Map<String, dynamic> user):
        id = user['id'],
        fName= user['fName'],
        lName = user['lName'],
        mob = user['mob'],
        eMail = user['eMail'],
        city = user['city'],
        password = user['password'];

  Map<String, Object?> toMap(){
    return{
      'id':id,
      'fName':fName,
      'lName':lName,
      'mob':mob,
      'eMail':eMail,
      'city':city,
      'password':password,
    };
  }

}