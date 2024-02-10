import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intolergy/domain/Auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

// Esto permite el acceso directo a la instancia de FirebaseAuth desde cualquier clase

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = AuthService.authInstance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _user != null ? _userInfo() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return Center(
        child: SizedBox(
      height: 50,
      child: SignInButton(Buttons.google,
          text: "Unete con Google",
          onPressed: _handleGoogleSignIn,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20.0), // Ajusta el valor según sea necesario
          )),
    ));
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
              ),
            ),
          ),
          Text(_user!.email!),
          MaterialButton(
            color: Colors.red,
            child: const Text("Sign Out"),
            onPressed: _auth.signOut,
          )
        ],
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(_googleAuthProvider);

      // Después de la autenticación, el usuario está disponible en _auth.currentUser
      if (_auth.currentUser != null) {
        bool userExists = await _checkIfUserExists(_auth.currentUser!.uid);

        if (!userExists) {
          // Si el usuario no existe en Firestore, añade los datos de alergias e intolerancias
          agregarDatosAFirestore(_auth.currentUser!);
          // Navega a la pantalla de Intolerancias y Alergias
          Navigator.pushReplacementNamed(context, '/alergias');
        } else {
          // Si el usuario ya existe, navega a la pantalla de inicio
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<bool> _checkIfUserExists(String uid) async {
    // Verificar si el usuario ya existe en Firestore

    bool enc = false;

    final elem = await _firestore.collection('usuarios');

    // Obtener todos los documentos de la colección
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await elem.get();

    // Recorrer los documentos y mostrar solo el campo 'uid'
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      // Acceder directamente al campo 'uid'
      String useruid = documentSnapshot['uid'] ??
          ''; // Puedes ajustar este valor predeterminado según tus necesidades

      if (useruid == uid) {
        enc = true;
        break; // Sale del bucle si encuentra el usuario
      }
    }

    return enc;
  }

  void agregarDatosAFirestore(User user) async {
    print('Entro a guardar');

    // Obtén una referencia a la colección
    CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');

    // Añade un documento a la colección con datos específicos
    await usuarios.add({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoURL,
    });

    // Puedes agregar más documentos según sea necesario

    print('Datos añadidos a Firestore');
  }
}
