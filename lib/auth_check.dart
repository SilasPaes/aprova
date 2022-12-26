//import 'package:mktmanager/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'telalogin.dart';
import 'wait.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return const TelaLogin();
    } else {
      return const SplashWait();
    }
    //return ClienteHomePage();
    // return AuthCheck2();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => CadastraCliente()));
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}