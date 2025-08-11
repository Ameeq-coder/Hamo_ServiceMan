class Invite {
  final String id;
  final String servicemanId;
  final String userId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invite({
    required this.id,
    required this.servicemanId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['id'],
      servicemanId: json['servicemanId'],
      userId: json['userId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class InviteResponse {
  final String message;
  final Invite invite;

  InviteResponse({
    required this.message,
    required this.invite,
  });

  factory InviteResponse.fromJson(Map<String, dynamic> json) {
    return InviteResponse(
      message: json['message'],
      invite: Invite.fromJson(json['invite']),
    );
  }
}
