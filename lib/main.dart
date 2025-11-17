import 'package:causeries_client/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:window_size/window_size.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set minimum window size for desktop platforms
  setWindowMinSize(const Size(1280, 720));
  runApp(const Causeries());
}
