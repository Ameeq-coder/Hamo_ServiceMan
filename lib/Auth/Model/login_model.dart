class Serviceman {
  final String id;
  final String email;
  final String serviceType;

  Serviceman({required this.id, required this.email, required this.serviceType});

  factory Serviceman.fromJson(Map<String, dynamic> json) {
    return Serviceman(
      id: json['id'],
      email: json['email'],
      serviceType: json['serviceType'],
    );
  }
}

class LoginResponse {
  final String message;
  final String token;
  final Serviceman serviceman;

  LoginResponse({required this.message, required this.token, required this.serviceman});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      serviceman: Serviceman.fromJson(json['serviceman']),
    );
  }
}
