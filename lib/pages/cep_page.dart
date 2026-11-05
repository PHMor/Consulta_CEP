import 'package:consulta_cep/service/cep_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CepPage extends StatefulWidget {
  const CepPage({super.key});

  @override
  State<CepPage> createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  final TextEditingController cepController = TextEditingController();
  Map<String, dynamic>? endereco;
  bool isLoading = false;
  String? mensagem;

  Future<void> buscarCep() async {
    final cep = cepController.text.replaceAll(RegExp(r'\D'), '');
    FocusScope.of(context).unfocus();
    if (cep.length != 8) {
      setState(() {
        mensagem = 'Digite um CEP com 8 números.';
        endereco = null;
      });
      return;
    }
    setState(() {
      isLoading = true;
      mensagem = null;
      endereco = null;
    });
    try {
      final resultado = await CepService.buscarCep(cep);
      if (!mounted) return;
      setState(() {
        endereco = resultado;
        if (resultado == null) {
          mensagem = 'CEP não encontrado. Confira os números.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        mensagem =
            'Não foi possível consultar. Verifique sua conexão e tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  Widget campoEndereco(String titulo, String chave) {
    final valor = endereco![chave]?.toString() ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
          ),
          Text(
            valor.isEmpty ? 'Não informado' : valor,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar endereço')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Qual CEP você quer consultar?',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Informe os 8 números do CEP.',
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cepController,
              enabled: !isLoading,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              onSubmitted: (_) => buscarCep(),
              decoration: const InputDecoration(
                labelText: 'CEP',
                hintText: 'Ex.: 01001000',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: isLoading ? null : buscarCep,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  isLoading ? 'Consultando...' : 'Buscar CEP',
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (mensagem != null)
              Text(
                mensagem!,
                style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 16),
              ),
            if (endereco != null)
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Endereço encontrado',
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      campoEndereco('CEP', 'cep'),
                      campoEndereco('Rua', 'logradouro'),
                      campoEndereco('Bairro', 'bairro'),
                      campoEndereco('Cidade', 'localidade'),
                      campoEndereco('Estado', 'uf'),
                      campoEndereco('Complemento', 'complemento'),
                      campoEndereco('DDD', 'ddd'),
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
