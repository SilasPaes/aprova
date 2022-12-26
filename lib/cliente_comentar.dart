import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cor.dart';

class ClienteComentar extends StatefulWidget {
  const ClienteComentar(
      {Key? key,
      required this.uid,
      required this.idpost,
      required this.editpost})
      : super(key: key);
  final String uid;
  final String idpost;
  final String editpost;

  @override
  // ignore: no_logic_in_create_state
  State<ClienteComentar> createState() => _ClienteComentarState(
        uid: uid,
        idpost: idpost,
        editpost: editpost,
      );
}

class _ClienteComentarState extends State<ClienteComentar> {
  _ClienteComentarState(
      {required this.uid,
      required this.idpost,
      required this.editpost //this.formKey
      });

  final String idpost;
  final String uid;
  final String editpost;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final idPostController = TextEditingController();
  final comentPostController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  //final bool _isSubmitting = false;
  bool uploading = false;
  final datacontrolleredit = TextEditingController();

  @override
  initState() {
    //PreferenciaTema.setTema();
    idPostController.text = widget.idpost;
    //comentPostController.text = widget.editpost;
    super.initState();
  }

  // ignore: unused_field
  final bool _checkbox1 = false;
  String checkum = '';
  // ignore: unused_field
  final bool _checkbox2 = false;
  String checkdois = '';
  // ignore: unused_field
  final bool _checkbox3 = false;
  String checktres = '';
  // ignore: unused_field
  final bool _checkbox4 = false;
  String checkquatro = '';
  // ignore: unused_field
  final bool _checkbox5 = false;
  String checkcinco = '';

  late DateTime date;

  String getText() {
    // ignore: unnecessary_null_comparison
    if (date == null) {
      return 'Escolha uma data';
    } else {
      //return DateFormat('yyyy MM dd', 'pt_BR').format(date);
      return '${date.year}/${date.month}/${date.day}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
                primary: Colors.black,
                //background: marrom,
                //surface: Colors.orange,
                onPrimary: Colors.white,
                onSurface: Colors.black),
            //primaryColor: cinza,
          ),
          child: Center(child: child)),
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
      datacontrolleredit.text =
          DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final User? user = auth.currentUser;
    //final uids = user?.uid;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: corAppBar,
          title: const Text('Comente as alterações...'),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () async {
                  /*    if (comentPostController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Preencha o campo obrigatório",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: corFlutterToast,
                        timeInSecForIosWeb: 6,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  } else { */
                  await FirebaseFirestore.instance
                      .collection('Clientes')
                      .doc(uid)
                      .collection("Posts")
                      .doc(idpost)
                      .update({
                    'correcoes1': checkum,
                    'correcoes2': checkdois,
                    'correcoes3': checktres,
                    'correcoes4': checkquatro,
                    'correcoes5': checkcinco,
                    'correcoes6': comentPostController.text,
                  }).whenComplete(() => Navigator.of(context).pop());
                  //   }
                },
                child: const Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                reverse: false,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                             const Text(
                              'Diga-nos o que precisamos corrigir neste post :',
                              style: TextStyle(fontSize: 24),
                            ),
                             const Text(
                              'Exemplo de uma correção:',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      /* CheckboxListTile(
                        value: _checkbox1,
                        checkColor: Colors.white,
                        activeColor: cinza,
                        tristate: false,
                        title: const Text(
                          "Alterar tema",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _checkbox1 = val;
                            checkum = 'Alterar assunto';
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //Leading Checkbox Icon
                      ),
                      CheckboxListTile(
                        value: _checkbox2,
                        checkColor: Colors.white,
                        activeColor: cinza,
                        tristate: false,
                        title: const Text(
                          "Alterar data da publicação",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _checkbox2 = val;
                            checkdois = 'Alterar data da publicação';
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //Leading Checkbox Icon
                      ),
                      CheckboxListTile(
                        value: _checkbox3,
                        checkColor: Colors.white,
                        activeColor: cinza,
                        tristate: false,
                        title: const Text(
                          "Erros ortográficos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _checkbox3 = val;
                            checktres = 'Erros ortográficos';
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //Leading Checkbox Icon
                      ),
                      CheckboxListTile(
                        value: _checkbox4,
                        checkColor: Colors.white,
                        activeColor: cinza,
                        tristate: false,
                        title: const Text(
                          "Alterar imagens",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _checkbox4 = val;
                            checkquatro = 'Alterar imagens';
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //Leading Checkbox Icon
                      ),
                      CheckboxListTile(
                        value: _checkbox5,
                        checkColor: Colors.white,
                        activeColor: cinza,
                        tristate: false,
                        title: const Text(
                          "Alterar texto",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _checkbox5 = val;
                            checkcinco = 'Alterar texto';
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //Leading Checkbox Icon
                      ),
                       */
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                bottom), //pro texto não ficar atras do teclado bottom
                        child: TextField(
                          controller: comentPostController,
                          decoration: const InputDecoration(
                            hintText: 'Outras correções:',
                            labelText: 'Outras correções:',
                            //errorText: _validate ? 'Campo obrigatório' : null
                          ),
                          autofocus: false,
                          // focusNode: _focusnode,
                          //minLines: 1,
                          //maxLength: 4,
                          maxLines: null,
                          // controller: _newreplycontroller,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ))));
  }
}
