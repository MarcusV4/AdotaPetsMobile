import 'package:adota_pets_mobile/view/widgets/titulo_conversas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversasVazia extends StatelessWidget {
  const ConversasVazia();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TituloConversas(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone sem fundo colorido, apenas o outline cinza
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nenhuma conversa ainda',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Texto com emoji de coração no meio
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                      children: [
                        TextSpan(text: 'Dê um '),
                        TextSpan(text: '❤️'),
                        TextSpan(
                          text: ' em um pet e inicie o processo de adoção',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
