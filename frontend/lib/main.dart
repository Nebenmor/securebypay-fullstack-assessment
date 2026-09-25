import 'package:flutter/material.dart';
import 'core/api/api_client.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/retry_banner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.instance.loadToken();
  ApiClient.instance.warmUp(); // fire and forget
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Myafrimall',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      builder: (context, child) => RetryBanner(child: child!),
    );
  }
}