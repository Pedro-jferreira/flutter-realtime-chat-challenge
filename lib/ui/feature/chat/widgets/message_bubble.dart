import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Adicione intl no pubspec para formatar horas
import 'package:provider/provider.dart';

import '../../../../models/gen.dart';
import '../../../core/theme.dart';
import '../view_model/chat_viewmodel.dart';
import 'read_receipts_sheet.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    if (!widget.isMe) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatViewModel>().markAsRead(widget.message.id);
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.message.text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mensagem copiada!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showReadReceiptsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ReadReceiptsSheet(messageId: widget.message.id),
    );
  }

  void _showMyOptionsMenu() async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text('Copiar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'info',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text('Ver quem leu'),
            ],
          ),
        ),
      ],
    );

    if (!mounted) return;
    if (selected == 'copy') {
      _copyToClipboard();
    } else if (selected == 'info') {
      _showReadReceiptsSheet();
    }
  }

  // --- GUARDA A POSIÇÃO DO TOQUE ---
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = Theme.of(context).extension<AppColorsExtension>();

    final timeString = DateFormat('HH:mm').format(widget.message.timestamp);
    final size = MediaQuery.of(context).size;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: widget.isMe ? const Radius.circular(16) : Radius.zero,
      bottomRight: widget.isMe ? Radius.zero : const Radius.circular(16),
    );

    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width * 0.75),

        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),

          cchild: Material(
            color: widget.isMe ? theme.colorScheme.primary : customColors
                ?.neutralBackground,
            borderRadius: borderRadius,
            surfaceTintColor: Colors.transparent,
            elevation: widget.isMe ? 1 : 0.5,
            child: InkWell(
              onTapDown: _storePosition,
              onTap: widget.isMe ? _showMyOptionsMenu : null,
              onLongPress: widget.isMe
                  ? _showReadReceiptsSheet
                  : _copyToClipboard,
              borderRadius: borderRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 14),
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!widget.isMe)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        // SizedBox garante que o alinhamento fique na esquerda
                        child: SizedBox(
                          width: 70,
                          child: Tooltip(
                            message: widget.message.senderName,
                            // Mostra o nome completo
                            triggerMode: TooltipTriggerMode.tap,
                            // Permite clicar para ver
                            preferBelow: true,
                            // Tenta mostrar em cima do nome
                            child: Text(
                              widget.message.senderName,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              // Limita a uma linha
                              overflow: TextOverflow.ellipsis,
                              // Adiciona o "..."
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Texto da Mensagem
                    Flexible(
                      child: Text(
                        widget.message.text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: widget.isMe
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          timeString,
                          style: TextStyle(
                            fontSize: 10,
                            color: widget.isMe
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
