import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:base_peliculas/auth_page.dart';
import 'package:base_peliculas/admin_page.dart';
import 'package:base_peliculas/catalogo_page.dart';
import 'auth_service.dart';



class AuthWrapper extends StatefulWidget{
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return const AuthPage();
        }

        final user = snapshot.data!;
        return FutureBuilder<bool>(
          future: AuthService().isAdmin(user.uid),
          builder: (context, roleSnapshot) {
            print("Es admin: ${roleSnapshot.data}");
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (roleSnapshot.hasError) {
              return const Scaffold(body: Center(child: Text('Error cargando rol')));
            }

            if (roleSnapshot.data == true) {
              return const AdminPage(); // <- Asegúrate de importar esta página
            } else {
              return const CatalogoPage(); // <- Asegúrate de importar esta página
            }
          },
        );
      },
    );
  }
}