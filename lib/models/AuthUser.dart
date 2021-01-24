import 'dart:convert';

UserAuth userFromJson(String str) => UserAuth.fromJson(json.decode(str));

String userToJson(UserAuth data) => json.encode(data.toJson());

class UserAuth {
  String email;

  String password;

  String token;

  String expiryDate;

  String userId;

  UserAuth(
      {this.email, this.password, this.token, this.expiryDate, this.userId});

  factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
        email: json['email'],
        password: json['password'],
        token: json['token'],
        expiryDate: json['expiryDate'],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "token": token,
        "expiryDate": expiryDate,
        "userId": userId,
      };
}
