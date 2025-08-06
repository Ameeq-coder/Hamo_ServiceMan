class ServiceDetailModel {
  final String servicemanId;
  final String name;
  final String serviceHead;
  final String category;
  final String location;
  final int price;
  final String about;
  final String imagePath; // Local path to image

  ServiceDetailModel({
    required this.servicemanId,
    required this.name,
    required this.serviceHead,
    required this.category,
    required this.location,
    required this.price,
    required this.about,
    required this.imagePath,
  });
}
