import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/firebase_options.dart';
import 'package:which/providers/router_provider.dart';

Future<void> main() async {
  // ignore: prefer_const_constructors
  setUrlStrategy(PathUrlStrategy());
  // final widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Which',
      theme: ThemeData(
        typography: !kIsWeb && Platform.isIOS
            ? Typography.material2021(platform: TargetPlatform.iOS)
            : null,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.blueGrey.shade800,
          cardColor: Colors.white,
          backgroundColor: Colors.blueGrey.shade50,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
      ),
      routerConfig: router,
    );
  }
}
