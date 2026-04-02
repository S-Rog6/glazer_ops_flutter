import 'package:flutter/material.dart';

import 'core/supabase/supabase_bootstrap.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initialize();
  runApp(const GlazerOpsApp());
}
