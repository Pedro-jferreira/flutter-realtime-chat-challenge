import 'package:desafio_flugo_flutter/ui/feature/chat/view_model/chat_viewmodel.dart';
import 'package:desafio_flugo_flutter/ui/feature/chat/widgets/chat_input_area.dart';
import 'package:desafio_flugo_flutter/ui/feature/chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // O ScrollController é opcional agora, a menos que queira paginação futura
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;

  void _scrollToBottom() {
    // Com reverse: true, o "Bottom" (mensagens novas) é o offset 0
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5DDD5),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'assets/android-icon-192x192.png',
              height: 32,
              errorBuilder: (_, _, _) => const Icon(Icons.error),
            ),
            const SizedBox(width: 12),
            Text('Team Chat', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await context.read<ChatViewModel>().logoutCommand.execute();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma mensagem ainda.\nDiga Olá!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                if (viewModel.messages.length > _previousMessageCount) {
                  _previousMessageCount = viewModel.messages.length;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = viewModel.messages[index];
                    final isMe = message.senderId == viewModel.currentUserId;

                    return MessageBubble(
                      key: ValueKey(message.id),
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          const ChatInputArea(),
        ],
      ),
    );
  }
}
