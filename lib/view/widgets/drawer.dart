import 'package:adota_pets_mobile/view/pages/favoritos_vazia.dart';
import 'package:adota_pets_mobile/view/pages/tela_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DrawerItem { feed, favoritos, meusPets, conversas, perfil, configuracoes }

class DrawerApp extends StatelessWidget {
  final DrawerItem activeItem;
  const DrawerApp({super.key, required this.activeItem});

  void _navigate(BuildContext context, DrawerItem destination) {
    if (activeItem == destination) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);

    Navigator.pushReplacementNamed(context, _routeFor(destination));
  }

  String _routeFor(DrawerItem item) {
    switch (item) {
      case DrawerItem.feed:
        return '/feed';
      case DrawerItem.favoritos:
        return '/favoritos';
      case DrawerItem.meusPets:
        return '/meusPets';
      case DrawerItem.configuracoes:
        return '/config';
      case DrawerItem.perfil:
        return '/perfil';
      case DrawerItem.conversas:
        return '/conversas';
      default:
        return '/feed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AdotaPets',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'ADOTE COM AMOR',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).hintColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Theme.of(context).dividerColor),
            const SizedBox(height: 8),

            _DrawerItem(
              icon: Icons.home_outlined,
              label: 'Feed',
              isActive: activeItem == DrawerItem.feed,
              onTap: () => _navigate(context, DrawerItem.feed),
            ),
            _DrawerItem(
              icon: Icons.favorite_outline,
              label: 'Favoritos',
              isActive: activeItem == DrawerItem.favoritos,
              onTap: () => _navigate(context, DrawerItem.favoritos),
            ),
            _DrawerItem(
              icon: Icons.pets, // ADICIONADO
              label: 'Meus Pets',
              isActive: activeItem == DrawerItem.meusPets,
              onTap: () => _navigate(context, DrawerItem.meusPets),
            ),
            _DrawerItem(
              icon: Icons.chat_bubble_outline,
              label: 'Conversas',
              isActive: activeItem == DrawerItem.conversas,
              onTap: () => _navigate(context, DrawerItem.conversas),
            ),
            _DrawerItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              isActive: activeItem == DrawerItem.perfil,
              onTap: () => _navigate(context, DrawerItem.perfil),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              isActive: activeItem == DrawerItem.configuracoes,
              onTap: () => _navigate(context, DrawerItem.configuracoes),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quer ajudar?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Todo pet merece um lar amoroso.\nCompartilhe o app com amigos.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.pets,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.pets,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? colors.onPrimary : theme.iconTheme.color,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? colors.onPrimary : colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
