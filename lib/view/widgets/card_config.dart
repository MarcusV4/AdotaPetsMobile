import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardConfig extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const CardConfig({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).hintColor,
                letterSpacing: 0.8,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}
