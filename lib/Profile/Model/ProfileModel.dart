class ProfileModel {
  final String id;
  final String servicemanId;
  final String name;
  final String serviceHead;
  final String category;
  final String location;
  final int price;
  final String about;
  final String imageUrl;

  ProfileModel({
    required this.id,
    required this.servicemanId,
    required this.name,
    required this.serviceHead,
    required this.category,
    required this.location,
    required this.price,
    required this.about,
    required this.imageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final detail = json['detail'];
    return ProfileModel(
      id: detail['id'],
      servicemanId: detail['servicemanId'],
      name: detail['name'],
      serviceHead: detail['serviceHead'],
      category: detail['category'],
      location: detail['location'],
      price: detail['price'],
      about: detail['about'],
      imageUrl: detail['imageUrl'],
    );
  }
}
