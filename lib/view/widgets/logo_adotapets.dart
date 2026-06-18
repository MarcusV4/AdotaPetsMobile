import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoAdotapets extends StatelessWidget {
  const LogoAdotapets({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEE6F38),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          'AdotaPets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
