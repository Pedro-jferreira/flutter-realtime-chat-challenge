import 'package:desafio_flugo_flutter/ui/feature/chat/view_model/chat_viewmodel.dart';
import 'package:desafio_flugo_flutter/ui/feature/login/view_model/login_view_model.dart';
import 'package:desafio_flugo_flutter/ui/feature/register/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Repositories
import '../repositories/auth_repository.dart';
import '../repositories/chat_repository.dart';
import '../services/chat_service.dart';
// Services
import '../services/firebase_auth_service.dart';
import '../services/user_service.dart';

// ... imports anteriores

class AppDependencies extends StatelessWidget {
  final Widget child;

  const AppDependencies({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseAuthService()),
        Provider(create: (_) => UserService()),
        Provider(create: (_) => ChatService()),
        ChangeNotifierProxyProvider2<
          FirebaseAuthService,
          UserService,
          AuthRepository
        >(
          create: (context) => AuthRepository(
            authService: context.read<FirebaseAuthService>(),
            dbService: context.read<UserService>(),
          ),
          update: (_, auth, db, previous) =>
              previous ?? AuthRepository(authService: auth, dbService: db),
        ),

        ProxyProvider2<ChatService, FirebaseAuthService, ChatRepository>(
          update: (_, chatService, authService, _) =>
              ChatRepository(chatService, authService),
        ),

        // ViewModels...
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) =>
              LoginViewModel(repository: context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<RegisterViewModel>(
          create: (context) =>
              RegisterViewModel(repository: context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<ChatViewModel>(
          create: (context) => ChatViewModel(
            chatRepository: context.read<ChatRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
