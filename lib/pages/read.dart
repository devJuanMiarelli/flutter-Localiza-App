import 'dart:convert'; // Importar para decodificar a string Base64
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/create.dart';
import 'package:projeto_flutter/pages/delete.dart';
import 'package:projeto_flutter/pages/update.dart';
import 'package:projeto_flutter/services/service.dart';

class ReadPage extends StatefulWidget {
  final VeiculoService veiculoService;

  ReadPage(
      {required this.veiculoService}); // Passa a instância do VeiculoService

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  bool _isSidebarOpen = false;
  Color _menuColor = Color(0xFF285E30);
  Color _registerColor = Color(0xFF285E30);
  List<Map<String, dynamic>> vehicles = []; // Array de veículos
  String errorMessage = ''; // Mensagem de erro

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    try {
      // Cast explícito para garantir que seja uma lista de Map<String, dynamic>
      List<Map<String, dynamic>> fetchedVehicles =
          (await widget.veiculoService.fetchVehicles())
              .cast<Map<String, dynamic>>();

      setState(() {
        vehicles = fetchedVehicles;
        errorMessage = ''; // Limpa a mensagem de erro
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar veículos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/localiza_logo.png',
          width: 320,
          height: 100,
        ),
        backgroundColor: Color(0xFF285E30),
        leading: IconButton(
          icon: Icon(
            Icons.menu_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isSidebarOpen = !_isSidebarOpen;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          buildVehicleList(),
          if (_isSidebarOpen) buildSidebarOverlay(),
        ],
      ),
    );
  }

  Widget buildSidebarOverlay() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 250,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF285E30),
              border: Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => closeSidebar(),
                    child: MouseRegion(
                      onEnter: (_) => setState(() {
                        _menuColor = Color(0xFF3F8F3F);
                      }),
                      onExit: (_) => setState(() {
                        _menuColor = Color(0xFF285E30);
                      }),
                      child: Material(
                        color: _menuColor,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                          child: Text(
                            'Menu',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.6 * 250,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(top: 4, bottom: 8),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePage(),
                      ),
                    );
                  },
                  child: MouseRegion(
                    onEnter: (_) => setState(() {
                      _registerColor = Color(0xFF3F8F3F);
                    }),
                    onExit: (_) => setState(() {
                      _registerColor = Color(0xFF285E30);
                    }),
                    child: Material(
                      color: _registerColor,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        child: Text(
                          'Cadastrar veículos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
  }

  Widget buildVehicleList() {
    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];

        // Verifica se a imagem é válida antes de decodificá-la
        Uint8List? imageBytes;
        try {
          imageBytes = base64Decode(vehicle['imagem']);
        } catch (e) {
          imageBytes = null; // Trate o erro aqui, se necessário
        }

        return Card(
          margin: EdgeInsets.all(10),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Exibe a imagem usando Image.memory
                imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        width: 120,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 120,
                        height: 60,
                        color: Colors.grey,
                        child: Center(child: Text('Imagem inválida')),
                      ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['categoria']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        vehicle['modelo']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            vehicle['valor']!,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' a diária',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePage(
                                  vehicleData:
                                      vehicle, // Passe os dados do veículo aqui
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeletePage(
                                  vehicleData:
                                      vehicle, // Passe os dados do veículo aqui
                                  veiculoService: widget
                                      .veiculoService, // Passe a instância do serviço
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF285E30), // Cor verde da navbar
                      ),
                      onPressed: () {
                        // Botão sem função
                      },
                      child: Text(
                        'Alugar',
                        style:
                            TextStyle(color: Colors.white), // Texto em branco
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
