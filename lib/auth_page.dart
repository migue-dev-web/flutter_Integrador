import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();

}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> handleAuth()async{
    final email = emailController.text;
    final password = passwordController.text;

    AuthService authService = AuthService();

    if ( isLogin){
      await authService.signIn(email, password);
    }else{
      await authService.register(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin?'Iniciar Sesion':'Rgistrarse'),),
      body: Padding(padding: const EdgeInsets.all(16.0),
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: handleAuth, child: Text(
              isLogin ? 'Iniciar Sesion ': 'Registrarse'
            ),
            ),
            TextButton(onPressed: (){
              setState(() {
                isLogin = !isLogin;
              });
            }, child: Text(isLogin? 'No tienes cuenta? registrate': 'Ya tienes una cuenta? Inicia sesion'))
          ],
      ),
      ),

    );
  }
}