import 'package:adota_pets_mobile/view/widgets/form_cadastro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotaoFlutuante extends StatelessWidget {
  const BotaoFlutuante({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const FormCadastro(),
      ),
      backgroundColor: const Color(0xFFE8622A),
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
