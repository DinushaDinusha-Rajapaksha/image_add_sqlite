class photo {
  late int? id;
  late String? photoName;

  photo(int i, String imgString, { required this.id ,  required this.photoName});

  Map <String, dynamic> toMap(){

    var map = <String, dynamic>{
      'id': id,
      'photoName': photoName,
    };
    return map;
  }

   photo.fromMap(Map<String, dynamic>map){
    id = map['id'];
    photoName = map ['photoName'];
  }
}