import 'package:adota_pets_mobile/view/widgets/bloco_config.dart';
import 'package:adota_pets_mobile/view/widgets/card_config.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:adota_pets_mobile/view/widgets/provider_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // elevation: 0,
        // titleSpacing: 0,
        // leading: Builder(
        //   builder: (ctx) => IconButton(
        //     icon: Icon(
        //       Icons.menu,
        //       color: Theme.of(context).colorScheme.onSurface,
        //     ),
        //     onPressed: () => Scaffold.of(ctx).openDrawer(),
        //   ),
        // ),
        title: Text(
          'AdotaPets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      drawer: const DrawerApp(activeItem: DrawerItem.configuracoes),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Text(
            'Configurações',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gerencie suas preferências',
            style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
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
                value: context.watch<ThemeProvider>().modoEscuro,
                onChanged: (v) => context.read<ThemeProvider>().definir(v),
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
