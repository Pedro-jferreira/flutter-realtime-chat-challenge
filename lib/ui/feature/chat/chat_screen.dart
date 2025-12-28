import 'dart:async';

import 'package:desafio_flugo_flutter/ui/feature/chat/view_model/chat_viewmodel.dart';
import 'package:desafio_flugo_flutter/ui/feature/chat/widgets/chat_input_area.dart';
import 'package:desafio_flugo_flutter/ui/feature/chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  int _previousMessageCount = 0;
  bool _showDateBubble = false;
  DateTime? _currentDateBubbleDate;
  Timer? _bubbleHideTimer;

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) return 'Hoje';
    if (messageDate == yesterday) return 'Ontem';

    final months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];
    return '${date.day} de ${months[date.month - 1]}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _onScroll() {
    if (!_showDateBubble) {
      setState(() => _showDateBubble = true);
    }

    _bubbleHideTimer?.cancel();
    _bubbleHideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showDateBubble = false);
    });
  }
  void _scrollToBottom() {
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
    final customColors = Theme.of(context).extension<AppColorsExtension>();
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: customColors?.neutralBackground,
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
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Consumer<ChatViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off, size: 64, color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface),
                            const SizedBox(height: 16),
                            Text(
                              viewModel.errorMessage!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: customColors?.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: viewModel.retryConnection,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (viewModel.isLoadingMessage) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

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
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification) {
                          _onScroll();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: viewModel.messages.length,
                        itemBuilder: (context, index) {
                          final message = viewModel.messages[index];
                          final isMe = message.senderId ==
                              viewModel.currentUserId;
                          bool showDateHeader = false;
                          if (index == viewModel.messages.length - 1) {
                            showDateHeader = true;
                          } else {
                            final nextMessage = viewModel.messages[index + 1];
                            if (!_isSameDay(
                                message.timestamp, nextMessage.timestamp)) {
                              showDateHeader = true;
                            }
                          }
                          if (_showDateBubble) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_currentDateBubbleDate != message.timestamp &&
                                  mounted) {
                                setState(() =>
                                _currentDateBubbleDate = message.timestamp);
                              }
                            });
                          }

                          return Column(
                            children: [
                              if (showDateHeader)
                                _buildDateHeader(
                                    _formatDateLabel(message.timestamp)),

                              MessageBubble(
                                key: ValueKey(message.id),
                                message: message,
                                isMe: isMe,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  child: AnimatedOpacity(
                    opacity: _showDateBubble ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        // Fundo levemente translúcido
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Text(
                        _currentDateBubbleDate != null
                            ? _formatDateLabel(_currentDateBubbleDate!)
                            : 'Carregando...',
                        style: const TextStyle(fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ChatInputArea(),
        ],
      ),
    );
  }
}

Widget _buildDateHeader(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500),
    ),
  );
}
