import 'package:aprova/cliente_editar_texto.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'cor.dart';

class ClienteTelaAnalisar extends StatefulWidget {
  const ClienteTelaAnalisar({super.key});

  @override
  State<ClienteTelaAnalisar> createState() => _ClienteTelaAnalisar();
}

class _ClienteTelaAnalisar extends State<ClienteTelaAnalisar> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  // ignore: unused_field
  int _index = 0;

  final comentPostController = TextEditingController();

  bool? _checkbox1 = false;
  String checkum = '';
  bool? _checkbox2 = false;
  String checkdois = '';
  bool? _checkbox3 = false;
  String checktres = '';
  bool? _checkbox4 = false;
  String checkquatro = '';
  bool? _checkbox5 = false;
  String checkcinco = '';

  int radioValueCorrecoes = 0;
  late String correcoes;

  handleRadioValueChangedCorrecoes(value) async {
    setState(() {
      radioValueCorrecoes = value;

      switch (radioValueCorrecoes) {
        case 0:
          //Fluttertoast.showToast(msg: 'Entre 18 e 30 anos',toastLength: Toast.LENGTH_SHORT);
          correcoes = "Não falo sobre este tema";
          break;
        case 1:
          //Fluttertoast.showToast(msg: 'Entre 30 e 40 anos',toastLength: Toast.LENGTH_SHORT);
          correcoes = "Não quero este post no momento";
          break;
        case 2:
          //Fluttertoast.showToast(msg: 'Entre 30 e 40 anos',toastLength: Toast.LENGTH_SHORT);
          correcoes = "Corrigir erros ortográficos";
          break;
        case 3:
          //Fluttertoast.showToast(msg: 'Entre 30 e 40 anos',toastLength: Toast.LENGTH_SHORT);
          correcoes = "Alterar imagens";
          break;
        case 4:
          //Fluttertoast.showToast(msg: 'Entre 30 e 40 anos',toastLength: Toast.LENGTH_SHORT);
          correcoes = "Alterar apenas a data da publicação";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uids = user?.uid;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    corPrincipal,
                    corsegunda,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  //begin: const FractionalOffset(0.0, 0.0),
                  //end: const FractionalOffset(0.5, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
              // borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Clientes")
                  .doc(uids)
                  .collection("Posts")
                  .orderBy("dtprevorderby", descending: false)
                  .where("status", isEqualTo: 'analisar')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                var data = snapshot.data;
                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var datalength = data.docs.length;
                  if (datalength == 0) {
                    return const Center(
                      child: Text('Não tem posts para analisar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            //fontWeight: FontWeight.w200
                          )),
                    );
                  } else {
                    return Center(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              return Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.all(20),
                                    elevation: 20,
                                    color: Colors.white, // _color,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /*CARROSSEL*/ StreamBuilder<
                                                  QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("Clientes")
                                                  .doc(uids)
                                                  .collection("Posts")
                                                  .doc(ds.id)
                                                  .collection("imgs")
                                                  .orderBy('imagemcriadaem',
                                                      descending: false)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                var data = snapshot.data;
                                                if (data == null) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  var datalength =
                                                      data.docs.length;
                                                  if (datalength == 0) {
                                                    return const Center(
                                                      child: Text(
                                                          'Sem posts para analisar',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            //fontWeight: FontWeight.w200
                                                          )),
                                                    );
                                                  } else {
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          CarouselSlider
                                                              .builder(
                                                                  itemCount:
                                                                      snapshot
                                                                          .data
                                                                          ?.docs
                                                                          .length,
                                                                  // itemCount: snapShot.data()!.length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          index,
                                                                          // ignore: avoid_types_as_parameter_names
                                                                          int) {
                                                                    DocumentSnapshot
                                                                        ds =
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index];
                                                                    return Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        /* width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,*/
                                                                        height: MediaQuery.of(context)
                                                                            .size
                                                                            .height,
                                                                        child: Image
                                                                            .network(
                                                                          ds['url'],
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ));
                                                                  },
                                                                  options: CarouselOptions(
                                                                      aspectRatio: 4 / 5,
                                                                      viewportFraction: 1,
                                                                      enableInfiniteScroll: false,
                                                                      initialPage: 0,
                                                                      autoPlay: false,
                                                                      //height: 480,
                                                                      onPageChanged: (int i, carouselPageChangedReason) {
                                                                        setState(
                                                                            () {
                                                                          _index =
                                                                              i;
                                                                        });
                                                                      })),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                              }),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey[300],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Text('Data prevista:',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0)),
                                                  Text(
                                                    ds['dataprevisao'],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      //fontStyle: FontStyle.italic,
                                                      //fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          /*TEXT POST*/ Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    ds['post'],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      //fontStyle: FontStyle.italic,
                                                      //fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey[300],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                /*ação */ Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    /*aprovar */ ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Atenção"),
                                                                content: const Text(
                                                                    "Você aprova este texto?"),
                                                                actions: [
                                                                  TextButton(
                                                                    //cancelar button
                                                                    child: const Text(
                                                                        "Cancelar"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    //enviar button
                                                                    child: const Text(
                                                                        "Sim"),
                                                                    onPressed:
                                                                        () async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Clientes')
                                                                          .doc(
                                                                              uids)
                                                                          .collection(
                                                                              "Posts")
                                                                          .doc(ds
                                                                              .id)
                                                                          .update({
                                                                        'status':
                                                                            'aprovado',
                                                                        'aprovadoem': Timestamp.now()
                                                                      });
                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Texto aprovado com sucesso",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              6,
                                                                          backgroundColor:
                                                                              corFlutterToast,
                                                                          textColor: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16.0);
                                                                      //  _color = Colors.blue; // This change Container color
                                                                      //});
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        backgroundColor: Colors
                                                            .green, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                      child: const Icon(Icons.check,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    /*reprovado*/ ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return SingleChildScrollView(
                                                                reverse: true,
                                                                child:
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0)),
                                                                  title: const Text(
                                                                      "Qual motivo da reprovação?"),
                                                                  //content: Text("Hello world"),
                                                                  actions: <
                                                                      Widget>[
                                                                    /* Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              0,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Não falo sobre este tema;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Não quero este post no momento;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Corrigir erros ortográficos;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Alterar as imagens;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Alterar apenas a data da publicação;(Informar no campo Outros motivos)",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    */
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox1,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Não falo sobre este tema",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox1 =
                                                                              val;
                                                                          if (_checkbox1 ==
                                                                              true) {
                                                                            checkum =
                                                                                'Não falo sobre este tema';
                                                                          } else {
                                                                            checkum =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox2,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Não quero este post no momento",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox2 =
                                                                              val;
                                                                          if (_checkbox2 ==
                                                                              true) {
                                                                            checkdois =
                                                                                'Não quero este post no momento';
                                                                          } else {
                                                                            checkdois =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox3,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Corrigir erros ortográficos",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox3 =
                                                                              val;
                                                                          if (_checkbox3 ==
                                                                              true) {
                                                                            checktres =
                                                                                'Corrigir erros ortográficos';
                                                                          } else {
                                                                            checktres =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox4,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Alterar imagens",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox4 =
                                                                              val;
                                                                          if (_checkbox4 ==
                                                                              true) {
                                                                            checkquatro =
                                                                                'Alterar imagens';
                                                                          } else {
                                                                            checkquatro =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox5,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Alterar apenas a data da publicação (Informar data em outros motivos)",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox5 =
                                                                              val;
                                                                          if (_checkbox5 ==
                                                                              true) {
                                                                            checkcinco =
                                                                                'Texto ok! Alterar data da publicação';
                                                                          } else {
                                                                            checkcinco =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: bottom), //pro texto não ficar atras do teclado bottom
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              comentPostController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            hintText:
                                                                                'Detalhe as correções para este post:',
                                                                            labelText:
                                                                                'Outros motivos:',
                                                                            //errorText: _validate ? 'Campo obrigatório' : null
                                                                          ),
                                                                          autofocus:
                                                                              false,
                                                                          maxLines:
                                                                              null,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                          //cancelar button
                                                                          child:
                                                                              const Text("Cancelar"),
                                                                          onPressed:
                                                                              () {
                                                                            setState(
                                                                              () {
                                                                                _checkbox1 = false;
                                                                                _checkbox2 = false;
                                                                                _checkbox3 = false;
                                                                                _checkbox4 = false;
                                                                                _checkbox5 = false;
                                                                                comentPostController.clear();
                                                                              },
                                                                            );
                                                                            Navigator.pop(context,
                                                                                false);
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          //enviar button
                                                                          child:
                                                                              const Text("Sim"),
                                                                          onPressed:
                                                                              () async {
                                                                            await FirebaseFirestore.instance.collection('Clientes').doc(uids).collection("Posts").doc(ds.id).update({
                                                                              'status': 'reprovado',
                                                                              'reprovadoem': Timestamp.now(),
                                                                              'correcoes1': checkum,
                                                                              'correcoes2': checkdois,
                                                                              'correcoes3': checktres,
                                                                              'correcoes4': checkquatro,
                                                                              'correcoes5': checkcinco,
                                                                              'correcoes6': comentPostController.text,
                                                                            });
                                                                            // ignore: use_build_context_synchronously
                                                                            Navigator.pop(context,
                                                                                false);
                                                                            setState(
                                                                              () {
                                                                                _checkbox1 = false;
                                                                                _checkbox2 = false;
                                                                                _checkbox3 = false;
                                                                                _checkbox4 = false;
                                                                                _checkbox5 = false;
                                                                                comentPostController.clear();
                                                                              },
                                                                            );
                                                                            Fluttertoast.showToast(
                                                                                msg: "Texto reprovado com sucesso!",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM,
                                                                                timeInSecForIosWeb: 6,
                                                                                backgroundColor: corFlutterToast,
                                                                                textColor: Colors.black,
                                                                                fontSize: 16.0);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        );
                                                        /* showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              content:
                                                                  StatefulBuilder(
                                                                      builder: (
                                                                BuildContext
                                                                    context,
                                                                StateSetter
                                                                    setState,
                                                              ) {
                                                                return Column(
                                                                  children: [
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              0,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Não falo sobre este tema;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Não quero este post no momento;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Corrigir erros ortográficos;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Alterar as imagens;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Alterar apenas a data da publicação;(Informar no campo Outros motivos)",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: bottom), //pro texto não ficar atras do teclado bottom
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              comentPostController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            hintText:
                                                                                'Detalhe as correções para este post:',
                                                                            labelText:
                                                                                'Outros motivos:',
                                                                            //errorText: _validate ? 'Campo obrigatório' : null
                                                                          ),
                                                                          autofocus:
                                                                              false,
                                                                          maxLines:
                                                                              null,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                          //cancelar button
                                                                          child:
                                                                              const Text("Cancelar"),
                                                                          onPressed:
                                                                              () {
                                                                            setState(
                                                                              () {
                                                                                _checkbox1 = false;
                                                                                _checkbox2 = false;
                                                                                _checkbox3 = false;
                                                                                _checkbox4 = false;
                                                                                _checkbox5 = false;
                                                                                comentPostController.clear();
                                                                              },
                                                                            );
                                                                            Navigator.pop(context,
                                                                                false);
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          //enviar button
                                                                          child:
                                                                              const Text("Sim"),
                                                                          onPressed:
                                                                              () async {
                                                                            await FirebaseFirestore.instance.collection('Clientes').doc(uids).collection("Posts").doc(ds.id).update({
                                                                              'status': 'reprovado',
                                                                              'correcoes1': checkum,
                                                                              'correcoes2': checkdois,
                                                                              'correcoes3': checktres,
                                                                              'correcoes4': checkquatro,
                                                                              'correcoes5': checkcinco,
                                                                              'correcoes6': comentPostController.text,
                                                                            });
                                                                            Navigator.pop(context,
                                                                                false);
                                                                            setState(
                                                                              () {
                                                                                _checkbox1 = false;
                                                                                _checkbox2 = false;
                                                                                _checkbox3 = false;
                                                                                _checkbox4 = false;
                                                                                _checkbox5 = false;
                                                                                comentPostController.clear();
                                                                              },
                                                                            );
                                                                            Fluttertoast.showToast(
                                                                                msg: "Texto reprovado com sucesso!",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM,
                                                                                timeInSecForIosWeb: 6,
                                                                                backgroundColor: corFlutterToast,
                                                                                textColor: Colors.black,
                                                                                fontSize: 16.0);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              }),
                                                            );
                                                          },
                                                        );
                                                       */
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        backgroundColor: Colors
                                                            .red, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                      child: const Icon(
                                                          Icons.clear_rounded,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    /* editar */ ElevatedButton(
                                                      onPressed: () async {
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditTextoPost(
                                                                      uid: auth
                                                                          .currentUser!
                                                                          .uid,
                                                                      idpost:
                                                                          ds.id,
                                                                      editpost:
                                                                          ds['post']),
                                                            ));
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const CircleBorder(),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        backgroundColor: Colors
                                                            .grey, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                      child: const Icon(
                                                          Icons.edit_note,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        //}).toList()),
                                      ),
                                    ),
                                  ));
                            }));
                  }
                }
              }),
        ],
      ),
    );
  }
}


/* showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return SingleChildScrollView(
                                                                reverse: true,
                                                                child:
                                                                    AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0)),
                                                                  title: const Text(
                                                                      "Qual motivo da reprovação?"),
                                                                  //content: Text("Hello world"),
                                                                  actions: <
                                                                      Widget>[
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              0,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Não falo sobre este tema;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Não quero este post no momento;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Corrigir erros ortográficos;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              3,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Alterar as imagens;",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      //mainAxisSize: MainAxisSize.min,
                                                                      children: <
                                                                          Widget>[
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Radio<
                                                                            int>(
                                                                          value:
                                                                              4,
                                                                          groupValue:
                                                                              radioValueCorrecoes,
                                                                          onChanged:
                                                                              handleRadioValueChangedCorrecoes,
                                                                        ),
                                                                        const Expanded(
                                                                          child: Text(
                                                                              "Alterar apenas a data da publicação;(Informar no campo Outros motivos)",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18.0,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    /* CheckboxListTile(
                                                                      value:
                                                                          _checkbox1,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Não falo sobre este tema",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox1 =
                                                                              val;
                                                                          if (_checkbox1 ==
                                                                              true) {
                                                                            checkum =
                                                                                'Não falo sobre este tema';
                                                                          } else {
                                                                            checkum =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox2,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Não quero este post no momento",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox2 =
                                                                              val;
                                                                          if (_checkbox2 ==
                                                                              true) {
                                                                            checkdois =
                                                                                'Não quero este post no momento';
                                                                          } else {
                                                                            checkdois =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox3,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Corrigir erros ortográficos",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox3 =
                                                                              val;
                                                                          if (_checkbox3 ==
                                                                              true) {
                                                                            checktres =
                                                                                'Corrigir erros ortográficos';
                                                                          } else {
                                                                            checktres =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox4,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Alterar imagens",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox4 =
                                                                              val;
                                                                          if (_checkbox4 ==
                                                                              true) {
                                                                            checkquatro =
                                                                                'Alterar imagens';
                                                                          } else {
                                                                            checkquatro =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                    CheckboxListTile(
                                                                      value:
                                                                          _checkbox5,
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          cinza,
                                                                      tristate:
                                                                          false,
                                                                      title:
                                                                          const Text(
                                                                        "Texto ok! Alterar data da publicação (Informar data no campo abaixo em outros motivos)",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          letterSpacing:
                                                                              -1.5,
                                                                        ),
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(
                                                                            () {
                                                                          _checkbox5 =
                                                                              val;
                                                                          if (_checkbox5 ==
                                                                              true) {
                                                                            checkcinco =
                                                                                'Texto ok! Alterar data da publicação';
                                                                          } else {
                                                                            checkcinco =
                                                                                '';
                                                                          }
                                                                        });
                                                                      },
                                                                      controlAffinity:
                                                                          ListTileControlAffinity
                                                                              .leading, //Leading Checkbox Icon
                                                                    ),
                                                                     */
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: bottom), //pro texto não ficar atras do teclado bottom
                                                                        child:
                                                                            TextField(
                                                                          controller:
                                                                              comentPostController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            hintText:
                                                                                'Detalhe as correções para este post:',
                                                                            labelText:
                                                                                'Outros motivos:',
                                                                            //errorText: _validate ? 'Campo obrigatório' : null
                                                                          ),
                                                                          autofocus:
                                                                              false,
                                                                          maxLines:
                                                                              null,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                          //cancelar button
                                                                          child:
                                                                              const Text("Cancelar"),
                                                                          onPressed:
                                                                              () {
                                                                            setState(
                                                                              () {
                                                                                _checkbox1 = false;
                                                                                _checkbox2 = false;
                                                                                _checkbox3 = false;
                                                                                _checkbox4 = false;
                                                                                _checkbox5 = false;
                                                                                comentPostController.clear();
                                                                              },
                                                                            );
                                                                            Navigator.pop(context,
                                                                                false);
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          //enviar button
                                                                          child:
                                                                              const Text("Sim"),
                                                                          onPressed:
                                                                              () async {
                                                                            await FirebaseFirestore.instance.collection('Clientes').doc(uids).collection("Posts").doc(ds.id).update({
                                                                              'status': 'reprovado',
                                                                              'correcoes1': checkum,
                                                                              'correcoes2': checkdois,
                                                                              'correcoes3': checktres,
                                                                              'correcoes4': checkquatro,
                                                                              'correcoes5': checkcinco,
                                                                              'correcoes6': comentPostController.text,
                                                                            });
                                                                            Navigator.pop(context,
                                                                                false);
                                                                            setState(
                                                                              () {
                                                                                _checkbox1 = false;
                                                                                _checkbox2 = false;
                                                                                _checkbox3 = false;
                                                                                _checkbox4 = false;
                                                                                _checkbox5 = false;
                                                                                comentPostController.clear();
                                                                              },
                                                                            );
                                                                            Fluttertoast.showToast(
                                                                                msg: "Texto reprovado com sucesso!",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM,
                                                                                timeInSecForIosWeb: 6,
                                                                                backgroundColor: corFlutterToast,
                                                                                textColor: Colors.black,
                                                                                fontSize: 16.0);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        );
                                                       */