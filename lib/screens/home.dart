import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String scannedCode = "No se ha escaneado ningún código";

  Future<void> scanBarcode() async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // color del botón de escaneo (opcional)
        'Cancelar', // texto del botón de cancelar (opcional)
        false, // desactivar la animación del escáner (opcional)
        ScanMode.BARCODE, // modo de escaneo (código de barras por defecto)
      );
      setState(() {
        scannedCode = "Código leído: $result";
      });
    } catch (e) {
      setState(() {
        scannedCode = "Error al escanear el código";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scannedCode,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 101, 149, 103),
                ),
              ),
              onPressed: () => scanBarcode(),
              child: const Text('Escanear Código de Barras',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
