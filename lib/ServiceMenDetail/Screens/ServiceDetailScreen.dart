import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

import '../../CalenderScreen/BLOC/calender_bloc.dart';
import '../../CalenderScreen/CalenderScreen.dart';
import '../../CalenderScreen/Repositry/calendar_repository.dart';
import '../BLOC/service_detail_bloc.dart';
import '../BLOC/service_detail_event.dart';
import '../BLOC/service_detail_state.dart';
import '../Models/ServiceDetailModel.dart';
import '../REPO/ServiceDetailRepository.dart';


class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceHeadController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      decoration: _inputDecoration(hint: hint, icon: icon),
    );
  }

  void _submitServiceDetails() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      final box = Hive.box('servicebox');
      final servicemanId = box.get('servicemanid'); // 🔑 Get userId from Hive
      final category = box.get('servicetype');
      final model = ServiceDetailModel(
        servicemanId: servicemanId,
        name: _nameController.text.trim(),
        serviceHead: _serviceHeadController.text.trim(),
        category: category,
        location: _locationController.text.trim(),
        price: int.tryParse(_priceController.text.trim()) ?? 0,
        about: _aboutController.text.trim(),
        imagePath: _selectedImage!.path, // ✅ Fix applied here
      );

      BlocProvider.of<ServiceDetailsBloc>(context).add(
        SubmitServiceDetailEvent(model),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Create Service Detail',
            style: TextStyle(color: Colors.black)),
      ),
      body: BlocConsumer<ServiceDetailsBloc, ServiceDetailState>(
        listener: (context, state) {
          if (state is ServiceDetailSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Service created successfully!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => CalendarBloc(CalendarRepository()),
                  child:  CalendarScreen(),
                ),
              ),
            );


            Navigator.pop(context);
          } else if (state is ServiceDetailFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFFF2F2F2),
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              child: _selectedImage == null
                                  ? const Icon(Icons.image,
                                  size: 50, color: Colors.grey)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: const Icon(Icons.edit,
                                    color: Colors.purple, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                          controller: _nameController, hint: 'Name'),
                      const SizedBox(height: 15),
                      _buildTextField(
                          controller: _serviceHeadController,
                          hint: 'Service Head'),
                      const SizedBox(height: 15),
                      // _buildTextField(
                      //     controller: _categoryController,
                      //     hint: 'Category'),
                      // const SizedBox(height: 15),
                      _buildTextField(
                          controller: _locationController,
                          hint: 'Location'),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _priceController,
                        hint: 'Price',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _aboutController,
                        hint: 'About Service',
                        icon: Icons.description,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is ServiceDetailLoading
                              ? null
                              : _submitServiceDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: state is ServiceDetailLoading
                              ? const CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                              : const Text(
                            'Continue',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
