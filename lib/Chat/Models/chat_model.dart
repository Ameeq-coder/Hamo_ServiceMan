class Chat {
  final String id;
  final String lastMessage;
  final bool onlineStatus;
  final DateTime createdAt;
  final UserModel user;
  final ServicemanModel serviceman;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.onlineStatus,
    required this.createdAt,
    required this.user,
    required this.serviceman,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      onlineStatus: json['onlineStatus'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']),
      serviceman: ServicemanModel.fromJson(json['serviceman']),
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['details']?['name'] ?? '',
      phone: json['details']?['phone'] ?? '',
      imageUrl: json['details']?['imageUrl'] ?? '',
    );
  }
}

class ServicemanModel {
  final String id;
  final String email;
  final String name;
  final String serviceType;
  final String serviceHead;
  final String category;
  final String location;
  final String imageUrl;

  ServicemanModel({
    required this.id,
    required this.email,
    required this.name,
    required this.serviceType,
    required this.serviceHead,
    required this.category,
    required this.location,
    required this.imageUrl,
  });

  factory ServicemanModel.fromJson(Map<String, dynamic> json) {
    return ServicemanModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['detail']?['name'] ?? '',
      serviceType: json['serviceType'] ?? '',
      serviceHead: json['detail']?['serviceHead'] ?? '',
      category: json['detail']?['category'] ?? '',
      location: json['detail']?['location'] ?? '',
      imageUrl: json['detail']?['imageUrl'] ?? '',
    );
  }
}
