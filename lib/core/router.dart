import 'package:desafio_flugo_flutter/ui/feature/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../repositories/auth_repository.dart';
import '../ui/feature/chat/chat_screen.dart';
import '../ui/feature/login/login_screen.dart';
import '../ui/feature/profile/name_setup_screen.dart';

GoRouter createRouter(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authRepository,
    redirect: (context, state) {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final hasName =
          user?.displayName != null && user!.displayName!.isNotEmpty;
      print(user?.displayName);

      final currentPath = state.uri.toString();
      final isLoginLoc = currentPath == '/login' || currentPath == '/register';
      final isCompleteProfileLoc = currentPath == '/complete-profile';

      if (!isLoggedIn) {
        return isLoginLoc ? null : '/login';
      }

      if (isLoggedIn && !hasName) {
        if (isCompleteProfileLoc) return null;
        return '/complete-profile';
      }

      if (isLoggedIn && hasName) {
        if (isLoginLoc || isCompleteProfileLoc) {
          return '/chat';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/chat', builder: (_, _) => const ChatScreen()),
      GoRoute(
        path: '/complete-profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NameSetupScreen(),
          opaque: false,
          // <--- MÁGICA 1: Permite ver a tela de trás
          barrierColor: Colors.black54,
          // <--- MÁGICA 2: Escurece o fundo
          barrierDismissible: false,
          // Bloqueia clique fora para fechar
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve =
                Curves.easeOutCubic; // Curva mais suave estilo iOS/Android

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
