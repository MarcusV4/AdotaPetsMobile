// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FormCadastro extends StatefulWidget {
  const FormCadastro({super.key});

  @override
  State<FormCadastro> createState() => _CadastrarPetModalState();
}

class _CadastrarPetModalState extends State<FormCadastro> {
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _descricaoController = TextEditingController();

  String? _especie;
  String? _sexo;
  String? _porte;
  bool _vacinado = false;
  bool _castrado = false;
  bool _enviando = false;
  final Set<String> _temperamentos = {};

  Uint8List? _imagemBytes; // bytes para exibir preview
  String? _imagemNome; // nome original do arquivo
  String? _imagemMime; // ex: "image/jpeg"

  static const _temperamentosOpcoes = [
    'BRINCALHAO',
    'CALMO',
    'CARINHOSO',
    'CURIOSO',
    'DOCIL',
    'ENERGETICO',
    'INDEPENDENTE',
    'INTELIGENTE',
    'LEAL',
    'PROTETOR',
    'SOCIAVEL',
    'TIMIDO',
  ];

  static const _temperamentosLabels = {
    'BRINCALHAO': 'Brincalhão',
    'CALMO': 'Calmo',
    'CARINHOSO': 'Carinhoso',
    'CURIOSO': 'Curioso',
    'DOCIL': 'Dócil',
    'ENERGETICO': 'Energético',
    'INDEPENDENTE': 'Independente',
    'INTELIGENTE': 'Inteligente',
    'LEAL': 'Leal',
    'PROTETOR': 'Protetor',
    'SOCIAVEL': 'Sociável',
    'TIMIDO': 'Tímido',
  };

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _idadeController.dispose();
    _localizacaoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _selecionarImagem() {
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'; // só aceita imagens
    input.click();

    input.onChange.listen((event) {
      final arquivo = input.files?.first;
      if (arquivo == null) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(arquivo);

      reader.onLoadEnd.listen((_) {
        setState(() {
          _imagemBytes = reader.result as Uint8List;
          _imagemNome = arquivo.name;
          _imagemMime = arquivo.type;
        });
      });
    });
  }

  Future<void> _cadastrar() async {
    final donoId = context.read<AuthProvider>().usuarioId;
    // Validação básica
    if (_nomeController.text.trim().isEmpty ||
        _especie == null ||
        _sexo == null ||
        _idadeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos obrigatórios (*)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      // TODO: substitua pelo id do usuário logado
      final donoId = context.read<AuthProvider>().usuarioId;
      final url = Uri.parse(
        'http://192.168.18.26:8080/api/pets/cadastrar/$donoId',
      );

      final request = http.MultipartRequest('POST', url);

      // Parte "dados" — JSON do pet como string
      final dados = jsonEncode({
        'nome': _nomeController.text.trim(),
        'idade': int.tryParse(_idadeController.text.trim()) ?? 0,
        'especie': _especie,
        'sexo': _sexo,
        'descricao': _descricaoController.text.trim(),
        'vacinado': _vacinado,
        'castrado': _castrado,
        'temperamento': _temperamentos.toList(),
        'porte': _porte,
        'raca': _racaController.text.trim(),
      });

      request.files.add(
        http.MultipartFile.fromString(
          'dados',
          dados,
          contentType: http.MediaType('application', 'json'),
        ),
      );

      // Parte "imagem" — só adiciona se o usuário selecionou uma foto
      if (_imagemBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'imagem',
            _imagemBytes!,
            filename: _imagemNome ?? 'foto.jpg',
            contentType: http.MediaType.parse(_imagemMime ?? 'image/jpeg'),
          ),
        );
      }

      print(request.fields);
      print(request.files.length);

      final response = await request.send();

