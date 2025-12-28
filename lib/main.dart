import 'package:desafio_flugo_flutter/repositories/auth_repository.dart';
import 'package:desafio_flugo_flutter/ui/core/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/dependency_injection.dart';
import 'core/firebase_options.dart';
import 'core/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.setLanguageCode('pt-BR');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      child: Builder(
        builder: (innerContext) {
          final authRepository = innerContext.read<AuthRepository>();
          final goRouter = createRouter(authRepository);
          return MaterialApp.router(
            title: 'Desafio Chat Flutter',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}