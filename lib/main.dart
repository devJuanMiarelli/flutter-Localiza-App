import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/read.dart';
import 'package:projeto_flutter/services/service.dart'
    as service; // Prefixo adicionado

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final service.VeiculoService veiculoService =
      service.VeiculoService(); // Use o prefixo aqui

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localiza App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ReadPage(veiculoService: veiculoService),
    );
  }
}
