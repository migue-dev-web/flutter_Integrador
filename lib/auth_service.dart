import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
          return result.user;

    }catch(e){
      print('Error en inicio de sesion: $e');
      return null;
    }
  }

  Future<User?> register(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
    }catch(e){
      print('Error en registro: $e');
      return null;
    }
  }
  Future<void> signOut() async{
    await _auth.signOut();
  }

  Future<bool> isAdmin(String uid) async {
    try {
      final ref = FirebaseDatabase.instance.ref('users/$uid');
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        print('No existe usuario con uid: $uid');
        return false;
      }

      print('Snapshot value: ${snapshot.value}');

      final role = snapshot.child('role').value;
      print('Rol encontrado: $role');


      return role == 'admin';
    } catch (e) {
      print('Error al verificar rol: $e');
      return false;
    }
  }

}