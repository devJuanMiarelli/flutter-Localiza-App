import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_flutter/services/service.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  bool isAvailable = false;
  Uint8List? _selectedImageBytes;
  String? _imageName;
  String? _imageBase64; // Para armazenar a imagem em Base64

  final VeiculoService veiculoService =
      VeiculoService(); // Instância do serviço

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _imageName = pickedFile.name;

        // Converter a imagem para Base64
        _imageBase64 = base64Encode(_selectedImageBytes!);
      });
    }
  }

  Future<void> _saveVehicle() async {
    if (_modeloController.text.isEmpty ||
        _categoriaController.text.isEmpty ||
        _valorController.text.isEmpty ||
        _selectedImageBytes == null) {
      // Mostra um snackbar ou um dialog se os campos obrigatórios não estiverem preenchidos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    // Cria o veículo usando o serviço
    try {
      // Obter a data e hora atual no formato que sua API espera
      DateTime now = DateTime.now();
      String formattedDate = now.toIso8601String();

      print('Modelo: ${_modeloController.text}');
      print('Categoria: ${_categoriaController.text}');
      print('Valor: ${_valorController.text}');
      print('Disponível: $isAvailable');

      await veiculoService.createVeiculo({
        'modelo': _modeloController.text,
        'categoria': _categoriaController.text,
        'valor': _valorController.text,
        'disponivel': isAvailable,
        'imagem': _imageBase64,
        'dataHora': formattedDate,
      });

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veículo cadastrado com sucesso!')),
      );

      // Volta para a tela anterior
      Navigator.pop(context);
    } catch (e) {
      // Mostra um snackbar ou um dialog se houver um erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar veículo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Cadastre um novo veículo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              TextField(
                controller: _modeloController,
                decoration: InputDecoration(
                  labelText: 'Digite o modelo',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF285E30),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF285E30),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _categoriaController,
                decoration: InputDecoration(
                  labelText: 'Digite a categoria',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF285E30),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF285E30),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'R\$ Valor da diária',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF285E30),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF285E30),
                      width: 2,
                    ),
                  ),
                ),
                keyboardType:
                    TextInputType.number, // Para aceitar apenas números
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: isAvailable,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isAvailable = newValue!; // Atualiza a disponibilidade
                        print(
                            'Disponível: $isAvailable'); // Debugging para verificar o valor
                      });
                    },
                  ),
                  Text('Está disponível.'),
                ],
              ),

              SizedBox(height: 20),

              // Campo de upload de imagem
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF285E30),
                    width: 2,
                  ),
                  color: _selectedImageBytes == null
                      ? Colors.transparent
                      : Colors.grey[300],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.upload,
                        size: 50,
                        color: Color(0xFF285E30),
                      ),
                      onPressed: _pickImage,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _selectedImageBytes == null
                          ? 'Faça upload da imagem do veículo aqui.'
                          : 'Imagem selecionada.',
                      style: TextStyle(
                        color: Color(0xFF285E30),
                      ),
                    ),
                    if (_selectedImageBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.memory(
                              _selectedImageBytes!,
                              width: 120,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _imageName ?? 'Nome da Imagem',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
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
                        style: TextStyle(
                          color: Color(0xFF285E30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF285E30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
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
