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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
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
