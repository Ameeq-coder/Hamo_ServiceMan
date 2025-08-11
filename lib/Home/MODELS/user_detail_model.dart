class User {
  final String id;
  final String email;
  final String userType;

  User({required this.id, required this.email, required this.userType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      userType: json['userType'],
    );
  }
}

class UserDetail {
  final String id;
  final String userId;
  final String name;
  final String dob;
  final String phone;
  final String address;
  final String imageUrl;
  final User user;

  UserDetail({
    required this.id,
    required this.userId,
    required this.name,
    required this.dob,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.user,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      dob: json['dob'],
      phone: json['phone'],
      address: json['address'],
      imageUrl: json['imageUrl'],
      user: User.fromJson(json['user']),
    );
  }
}
