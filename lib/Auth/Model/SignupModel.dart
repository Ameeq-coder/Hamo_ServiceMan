class SignupModel {
  final String id;
  final String email;
  final String serviceType;

  SignupModel({
    required this.id,
    required this.email,
    required this.serviceType,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      id: json['id'],
      email: json['email'],
      serviceType: json['serviceType'],
    );
  }
}
