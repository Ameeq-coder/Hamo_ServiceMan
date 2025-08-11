class BookingCount {
  final String servicemanId;
  final int upcoming;
  final int completed;
  final int cancelled;
  final int total;

  BookingCount({
    required this.servicemanId,
    required this.upcoming,
    required this.completed,
    required this.cancelled,
    required this.total,
  });

  factory BookingCount.fromJson(Map<String, dynamic> json) {
    return BookingCount(
      servicemanId: json['servicemanId'],
      upcoming: json['counts']['upcoming'],
      completed: json['counts']['completed'],
      cancelled: json['counts']['cancelled'],
      total: json['counts']['total'],
    );
  }
}
