import 'package:adota_pets_mobile/view/pages/tela_feed.dart';
import 'package:adota_pets_mobile/view/pages/tela_login.dart';
import 'package:adota_pets_mobile/view/widgets/abas_auth.dart';
import 'package:adota_pets_mobile/view/widgets/botao_login.dart';
import 'package:adota_pets_mobile/view/widgets/campo_texto.dart';
import 'package:adota_pets_mobile/view/widgets/logo_adotapets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../widgets/provider_auth.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  bool _emailValido(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha todos os campos.');
      return;
    }

    if (senha.length < 6) {
      _mostrarErro('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (!_emailValido(email)) {
      _mostrarErro('Informe um e-mail válido.');
      return;
    }

    setState(() => _carregando = true);

    try {
      final usuario = await AuthService().registrar(nome, email, senha);
      if (!mounted) return;

      // Salva o usuário no provider e vai direto para o feed
      context.read<AuthProvider>().salvar(usuario);
      Navigator.pushReplacementNamed(context, '/feed');
    } catch (e) {
      if (mounted) _mostrarErro(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

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
              const Text(
                "Crie sua conta!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Cadastre-se e encontre o seu novo pet!",
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 28),
              AbasAuth(
                isLogin: false,
                onLoginTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),
              CampoTexto(
                controller: _nomeController,
                hint: "Seu nome completo",
              ),
              const SizedBox(height: 14),
              CampoTexto(
                controller: _emailController,
                hint: "Seu e-mail",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              CampoTexto(
                controller: _senhaController,
                hint: "Sua senha",
                obscureText: true,
              ),
              const SizedBox(height: 24),
              BotaoLogin(
                label: "Criar conta",
                carregando: _carregando,
                onPressed: _carregando ? null : _cadastrar,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Já tem conta?",
                      style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE8622A),
                          fontWeight: FontWeight.w600,
                        ),
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
