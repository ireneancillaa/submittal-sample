class UserModel {
  final int status;
  final String message;
  final String? email;
  final String? name;
  final String? apikey;
  final String? ldapid;

  UserModel({
    required this.status,
    required this.message,
    this.email,
    this.name,
    this.apikey,
    this.ldapid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      email: json['email'],
      name: json['name'],
      apikey: json['apikey'],
      ldapid: json['ldapid'],
    );
  }
}
