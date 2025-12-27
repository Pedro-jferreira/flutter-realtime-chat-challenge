import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/gen.dart';
import '../view_model/chat_viewmodel.dart';

class ReadReceiptsSheet extends StatelessWidget {
  final String messageId;

  const ReadReceiptsSheet({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Lido por',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<ReadReceipt>>(
                  stream: viewModel.getReadReceipts(messageId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return const Text('Erro ao carregar.');
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());

                    final receipts = snapshot.data!;
                    if (receipts.isEmpty) {
                      return const Center(
                        child: Text('Ninguém visualizou ainda.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: receipts.length,
                      itemBuilder: (context, index) {
                        final receipt = receipts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(receipt.userName[0].toUpperCase()),
                          ),
                          title: Text(receipt.userName),
                          subtitle: Text(
                            DateFormat('dd/MM HH:mm').format(receipt.timestamp),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
