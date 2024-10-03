import 'dart:convert'; // Importa a biblioteca para decodificação Base64
import 'package:flutter/material.dart';
import 'package:projeto_flutter/services/service.dart'; // Importe o service

class DeletePage extends StatelessWidget {
  final Map<String, dynamic> vehicleData; // Receberá os dados do veículo
  final VeiculoService veiculoService; // Adiciona uma instância do serviço

  DeletePage({required this.vehicleData, required this.veiculoService});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = vehicleData['disponivel'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'assets/images/localiza_logo.png',
          width: 320,
          height: 100,
        ),
        backgroundColor: Color(0xFF285E30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Exclua um veículo cadastrado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: vehicleData['modelo']),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF285E30), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF285E30), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller:
                    TextEditingController(text: vehicleData['categoria']),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF285E30), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF285E30), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: TextEditingController(
                  text: vehicleData['valor']?.toString() ?? '0.00',
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'R\$ Valor da diária',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF285E30), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF285E30), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isAvailable,
                    onChanged: null,
                  ),
                  Text('Está disponível.'),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Lógica para visualizar a imagem em tela cheia
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF285E30), width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vehicleData['imagem'] != null
                          ? Image.memory(
                              base64Decode(vehicleData['imagem']),
                              width: 100,
                              height: 100,
                            )
                          : Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Color(0xFF285E30),
                            ),
                      SizedBox(height: 8),
                      Text(
                        'Visualize a imagem do veículo aqui.',
                        style: TextStyle(color: Color(0xFF285E30)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF285E30), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Color(0xFF285E30)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await veiculoService.deleteVeiculo(vehicleData['id']);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Veículo deletado com sucesso.')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao deletar veículo: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF285E30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Deletar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