      if (response.statusCode == 202) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet cadastrado com sucesso! 🐾'),
              backgroundColor: Color(0xFFE8622A),
            ),
          );
        }
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0D9D1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cadastrar Pet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ajude um pet a encontrar um lar',
                      style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF0EBE5)),

          // Conteúdo rolável
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto
                  const _Label('Foto do Pet'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selecionarImagem, // TODO: image picker
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0EB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE0D9D1),
                          // style: BorderStyle.solid,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: _imagemBytes != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(_imagemBytes!, fit: BoxFit.cover),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Trocar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_outlined,
                                  size: 28,
                                  color: Color(0xFF888888),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Clique para enviar uma foto',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nome
                  const _Label('Nome *'),
                  const SizedBox(height: 8),
                  _Field(controller: _nomeController, hint: 'Ex: Bolinha'),
                  const SizedBox(height: 16),

                  // Espécie + Sexo
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label('Espécie *'),
                            const SizedBox(height: 8),
                            _Dropdown(
                              value: _especie,
                              hint: 'Selecione',
                              items: const [
                                'Cachorro',
                                'Gato',
                                'Ave',
                                'Peixe',
                                'Roedor',
                                'Réptil',
                              ],
                              labels: const {
                                'Cachorro': 'Cachorro',
                                'Gato': 'Gato',
                                'Ave': 'Ave',
                                'Peixe': 'Peixe',
                                'Roedor': 'Roedor',
                                'Reptil': 'Réptil',
                              },
                              onChanged: (v) => setState(() => _especie = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label('Sexo *'),
                            const SizedBox(height: 8),
                            _Dropdown(
                              value: _sexo,
                              hint: 'Selecione',
                              items: const ['MACHO', 'FEMEA'],
                              labels: const {
                                'MACHO': 'Macho',
                                'FEMEA': 'Fêmea',
                              },
                              onChanged: (v) => setState(() => _sexo = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Raça + Idade
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label('Raça'),
                            const SizedBox(height: 8),
                            _Field(
                              controller: _racaController,
                              hint: 'Ex: Labrador',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label('Idade *'),
                            const SizedBox(height: 8),
                            _Field(
                              controller: _idadeController,
                              hint: 'Ex: 2',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Porte
                  const _Label('Porte'),
                  const SizedBox(height: 10),
                  Row(
                    children: ['PEQUENO', 'MEDIO', 'GRANDE'].map((p) {
                      final labels = {
                        'PEQUENO': 'Pequeno',
                        'MEDIO': 'Médio',
                        'GRANDE': 'Grande',
                      };
                      final isSelected = _porte == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _porte = p),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE8622A)
                                  : const Color(0xFFF5F0EB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              labels[p]!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Localização
                  const _Label('Localização'),
                  const SizedBox(height: 8),
                  _Field(
                    controller: _localizacaoController,
                    hint: 'Ex: São Paulo, SP',
                  ),
                  const SizedBox(height: 16),

                  // Descrição
                  const _Label('Descrição *'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _descricaoController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                      decoration: const InputDecoration(
                        hintText:
                            'Conte sobre a personalidade e história do pet...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFBBB3AA),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Saúde
                  const _Label('Saúde'),
                  const SizedBox(height: 4),
                  _SwitchTile(
                    label: 'Vacinado',
                    value: _vacinado,
                    onChanged: (v) => setState(() => _vacinado = v),
                  ),
                  _SwitchTile(
                    label: 'Castrado',
                    value: _castrado,
                    onChanged: (v) => setState(() => _castrado = v),
                  ),
                  const SizedBox(height: 20),

                  // Temperamento
                  const _Label('Temperamento'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _temperamentosOpcoes.map((t) {
                      final isSelected = _temperamentos.contains(t);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (isSelected) {
                            _temperamentos.remove(t);
                          } else {
                            _temperamentos.add(t);
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8622A)
                                : const Color(0xFFF5F0EB),
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? null
                                : Border.all(color: const Color(0xFFE0D9D1)),
                          ),
                          child: Text(
                            _temperamentosLabels[t] ?? t,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // Botão cadastrar
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _enviando ? null : _cadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8622A),
                        disabledBackgroundColor: const Color(
                          0xFFE8622A,
                        ).withOpacity(0.5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _enviando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cadastrar Pet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('🐾', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBB3AA)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final Map<String, String> labels;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 13, color: Color(0xFFBBB3AA)),
          ),
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
          items: items
              .map(
                (i) => DropdownMenuItem(value: i, child: Text(labels[i] ?? i)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFE8622A),
        ),
      ],
    );
  }
}
