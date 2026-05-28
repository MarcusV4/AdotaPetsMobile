import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatVazio extends StatelessWidget {
  final String petName;
  const ChatVazio({required this.petName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE8622A).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pets, size: 34, color: Color(0xFFE8622A)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Conversa iniciada!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Apresente-se e pergunte sobre $petName',
            style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}
