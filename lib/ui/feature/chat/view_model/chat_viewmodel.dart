import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../models/gen.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final AuthRepository _authRepository;

  List<ChatMessage> messages = [];
  bool isLoadingMessage = false;

  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  String get currentUserId => _authRepository.currentUser?.uid ?? '';

  late final sendMessageCommand = Command1<Unit, String>(_sendMessage);

  late final logoutCommand = Command0<Unit>(_logout);

  ChatViewModel({
    required ChatRepository chatRepository,
    required AuthRepository authRepository,
  }) : _chatRepository = chatRepository,
       _authRepository = authRepository {
    _startListeningToMessages();
  }

  void _startListeningToMessages() {
    _messagesSubscription?.cancel();
    isLoadingMessage = true;
    notifyListeners();
    _messagesSubscription = _chatRepository.getMessages().listen(
      (newMessages) {
        newMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        messages = newMessages;
        isLoadingMessage = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Erro: $error');
      },
    );
  }

  AsyncResult<Unit> _sendMessage(String text) async =>
      _chatRepository.sendMessage(text);

  AsyncResult<Unit> _logout() async {
    return _authRepository.logout();
  }

  void markAsRead(String messageId) {
    _chatRepository.markAsRead(messageId);
  }

  Stream<List<ReadReceipt>> getReadReceipts(String messageId) {
    return _chatRepository.getReadReceipts(messageId);
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
