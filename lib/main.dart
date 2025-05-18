
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:base_peliculas/auth_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvendo',
      home: const AuthWrapper(),
    );
  }
}



class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Text('Bienvenido, ${FirebaseAuth.instance.currentUser?.email ?? 'Usuario'}',
        style: const  TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}