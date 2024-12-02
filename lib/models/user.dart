class User {
  final int userId;
  final String full_name;
  final String username;
  final String email;
  final String phone;
  final String gender;
  final String role;
  final String otp;

  User({required this.userId, required this.full_name, required this.username, required this.email,
    required this.phone, required this.gender, required this.role, required this.otp});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json['id'] ?? '',
      full_name: json['full_name'] ?? '',
      username: json['username']  ?? '',
      email: json['email']  ?? '',
      phone: json['phone']  ?? '',
      gender: json['gender']  ?? '',
      role: json['role']  ?? '',
      otp: json['otp']  ?? '',
    );
  }
}