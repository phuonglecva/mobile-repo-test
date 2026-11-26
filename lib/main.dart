import 'package:flutter/material.dart';

import 'app.dart';
import 'state/progress_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressStore.instance.init();
  runApp(const MiloEnglishApp());
}
