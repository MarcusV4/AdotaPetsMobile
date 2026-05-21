
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerApp(activeItem: DrawerItem.favoritos),

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "AdotaPets",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Seus ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    TextSpan(
                      text: "Favoritos",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8622A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              const Text(
                "Pets que você favoritou",
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 100),
              Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDD835),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFF1A1A1A),
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nenhum favorito ainda",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Toque no coração em qualquer pet para salvá-lo aqui",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
