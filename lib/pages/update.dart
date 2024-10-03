import 'dart:convert'; // Para codificação em Base64
import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Para selecionar imagens

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> vehicleData; // Receberá os dados do veículo

  UpdatePage({required this.vehicleData});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late bool isAvailable;
  late TextEditingController modelController;
  late TextEditingController categoryController;
  late TextEditingController rentalValueController;
  late String? base64Image; // Armazenará a imagem em formato Base64

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os dados do veículo
    modelController = TextEditingController(text: widget.vehicleData['modelo']);
    categoryController =
        TextEditingController(text: widget.vehicleData['categoria']);
    rentalValueController = TextEditingController(
      text: widget.vehicleData['valor']?.toString() ??
          '0.00', // Certifica-se que seja uma string
    );

    isAvailable = widget.vehicleData['disponivel'];
    base64Image = widget.vehicleData['imagem']; // Carrega a imagem existente
  }

  @override
  void dispose() {
    modelController.dispose();
    categoryController.dispose();
    rentalValueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        base64Image = base64Encode(imageBytes); // Codifica a imagem em Base64
      });
    }
  }

  void _saveChanges() {
    // Aqui você pode implementar a lógica para salvar as alterações
    Map<String, dynamic> updatedVehicleData = {
      'modelo': modelController.text,
      'categoria': categoryController.text,
      'valor': double.tryParse(rentalValueController.text) ?? 0.00,
      'disponivel': isAvailable,
      'imagem': base64Image,
    };

    // Aqui você pode enviar updatedVehicleData para o seu backend ou gerenciador de estado

    Navigator.pop(context, updatedVehicleData); // Retorna os dados atualizados
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
              // Título da página
              Text(
                'Altere as informações de um veículo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Campos de texto para modelo, categoria e valor do aluguel
              TextField(
                controller: modelController,
                decoration: InputDecoration(
                  labelText: 'Digite o modelo',
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
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Digite a categoria',
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
                controller: rentalValueController,
                keyboardType: TextInputType.number,
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
                    onChanged: (bool? newValue) {
                      setState(() {
                        isAvailable =
                            newValue ?? false; // Atualiza a disponibilidade
                      });
                    },
                  ),
                  Text('Está disponível.'),
                ],
              ),
              SizedBox(height: 20),

              // Campo de upload de imagem
              GestureDetector(
                onTap: _pickImage, // Chama a função para selecionar a imagem
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
                      base64Image != null
                          ? Image.memory(
                              base64Decode(
                                  base64Image!), // Exibe a imagem decodificada
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
                        'Altere a imagem do veículo aqui.',
                        style: TextStyle(color: Color(0xFF285E30)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botões de Cancelar e Salvar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Lógica para cancelar
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
                      onPressed:
                          _saveChanges, // Lógica para salvar as alterações
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF285E30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          Text('Salvar', style: TextStyle(color: Colors.white)),
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
