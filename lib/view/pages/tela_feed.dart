
import 'package:adota_pets_mobile/view/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/widgets/corpo_feed.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaFeed extends StatelessWidget{
  const TelaFeed({super.key});

  static final List<PetModelo> _pets = [
    PetModelo(
      name: 'Luna',
      type: 'Dog',
      breed: 'Golden Retriever',
      age: '2 years',
      location: 'San Francisco, CA',
      tags: ['Amigável', 'Brincalhona', 'Gentil'],
      imageUrl:
      'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600',
    ),
    PetModelo(
      name: 'Milo',
      type: 'Cat',
      breed: 'Siamese',
      age: '1 year',
      location: 'Austin, TX',
      tags: ['Calmo', 'Carinhoso', 'Curioso'],
      imageUrl:
      'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=600',
    ),
    PetModelo(
      name: 'Rex',
      type: 'Dog',
      breed: 'Labrador',
      age: '3 years',
      location: 'New York, NY',
      tags: ['Energético', 'Leal', 'Protetor'],
      imageUrl:
      'https://images.unsplash.com/photo-1561037404-61cd46aa615b?w=600',
    ),
  ];



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
              "AdotaPets",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: Color(0xFFE0D9D1)),
          ),
        ),
      drawer: const DrawerApp(activeItem: DrawerItem.feed),
      body: BodyFeed(pets: _pets),
    );
  }
}