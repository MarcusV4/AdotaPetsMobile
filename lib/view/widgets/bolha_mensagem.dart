// lib/view/widgets/bolha_mensagem.dart

import 'package:adota_pets_mobile/modelo/mensagem_modelo.dart';
import 'package:flutter/material.dart';

class BolhaMensagem extends StatelessWidget {
  final MensagemModelo message;
  final bool isMe;

  const BolhaMensagem({super.key, required this.message, required this.isMe});

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFE8622A) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
            ),
            child: Text(
              message.conteudo,
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            _formatTime(message.dataEnvio),
            style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}
