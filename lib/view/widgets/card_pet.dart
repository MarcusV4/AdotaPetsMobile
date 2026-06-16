import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/pages/tela_detalhe_pet.dart';
import 'package:adota_pets_mobile/view/widgets/provider_favoritos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPet extends StatelessWidget {
  final PetModelo pet;
  final VoidCallback onTap;
  const CardPet({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        final isFav = favs.isFavorite(pet);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    theme.brightness == Brightness.dark ? 0.25 : 0.06,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        pet.imagemUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: theme.scaffoldBackgroundColor,
                          child: Center(
                            child: Icon(
                              Icons.pets,
                              size: 48,
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Nome sobre a imagem
                    Positioned(
                      bottom: 12,
                      left: 14,
                      child: Text(
                        pet.nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 6, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                    // Botão favorito
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => favs.toggle(pet),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFav
                                ? colors.primary
                                : theme.iconTheme.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Informações
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _TypeBadge(label: pet.especie),
                          const SizedBox(width: 8),
                          Text(
                            pet.raca,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.surface,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            pet.idade,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                      if (pet.location.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: theme.iconTheme.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              pet.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (pet.temperamento.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: pet.temperamento
                              .map(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.secondary,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: colors.primary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    PetModelo.formatarTemperamento(t),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.primary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _TypeBadge extends StatelessWidget {
//   final String label;
//   const _TypeBadge({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: colors.secondary,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(fontSize: 12, color: colors.onSurface),
//       ),
//     );
//   }
// }

class _TypeBadge extends StatelessWidget {
  final String label;

  const _TypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
