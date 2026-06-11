// lib/view/widgets/card_conversas.dart

import 'package:adota_pets_mobile/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/view/pages/tela_chat.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:adota_pets_mobile/view/widgets/provider_mensagem.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/chat_service.dart';

class CardConversas extends StatelessWidget {
  final ChatModelo conversa;

  const CardConversas({super.key, required this.conversa});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final meuId = auth.usuarioId;
    final nomeOutro = conversa.nomeOutraPessoa(meuId);
    final nomePet = conversa.pet?.nome ?? '';
    final fotoPet = conversa.pet?.foto;
    final inicial = nomeOutro.isNotEmpty ? nomeOutro[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MensagensProvider(),
            child: TelaChat(chat: conversa),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: fotoPet != null
                  ? Image.network(
                      fotoPet,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _avatarFallback(inicial),
                    )
                  : _avatarFallback(inicial),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomeOutro,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FutureBuilder(
                    future: ChatApiService(
                      token: auth.token,
                    ).listarMensagens(conversa.idChat),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text(
                          conversa.pet?.nome != null
                              ? 'Sobre: ${conversa.pet!.nome}'
                              : 'Nenhuma mensagem ainda',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                        );
                      }

                      final ultima = snapshot.data!.last;
                      final ehMinha = ultima.remetenteId == meuId;
                      final prefixo = ehMinha ? 'Você: ' : '';

                      return Text(
                        '$prefixo${ultima.conteudo}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF888888),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(String inicial) {
    return Container(
      width: 64,
      height: 64,
      color: const Color(0xFFEAE4DD),
      child: Center(
        child: Text(
          inicial,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}
