import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart'; 
import 'package:fluttertoast/fluttertoast.dart'; 
import 'cor.dart';

class ClienteTelaAprovados extends StatefulWidget {
  const ClienteTelaAprovados({super.key});

  @override
  State<ClienteTelaAprovados> createState() => _ClienteTelaAprovados();
}

class _ClienteTelaAprovados extends State<ClienteTelaAprovados> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
  }

  // ignore: unused_field
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uids = user?.uid;
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
                  .where("status", isEqualTo: 'aprovado')
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
                      child: Text('Não tem posts aprovados',
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
                                                          'Sem posts aprovados',
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
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    /*aprovado */ ElevatedButton(
                                                      onPressed: () {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Texto já foi aprovado com sucesso",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                6,
                                                            backgroundColor:
                                                                corFlutterToast,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 16.0);
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
                                                      child: const Icon(Icons.check,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
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
