import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_service_man/Auth/Repositry/SignupRepositry.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import '../../ServiceMenDetail/BLOC/service_detail_bloc.dart';
import '../../ServiceMenDetail/REPO/ServiceDetailRepository.dart';
import '../../ServiceMenDetail/Screens/ServiceDetailScreen.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;

  String selectedServiceType = 'Cleaner';
  final List<String> serviceTypes = [
    'Cleaner',
    'Repairing',
    'Painting',
    'Laundry',
    'Appliance',
    'Plumbing',
    'Shifting',
    'Beauty',
    'Vehicle'
  ];
  final box = Hive.box('servicebox');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(signupRepository: SignupRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Arrow
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                ),

                SizedBox(height: 20),

                // Title
                Text(
                  "Create your\nAccount",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 32),

                // Email Field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: "Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Password Field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: "Password",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Dropdown for Service Type
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedServiceType,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.home_repair_service_outlined),
                    ),
                    items: serviceTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedServiceType = value!;
                      });
                    },
                  ),
                ),

                SizedBox(height: 16),

                // Remember Me Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: Colors.purple,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text("Remember me"),
                  ],
                ),

                SizedBox(height: 24),

                // Sign Up Button
                BlocConsumer<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupSuccess) {
                      box.put('servicemanid', state.id);
                      // box.put("key", value)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signup Success!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ServiceDetailsBloc(ServiceDetailRepository()),
                            child: const ServiceDetailScreen(),
                          ),
                        ),
                      );

                    } else if (state is SignupFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signup Failed: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is SignupLoading
                            ? null
                            : () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isEmpty || !email.contains('@')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a valid email.')),
                            );
                          } else if (password.isEmpty || password.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password must be at least 6 characters long.')),
                            );
                          } else if (selectedServiceType.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a service type.')),
                            );
                          } else {
                            BlocProvider.of<SignupBloc>(context).add(
                              SignupSubmitted(
                                email: email,
                                password: password,
                                serviceType: selectedServiceType,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: state is SignupLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Sign up",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
