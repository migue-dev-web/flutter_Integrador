import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:base_peliculas/auth_wrapper.dart';
import 'package:firebase_database/firebase_database.dart';

import 'detalle_pelicula_page.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthWrapper()),
                  (route) => false,
            );
          }, icon: const Icon(Icons.logout)),

        ],
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map,
            );

            final movies = data.entries.map((entry) {
              final movie = Map<String, dynamic>.from(entry.value);
              return {
                'id': entry.key,
                'titulo': movie['titulo'] ?? '',
                'imagen': movie['imagen'] ?? '',
                'anio': movie['anio'] ?? '',
                'director': movie['director'] ?? '',
                'genero': movie['genero'] ?? '',
                'sinopsis': movie['sinopsis'] ?? '',
              };
            }).toList();

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => DetallePeliculaPage(movie: movie),
                    ));
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            movie['imagen']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['titulo']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No hay películas disponibles.'));
        },
      ),
    );
  }
}