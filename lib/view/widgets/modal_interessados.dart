import 'package:adota_pets_mobile/modelo/interesse_modelo.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../modelo/interessado_modelo.dart';
import '../../modelo/pet_modelo.dart';
import '../../services/interesse_service.dart';

class ModalInteressados extends StatefulWidget {
  final PetModelo pet;
  final AuthProvider auth;

  const ModalInteressados({required this.pet, required this.auth});

  @override
  State<ModalInteressados> createState() => _InteressadosModalState();
}

class _InteressadosModalState extends State<ModalInteressados> {
  late Future<_InteressadosData> _futureData;
  final InteresseService _service = InteresseService();
  final Set<String> _aprovando = {}; // ids em processo de aprovação

  @override
  void initState() {
    super.initState();
    _futureData = _carregarDados();
  }

  Future<_InteressadosData> _carregarDados() async {
    final results = await Future.wait([
      _service.listarInteressados(
        petId: widget.pet.id,
        token: widget.auth.token,
      ),
      _service.buscarInteressesPorPet(
        petId: widget.pet.id,
        token: widget.auth.token,
      ),
    ]);

    final interessados = results[0] as List<InteressadoModelo>;
    final interesses = results[1] as List<InteresseModelo>;

    // Monta mapa: interessadoId → interesseId
    final mapaInteresses = {
      for (final i in interesses) i.interessadoId: i.interesseId,
    };

    return _InteressadosData(
      interessados: interessados,
      mapaInteresses: mapaInteresses,
    );
  }

  Future<void> _aprovar(String novoDonoId) async {
    setState(() => _aprovando.add(novoDonoId));
    try {
      await _service.aprovarAdocao(
        petId: widget.pet.id,
        novoDonoId: novoDonoId,
        token: widget.auth.token,
      );
      if (mounted) {
        Navigator.pop(context); // fecha o modal
        Navigator.pop(context); // volta do detalhe
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.pet.nome} foi adotado com sucesso! 🎉'),
            backgroundColor: const Color(0xFFE8622A),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao aprovar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _aprovando.remove(novoDonoId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interessados em ${widget.pet.nome}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white12),

          // Lista
          Flexible(
            child: FutureBuilder<_InteressadosData>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: Color(0xFFE8622A)),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Erro ao carregar',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                final lista = snapshot.data!.interessados;
                final mapa = snapshot.data!.mapaInteresses;

                if (lista.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Nenhum interessado ainda',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  );
                }

                // Subtítulo com contagem
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${lista.length} ${lista.length == 1 ? 'pessoa interessada' : 'pessoas interessadas'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final interessado = lista[i];
                          final aprovando = _aprovando.contains(interessado.id);
                          final inicial = interessado.nome.isNotEmpty
                              ? interessado.nome[0].toUpperCase()
                              : '?';

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFE8622A,
                                    ).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      inicial,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE8622A),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Nome e email
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        interessado.nome,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        interessado.email,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Botão Aprovar
                                ElevatedButton.icon(
                                  onPressed: aprovando
                                      ? null
                                      : () => _aprovar(interessado.id),
                                  icon: aprovando
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.check, size: 16),
                                  label: const Text(
                                    'Aprovar',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE8622A),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InteressadosData {
  final List<InteressadoModelo> interessados;
  final Map<String, String> mapaInteresses; // interessadoId → interesseId

  const _InteressadosData({
    required this.interessados,
    required this.mapaInteresses,
  });
}
