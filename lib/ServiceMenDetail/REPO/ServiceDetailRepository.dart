import 'dart:convert';
import 'dart:io';
import 'package:hamo_service_man/ServiceMenDetail/Models/ServiceDetailModel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ServiceDetailRepository {
  final String baseUrl = 'https://hamo-backend.vercel.app/api/v1/servicedetail/createdetail';

  Future<Map<String, dynamic>> createService(ServiceDetailModel model) async {
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.fields['servicemanId'] = model.servicemanId;
    request.fields['name'] = model.name;
    request.fields['serviceHead'] = model.serviceHead;
    request.fields['category'] = model.category;
    request.fields['location'] = model.location;
    request.fields['price'] = model.price.toString();
    request.fields['about'] = model.about;

    final mimeTypeData = lookupMimeType(model.imagePath)!.split('/');

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        model.imagePath,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create service: ${response.body}');
    }
  }
}
