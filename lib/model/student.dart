class StudentModel {
  String? key;
  StudentData? currentData;
  StudentModel({this.currentData, this.key});
}

class StudentData {
  String? name;
  String? studentID;
  String? email;
  String? phoneNumber;
  String? age;
  String? profilePictureUri;
  StudentData(
      {this.name,
      this.studentID,
      this.email,
      this.phoneNumber,
      this.age,
      this.profilePictureUri});
  StudentData.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    studentID = json['studentID'];
    email = json['email'];
    phoneNumber = json['phone'];
    age = json['age'];
    profilePictureUri = json['profilePictureUri'];
  }
}
