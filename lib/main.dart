import 'package:bmw_app/app.dart';
import 'package:bmw_app/src/rust/frb_generated.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const BmwEnetApp());
}
