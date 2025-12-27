import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:result_dart/result_dart.dart';

import '../core/failures.dart';
import '../models/gen.dart';

class ChatService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  AsyncResult<Unit> sendMessage(ChatMessage message) async {
    try {
      final ref = _db.ref('messages').push();

      final messageWithId = message.copyWith(id: ref.key!);

      await ref.set(messageWithId.toJson());
      return const Success(unit);
    } catch (e) {
      return Failure(AppFailure('Erro ao enviar mensagem'));
    }
  }
  Stream<List<ChatMessage>> getMessagesStream() {
    return _db.ref('messages').limitToLast(100).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      final List<ChatMessage> messages = [];

      map.forEach((key, value) {
        final msgMap = Map<String, dynamic>.from(value as Map);
        msgMap['id'] = key.toString();
        messages.add(ChatMessage.fromJson(msgMap));
      });
      return messages;
    });
  }

  AsyncResult<Unit> markMessageAsRead(String messageId, String userId,
      String userName) async {
    try {
      // Salvamos em 'receipts/msgId/userId'
      await _db.ref('receipts/$messageId/$userId').update({
        'status': 'read',
        'userName': userName, // Salvamos o nome para exibir fácil depois
        'timestamp': ServerValue.timestamp,
      });
      return const Success(unit);
    } catch (e) {
      return Failure(AppFailure('Erro ao marcar lido'));
    }
  }

  Stream<List<ReadReceipt>> getReadReceiptsStream(String messageId) {
    return _db.ref('receipts/$messageId').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      final List<ReadReceipt> receipts = [];

      map.forEach((key, value) {
        final userId = key.toString();
        final receiptMap = Map<String, dynamic>.from(value as Map);
        receipts.add(ReadReceipt.fromMap(receiptMap, userId));
      });

      receipts.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return receipts;
    });
  }
}