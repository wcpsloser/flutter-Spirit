import 'dart:convert';

class User {
  final int? id;
  final String fullname;
  final String username;
  final String password;

  User({
    this.id,
    required this.fullname,
    required this.username,
    required this.password,
  });

  User copyWith({
    int? id,
    String? fullname,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      fullname: map['fullname'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
