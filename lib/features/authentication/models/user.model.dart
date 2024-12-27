// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
    final String email;
    final String password;
    final String phone;
    final String name;
    final String title;
    final String gender;
    final String dob;
    final int userId;

    Users({
        required this.email,
        required this.password,
        required this.phone,
        required this.name,
        required this.dob,
        required this.gender,
        required this.title,
        required this.userId
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        name: json["name"], 
        dob: json['dob'], 
        gender: json['gender'], 
        title: json['title'], 
        userId: json['id'],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "phone": phone,
        "name":name,
        "title":title,
        "gender":gender,
        "dob":dob,
        "id":userId
    };
      factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      name: map['name'],
      email: map['email'],
      password: map['password'], 
      phone: map['phone'], 
      dob: map['dob'], 
      gender: map['gender'], 
      title: map['title'],
      userId: map['id'],
    );
  }

  Map<String, Object?> toMap() {
    return {
      'userId': userId,
      'name': name,
      'dob': dob,
      'title':title,
      'gender':gender,
      'email':email,
      'phone':phone,
      'password':password
    };
  }
}
