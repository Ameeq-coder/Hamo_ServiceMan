class AllBooking {
  final String id;
  final String serviceType;
  final Map<String, dynamic> serviceOptions;
  final String location;
  final bool paid;
  final String status;
  final DateTime bookingDateTime;
  final String startTime;
  final String endTime;
  final int price;
  final String userName;
  final String userImage;

  AllBooking({
    required this.id,
    required this.serviceType,
    required this.serviceOptions,
    required this.location,
    required this.paid,
    required this.status,
    required this.bookingDateTime,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.userName,
    required this.userImage,
  });

  factory AllBooking.fromJson(Map<String, dynamic> json) {
    return AllBooking(
      id: json['id'],
      serviceType: json['serviceType'],
      serviceOptions: Map<String, dynamic>.from(json['serviceOptions']),
      location: json['location'],
      paid: json['paid'],
      status: json['status'],
      bookingDateTime: DateTime.parse(json['bookingDateTime']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      price: json['price'],
      userName: json['user']['details']['name'],
      userImage: json['user']['details']['imageUrl'],
    );
  }
}
