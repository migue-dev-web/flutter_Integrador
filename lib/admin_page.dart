
import 'package:base_peliculas/database_service.dart';
import 'package:flutter/material.dart';
import 'package:base_peliculas/auth_wrapper.dart';
import 'package:base_peliculas/catalogo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>{
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _sinopsisController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();

  final DatabaseService _dbService =DatabaseService();
  Future<void> _guardarPelicula() async {
    if (_formKey.currentState!.validate()) {
      final peliculaData = {
        'titulo': _tituloController.text.trim(),
        'anio': _anioController.text.trim(),
        'director': _directorController.text.trim(),
        'genero': _generoController.text.trim(),
        'sinopsis': _sinopsisController.text.trim(),
        'imagen': _imagenController.text.trim(),
      };


      try {

        final path = 'movies/${peliculaData['titulo']}';
        await _dbService.create(path: path, data: peliculaData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Película guardada correctamente')),
        );


        _tituloController.clear();
        _anioController.clear();
        _directorController.clear();
        _generoController.clear();
        _sinopsisController.clear();
        _imagenController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar película: $e')),
        );
      }

    }
  }

  Future<void> _borrarPelicula() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el título de la película a borrar')),
      );
      return;
    }

    try {
      final path = 'movies/$titulo';
      await _dbService.delete(path: path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película borrada correctamente')),
      );

      _tituloController.clear();
      _anioController.clear();
      _directorController.clear();
      _generoController.clear();
      _sinopsisController.clear();
      _imagenController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al borrar película: $e')),
      );
    }
  }
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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menú Admin', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Catálogo de Películas'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CatalogoPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => (value == null || value.isEmpty) ? 'Ingresa el título' : null,
              ),
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el año';
                  if (int.tryParse(value) == null) return 'Ingresa un año válido';
                  return null;
                },
              ),
              TextFormField(
                controller: _directorController,
                decoration: const InputDecoration(labelText: 'Director'),
                validator: (value) => (value == null || value.isEmpty) ? 'Ingresa el director' : null,
              ),
              TextFormField(
                controller: _generoController,
                decoration: const InputDecoration(labelText: 'Género'),
                validator: (value) => (value == null || value.isEmpty) ? 'Ingresa el género' : null,
              ),
              TextFormField(
                controller: _sinopsisController,
                decoration: const InputDecoration(labelText: 'Sinopsis'),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty) ? 'Ingresa la sinopsis' : null,
              ),
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(labelText: 'URL Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el link de la imagen';
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.isAbsolute) return 'Ingresa un link válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarPelicula,
                child: const Text('Guardar Película'),
              ),
              ElevatedButton(
                onPressed: _borrarPelicula,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Borrar Película'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}