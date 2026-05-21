import 'package:adota_pets_mobile/view/pages/favoritos.dart';
import 'package:adota_pets_mobile/view/pages/tela_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DrawerItem { feed, favoritos, conversas, perfil, configuracoes }

class DrawerApp extends StatelessWidget {
  final DrawerItem activeItem;
  const DrawerApp({super.key, required this.activeItem});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8622A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pets, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AdotaPets',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        'ADOTE COM AMOR',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        color: Color(0xFF888888), size: 22),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFE0D9D1)),
            const SizedBox(height: 8),

            _DrawerItem(
              icon: Icons.home_outlined,
              label: 'Feed',
              isActive: activeItem == DrawerItem.feed,
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TelaFeed())),
            ),
            _DrawerItem(
              icon: Icons.favorite_outline,
              label: 'Favoritos',
              isActive: activeItem == DrawerItem.favoritos,
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Favoritos())),
            ),
            _DrawerItem(
              icon: Icons.chat_bubble_outline,
              label: 'Conversas',
              isActive: activeItem == DrawerItem.conversas,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              isActive: activeItem == DrawerItem.perfil,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              isActive: activeItem == DrawerItem.configuracoes,
              onTap: () => Navigator.pop(context),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quer ajudar?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Todo pet merece um lar amoroso.\nCompartilhe o app com amigos.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.pets, size: 16, color: Color(0xFFE8622A)),
                        SizedBox(width: 6),
                        Icon(Icons.pets, size: 16, color: Color(0xFFE8622A)),
                        SizedBox(width: 6),
                        Icon(Icons.pets, size: 16, color: Color(0xFFE8622A)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE8622A) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 20,
                  color: isActive ? Colors.white : const Color(0xFF666666)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.w400,
                  color:
                  isActive ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}