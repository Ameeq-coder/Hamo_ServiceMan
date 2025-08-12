// Models/messagemodel.dart
class MessageModel {
  final String id;
  final String chatListId;
  final String senderType;
  final String senderId;
  final String recevierid; // Note: keeping API spelling
  final String receviertype; // Note: keeping API spelling
  final String message;
  final String createdAt;
  final String updatedAt;

  MessageModel({
    required this.id,
    required this.chatListId,
    required this.senderType,
    required this.senderId,
    required this.recevierid,
    required this.receviertype,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      chatListId: json['chatListId'] ?? '',
      senderType: json['senderType'] ?? '',
      senderId: json['senderId'] ?? '',
      recevierid: json['recevierid'] ?? '',
      receviertype: json['receviertype'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatListId': chatListId,
      'senderType': senderType,
      'senderId': senderId,
      'recevierid': recevierid,
      'receviertype': receviertype,
      'message': message,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}