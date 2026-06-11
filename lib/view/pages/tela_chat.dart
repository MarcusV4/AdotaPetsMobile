// lib/view/pages/tela_chat.dart

import 'package:adota_pets_mobile/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/modelo/usuario_logado.dart';
import 'package:adota_pets_mobile/services/pessoa_service.dart';
import 'package:adota_pets_mobile/view/pages/chat_vazio.dart';
import 'package:adota_pets_mobile/view/widgets/bolha_mensagem.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/provider_mensagem.dart';

class TelaChat extends StatefulWidget {
  final ChatModelo chat;

  const TelaChat({super.key, required this.chat});

  @override
  State<TelaChat> createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late UsuarioLogado _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = context.read<AuthProvider>().usuario!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MensagensProvider>().iniciarPolling(
        widget.chat.idChat,
        _usuario,
      );
    });
  }

  @override
  void dispose() {
    context.read<MensagensProvider>().pararPolling();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<MensagensProvider>().enviarMensagem(
      chatId: widget.chat.idChat,
      conteudo: text,
      usuario: _usuario,
    );
    _scrollParaBaixo();
  }

  void _scrollParaBaixo() {
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
    final nomePet = widget.chat.pet?.nome ?? '';
    final fotoPet = widget.chat.pet?.foto;
    final nomeOutro = widget.chat.nomeOutraPessoa(_usuario.id);
    final donoId = widget.chat.pessoa1?.id == _usuario.id
        ? widget.chat.pessoa2?.id
        : widget.chat.pessoa1?.id;

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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A1A1A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Avatar: foto do pet ou inicial do outro usuário
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: fotoPet != null
                    ? Image.network(
                        fotoPet,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _avatarFallback(nomeOutro),
                      )
                    : _avatarFallback(nomeOutro),
              ),
              const SizedBox(width: 10),
              Column(
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
                  if (nomePet.isNotEmpty)
                    Text(
                      'Sobre: $nomePet',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    )
                  else if (donoId != null)
                    FutureBuilder(
                      future: PessoaService().buscarPorId(donoId),
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
          Expanded(child: _buildMensagens()),
          _buildCampoEnvio(),
        ],
      ),
    );
  }

  Widget _buildMensagens() {
    return Consumer<MensagensProvider>(
      builder: (context, provider, _) {
        final mensagens = provider.mensagens;

        if (mensagens.isEmpty) {
          return ChatVazio(petName: widget.chat.pet?.nome ?? '');
        }

        _scrollParaBaixo();

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: mensagens.length,
          itemBuilder: (context, index) {
            final msg = mensagens[index];
            print(
              'remetenteId: "${msg.remetenteId}" | meuId: "${_usuario.id}"',
            );
            return BolhaMensagem(
              message: msg,
              isMe: msg.remetenteId == _usuario.id,
            );
          },
        );
      },
    );
  }

  Widget _buildCampoEnvio() {
    return Container(
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
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Escreva uma mensagem...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFFBBB3AA)),
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
    );
  }

  Widget _avatarFallback(String nome) {
    final inicial = nome.isNotEmpty ? nome[0].toUpperCase() : '?';
    return Container(
      width: 40,
      height: 40,
      color: const Color(0xFFEAE4DD),
      child: Center(
        child: Text(
          inicial,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF888888),
          ),
        ),
      ),
    );
  }
}
