import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'AppBlocObserver.dart';
import 'MyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // ✅ Open the Hive box for storing user data
  await Hive.openBox('servicebox');

  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}


