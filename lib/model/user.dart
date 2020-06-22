import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';

class User {
  int id;
  String login;
  String password;
  String firstName;
  String clientSex;
  String lastName;
  String image;
  String telephon;
  String patronymic;
  String token;

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    patronymic = json['patronymic'];
    clientSex = json['clientSex'];
    image = json['image'];
    //image = Base64Decoder().convert(file64base);
  }

  /*Map<String, dynamic> toJson() => {
        'firstName': login,
        'email': email,
        'lastName': lastName,
        'patronymic': patronomic,
        'telephonNumber': telephon,
      };
*/

  User(
      {this.id,
      this.login,
      this.password,
      this.lastName,
      this.telephon,
      this.token,
      this.clientSex,
      this.firstName,
      this.patronymic});
}
