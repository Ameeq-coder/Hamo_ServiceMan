import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_service_man/Auth/BLOC/login_bloc.dart';
import 'package:hamo_service_man/Auth/BLOC/signup_bloc.dart';
import 'package:hamo_service_man/Auth/Repositry/SignupRepositry.dart';
import 'package:hamo_service_man/Auth/Repositry/login_repository.dart';
import 'package:hamo_service_man/Auth/Screens/Login.dart';
import 'package:hamo_service_man/Auth/Screens/SignupScreen.dart';

import 'CalenderScreen/CalenderScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AuthBloc(AuthRepository()),
        child: LoginScreen(),
      ),
    );
  }
}