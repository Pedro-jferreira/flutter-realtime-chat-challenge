import 'package:result_dart/result_dart.dart';

import '../core/failures.dart';
import '../models/gen.dart';
import '../services/chat_service.dart';
import '../services/firebase_auth_service.dart'; // Precisamos saber quem é o "Eu"

class ChatRepository {
  final ChatService _chatService;
  final FirebaseAuthService _authService;

  ChatRepository(this._chatService, this._authService);

  Stream<List<ChatMessage>> getMessages() {
    return _chatService.getMessagesStream();
  }

  AsyncResult<Unit> sendMessage(String text) async {
    final user = _authService.currentUser;

    if (user == null) {
      return Failure(AppFailure('Usuário não logado'));
    }

    final message = ChatMessage(
      id: '',
      text: text,
      senderId: user.uid,
      senderName: user.displayName ?? 'Usuário',
      timestamp: DateTime.now(),
    );

    return _chatService.sendMessage(message);
  }

  AsyncResult<Unit> markAsRead(String messageId) async {
    final user = _authService.currentUser;
    if (user == null) return const Success(unit);

    return _chatService.markMessageAsRead(messageId, user.uid);
  }
}
