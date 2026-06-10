import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/services/pessoa_service.dart';

import 'package:adota_pets_mobile/view/pages/chat_vazio.dart';
import 'package:adota_pets_mobile/view/widgets/bolha_mensagem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/provider_conversas.dart';

class TelaChat extends StatefulWidget {
  final PetModelo pet;
  const TelaChat({super.key, required this.pet});

  @override
  State<TelaChat> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<TelaChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    context.read<ConversasProvider>().sendMessage(widget.pet, text);
    _controller.clear();
    // Rola para o final após enviar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversa = context
        .watch<ConversasProvider>()
        .conversas
        .where((c) => c.pet.nome == widget.pet.nome)
        .first;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Botão voltar
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A1A1A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Avatar do pet
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.pet.imagemUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFFEAE4DD),
                    child: const Icon(
                      Icons.pets,
                      size: 20,
                      color: Color(0xFFBBB3AA),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pet.nome,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  FutureBuilder(
                    future: PessoaService().buscarPorId(widget.pet.donoId),
                    builder: (context, snapshot) {
                      final nome = snapshot.data?.nome ?? '...';
                      return Text(
                        'Chat com $nome',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE0D9D1)),
        ),
      ),
      body: Column(
        children: [
          // Área de mensagens
          Expanded(
            child: conversa.messages.isEmpty
                ? ChatVazio(petName: widget.pet.nome)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: conversa.messages.length,
                    itemBuilder: (context, index) {
                      return BolhaMensagem(message: conversa.messages[index]);
                    },
                  ),
          ),

          // Campo de texto fixo no rodapé
          Container(
            color: const Color(0xFFF5F0EB),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE0D9D1)),
                    ),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Escreva uma mensagem...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFBBB3AA),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Botão enviar
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8622A).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_outlined,
                      size: 20,
                      color: Color(0xFFE8622A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
