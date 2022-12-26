// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:aprova/cor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cadastracliente.dart';
import 'cliente_tela_analisar.dart';
import 'cliente_tela_aprovados.dart';
import 'cliente_tela_reprovados.dart';

class ClienteHomePage extends StatefulWidget {
  const ClienteHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClienteHomePageState createState() => _ClienteHomePageState();
}

class _ClienteHomePageState extends State<ClienteHomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

bool sairdoapp = false;
  Future<bool?> showConfirmaSairdoApp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja sair do App?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              OutlinedButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                      Navigator.pop(context, true);
                    } else if (Platform.isIOS) {
                      Navigator.pop(context, true);
                      exit(0);
                    }
                  },
                  child: const Text('Sair')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!sairdoapp) {
          final confirmaSairdoApp = await showConfirmaSairdoApp();
          return confirmaSairdoApp ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: corAppBar,
          title: const Text("Home"),
          centerTitle: false,
          actions: <Widget>[
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                icon: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return [
                    /*  PopupMenuItem<int>(
                      value: 0,
                      child: Text("Cadastrar"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Admin"),
                    ), */
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Logout"),
                    ),
                  ];
                },
                onSelected: (value) async {
                  if (value == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CadastraCliente()));
                  } else if (value == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CadastraCliente()));
                  } else if (value == 2) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Atenção"),
                            content: const Text("Você deseja sair da sua conta?"),
                            actions: [
                              TextButton(
                                //cancelar button
                                child: const Text("Cancelar"),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              TextButton(
                                //enviar button
                                child: const Text("Sim"),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, false);
                                },
                              )
                            ],
                          );
                        });
                  }
                }),
          ],
        ),
        body: PageView(
          controller: pc,
          onPageChanged: setPaginaAtual,
          children: [
            const ClienteTelaAnalisar(),
            const ClienteTelaAprovados(),
            const ClienteTelaReprovados(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: paginaAtual,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_top), label: 'Analisar'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.check,
                  color: Colors.green[700],
                ),
                label: 'Aprovados'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.clear_outlined,
                  color: Colors.red[700],
                ),
                label: 'Reprovados'),
            const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Conta'),
          ],
          onTap: (pagina) {
            pc.animateToPage(
              pagina,
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
          // backgroundColor: Colors.grey[100],
        ),
      ),
    );
  }
}
