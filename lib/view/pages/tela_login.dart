import 'package:adota_pets_mobile/services/auth_service.dart';
import 'package:adota_pets_mobile/view/pages/tela_cadastro.dart';
import 'package:adota_pets_mobile/view/pages/tela_feed.dart';
import 'package:adota_pets_mobile/view/widgets/abas_auth.dart';
import 'package:adota_pets_mobile/view/widgets/botao_login.dart';
import 'package:adota_pets_mobile/view/widgets/campo_texto.dart';
import 'package:adota_pets_mobile/view/widgets/logo_adotapets.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  bool _emailValido(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preenhca e-mail e senha.');
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
      final usuario = await AuthService().login(email, senha);
      if (!mounted) return;

      context.read<AuthProvider>().salvar(usuario);

      Navigator.pushReplacementNamed(context, '/feed');
    } catch (e) {
      if (mounted) _mostrarErro(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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
              Text(
                "Bem-vindo de volta!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Entre para continuar adotando pets!",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),

              const SizedBox(height: 26),
              AbasAuth(
                isLogin: true,
                onRegisterTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaCadastro()),
                ),
              ),
              const SizedBox(height: 24),
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
                label: "Entrar",
                carregando: _carregando,
                onPressed: _carregando ? null : _entrar,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Não tem conta?",
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                      ),
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
                          color: Theme.of(context).colorScheme.primary,
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
