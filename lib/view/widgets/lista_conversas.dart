import 'package:adota_pets_mobile/modelo/conversa_modelo.dart';

import 'package:adota_pets_mobile/view/widgets/card_conversas.dart';
import 'package:adota_pets_mobile/view/widgets/titulo_conversas.dart';
import 'package:flutter/cupertino.dart';

class ListaConversas extends StatelessWidget {
  final List<Conversa> conversas;
  const ListaConversas({required this.conversas});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        TituloConversas(),
        const SizedBox(height: 20),
        ...conversas.map(
          (conversa) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CardConversas(conversa: conversa),
          ),
        ),
      ],
    );
  }
}
