import 'package:adota_pets_mobile/view/widgets/bloco_config.dart';
import 'package:adota_pets_mobile/view/widgets/card_config.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaConfig extends StatefulWidget {
  const TelaConfig({super.key});

  @override
  State<TelaConfig> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<TelaConfig> {
  bool _notificacoes = false;
  bool _modoEscuro = false;
  bool _localizacao = false;
  bool _visibilidade = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0EB),
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'AdotaPets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE0D9D1)),
        ),
      ),
      drawer: const DrawerApp(activeItem: DrawerItem.configuracoes),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gerencie suas preferências',
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 24),

          CardConfig(
            title: 'PREFERÊNCIAS',
            items: [
              BlocoConfig(
                icon: Icons.notifications_outlined,
                label: 'Notificações',
                subtitle: 'Seja notificado sobre novos pets',
                value: _notificacoes,
                onChanged: (v) => setState(() => _notificacoes = v),
              ),
              BlocoConfig(
                icon: Icons.dark_mode_outlined,
                label: 'Modo Escuro',
                subtitle: 'Alternar tema escuro',
                value: _modoEscuro,
                onChanged: (v) => setState(() => _modoEscuro = v),
              ),
              BlocoConfig(
                icon: Icons.language_outlined,
                label: 'Localização',
                subtitle: 'Mostrar pets perto de você',
                value: _localizacao,
                onChanged: (v) => setState(() => _localizacao = v),
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          CardConfig(
            title: 'PRIVACIDADE',
            items: [
              BlocoConfig(
                icon: Icons.shield_outlined,
                label: 'Visibilidade do Perfil',
                subtitle: 'Permitir que abrigos vejam seu perfil',
                value: _visibilidade,
                onChanged: (v) => setState(() => _visibilidade = v),
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
