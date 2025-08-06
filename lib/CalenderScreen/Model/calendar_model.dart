class Booking {
  final String id;
  final String servicemanId;
  final String serviceManName;
  final String userId;
  final String userName;
  final String serviceType;
  final String description;
  final String location;
  final bool paid;
  final String status;
  final DateTime bookingDateTime;
  final String startTime;
  final String endTime;
  final int price;
  final String userImage;
  final String userAddress;

  Booking({
    required this.id,
    required this.servicemanId,
    required this.serviceManName,
    required this.userId,
    required this.userName,
    required this.serviceType,
    required this.description,
    required this.location,
    required this.paid,
    required this.status,
    required this.bookingDateTime,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.userImage,
    required this.userAddress,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      servicemanId: json['servicemanId'],
      serviceManName: json['serviceManName'],
      userId: json['userId'],
      userName: json['userName'],
      serviceType: json['serviceType'],
      description: json['serviceOptions']['description'] ?? '',
      location: json['location'] ?? '',
      paid: json['paid'] ?? false,
      status: json['status'] ?? '',
      bookingDateTime: DateTime.parse(json['bookingDateTime']),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      price: json['price'] ?? 0,
      userImage: json['user']['details']['imageUrl'] ?? '',
      userAddress: json['user']['details']['address'] ?? '',
    );
  }
}
