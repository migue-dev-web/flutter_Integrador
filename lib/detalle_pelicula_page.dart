import 'package:flutter/material.dart';

class DetallePeliculaPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const DetallePeliculaPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['titulo'] ?? 'Detalle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(movie['imagen'] ?? '', height: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text('Título: ${movie['titulo']}', style: const TextStyle(fontSize: 18)),
            Text('Año: ${movie['anio']}', style: const TextStyle(fontSize: 16)),
            Text('Director: ${movie['director']}', style: const TextStyle(fontSize: 16)),
            Text('Género: ${movie['genero']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Sinopsis:\n${movie['sinopsis']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver al Catálogo'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
