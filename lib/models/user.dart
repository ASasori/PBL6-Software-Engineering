class User {
  String? full_name;
  String? username;
  String? email;
  String? phone;
  String? gender;
  String? role;
  String? otp;

  User({
    this.full_name,
    this.username,
    this.email,
    this.phone,
    this.gender,
    this.role,
    this.otp
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      full_name: json['full_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
      otp: json['otp'] ?? '',
    );
  }
}
