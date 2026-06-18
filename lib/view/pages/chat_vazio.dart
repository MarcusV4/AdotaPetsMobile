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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Conversa iniciada!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Apresente-se e pergunte sobre $petName',
            style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}
