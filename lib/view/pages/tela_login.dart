
import 'package:adota_pets_mobile/view/pages/tela_cadastro.dart';
import 'package:adota_pets_mobile/view/pages/tela_feed.dart';
import 'package:adota_pets_mobile/view/widgets/abas_auth.dart';
import 'package:adota_pets_mobile/view/widgets/botao_login.dart';
import 'package:adota_pets_mobile/view/widgets/campo_texto.dart';
import 'package:adota_pets_mobile/view/widgets/logo_adotapets.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget{
  const TelaLogin({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoAdotapets(),
                const SizedBox(height: 32),
                Text("Bem-vindo de volta!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),


                ),
                const SizedBox(height: 6),
                Text("Entre para continuar adotando pets!",
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                ),

                const SizedBox(height: 26,),
                AbasAuth(
                  isLogin: true,
                  onRegisterTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaCadastro()),
                  ),
                ),
                const SizedBox(height: 24),
                const CampoTexto(hint: "Seu e-mail", keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 14),
                const CampoTexto(hint: "Sua senha", obscureText: true),
                const SizedBox(height: 24),
                BotaoLogin(label: "Entrar", onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TelaFeed()))),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Não tem conta?", style: TextStyle(fontSize: 13, color: Color(0xFF888888))
                      ),

                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TelaCadastro()),
                        ),
                        child: Text(
                          "Cadastre-se",
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFE8622A),
                            fontWeight: FontWeight.w600,
                          )
                        ),
                      ),
                  ]
                ),
          ),
        ],
      ),
    )
    ),
    );
  }
}