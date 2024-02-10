import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intolergy/domain/Auth.dart';

class IntoleranciasAlergiasScreen extends StatefulWidget {
  const IntoleranciasAlergiasScreen({Key? key}) : super(key: key);

  @override
  _IntoleranciasAlergiasScreenState createState() =>
      _IntoleranciasAlergiasScreenState();
}

class _IntoleranciasAlergiasScreenState
    extends State<IntoleranciasAlergiasScreen> {
  final FirebaseAuth _auth = AuthService.authInstance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool alergiaHuevo = false;
  bool alergiaLeche = false;
  bool alergiaPescado = false;
  bool alergiaMarisco = false;
  bool alergiaFrutosSecos = false;
  bool alergiaLegumbres = false;
  bool alergiaCereales = false;
  bool alergiaVerduras = false;
  bool alergiaFrutas = false;
  bool intoleranciaGluten = false;
  bool intoleranciaLactosa = false;
  bool intoleranciaHistamina = false;

  Future<void> _addAlergiasIntoleranciasData(User user) async {
    try {
      // Crear una colección llamada 'alergiasIntolerancias'
      CollectionReference alergiasIntolerancias =
          await _firestore.collection('alergiasIntolerancias');

      // Añadir documentos a la colección con los campos específicos
      await alergiasIntolerancias.add({
        'alergia_al_huevo': alergiaHuevo,
        'alergia_a_la_leche': alergiaLeche,
        'alergia_a_pescado': alergiaPescado,
        'alergia_a_marisco': alergiaMarisco,
        'alergia_a_frutos_secos': alergiaFrutosSecos,
        'alergia_a_legumbres': alergiaLegumbres,
        'alergia_a_cereales': alergiaCereales,
        'alergia_a_verduras': alergiaVerduras,
        'alergia_a_frutas': alergiaFrutas,
        'intolerancia_al_gluten': intoleranciaGluten,
        'intolerancia_a_la_lactosa': intoleranciaLactosa,
        'intolerancia_a_histamina': intoleranciaHistamina,
        'uid': _auth.currentUser!.uid
      });

      print('Datos de alergias e intolerancias añadidos a Firestore');
      Navigator.pushReplacementNamed(
          context, '/home'); // Reemplazar la ruta actual con la nueva ruta
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intolerancias y Alergias'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSwitchTile(
                'Alergia al huevo',
                alergiaHuevo,
                (value) {
                  setState(() {
                    alergiaHuevo = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia a la leche',
                alergiaLeche,
                (value) {
                  setState(() {
                    alergiaLeche = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia al pescado',
                alergiaPescado,
                (value) {
                  setState(() {
                    alergiaPescado = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia al marisco',
                alergiaMarisco,
                (value) {
                  setState(() {
                    alergiaMarisco = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia a frutos secos',
                alergiaFrutosSecos,
                (value) {
                  setState(() {
                    alergiaFrutosSecos = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia a legumbres',
                alergiaLegumbres,
                (value) {
                  setState(() {
                    alergiaLegumbres = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia a cereales',
                alergiaCereales,
                (value) {
                  setState(() {
                    alergiaCereales = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia a verduras',
                alergiaVerduras,
                (value) {
                  setState(() {
                    alergiaVerduras = value;
                  });
                },
              ),
              buildSwitchTile(
                'Alergia a frutas',
                alergiaFrutas,
                (value) {
                  setState(() {
                    alergiaFrutas = value;
                  });
                },
              ),
              buildSwitchTile(
                'Intolerancia al gluten',
                intoleranciaGluten,
                (value) {
                  setState(() {
                    intoleranciaGluten = value;
                  });
                },
              ),
              buildSwitchTile(
                'Intolerancia a la lactosa',
                intoleranciaLactosa,
                (value) {
                  setState(() {
                    intoleranciaLactosa = value;
                  });
                },
              ),
              buildSwitchTile(
                'Intolerancia a la histamina',
                intoleranciaHistamina,
                (value) {
                  setState(() {
                    intoleranciaHistamina = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 101, 149, 103),
                    ),
                  ),
                  onPressed: () {
                    // Llamar a la función para guardar los datos
                    _addAlergiasIntoleranciasData(_auth.currentUser!);
                  },
                  child: Text('Guardar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: const Color.fromARGB(255, 101, 149, 103),
      // Establece el color cuando el switch está activo
    );
  }
}
