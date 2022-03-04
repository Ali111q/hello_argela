import 'package:aloarkela2/customer/widgets/log_item.dart';
import 'package:aloarkela2/primary_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class userLogScreen extends StatefulWidget {
  const userLogScreen({Key? key, required this.isManager}) : super(key: key);
  final isManager;

  @override
  _userLogScreenState createState() => _userLogScreenState();
}

class _userLogScreenState extends State<userLogScreen> {
  List log = ['', 'a'];
  bool _isloading = false;
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    if (!widget.isManager) {
      fitchData().then((value) => fitchData2()).then((value) {
        setState(() {
          _isloading = false;
        });
      });
    } else {
      fitchManagerData().then((value) => fitchManagerData2()).then((value) {
        setState(() {
          _isloading = false;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            'assets/logo/smoke.jpg',
            fit: BoxFit.fitWidth,
          ),
        ),
        Scaffold(
          backgroundColor: Provider.of<myProvider>(context).isDark
              ? Colors.transparent
              : Color(0xfff5f5f5),
          appBar: myAppBar(context: context),
          body: _isloading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 2,
                        ),
                        Text(
                          !widget.isManager ? 'طلبك الحالي' : 'الطلبات',
                          style: TextStyle(
                              color: Provider.of<myProvider>(context).isDark
                                  ? Colors.white
                                  : Color(0xff1e223a),
                              fontSize: 20,
                              fontFamily: 'tawasul'),
                        ),
                        Container(
                          width: 2,
                        ),
                      ],
                    ),
                    ...items2.map((e) => userLogItem(
                          order: e['order'],
                          pos: e['orderPOS'],
                          lat: e['lat'],
                          lng: e['lng'],
                          total: e['total'],
                          isDriver: false,
                          id: e['orderId'],
                          ismanager: widget.isManager,
                          date: e['date'],
                          price: e['total'],
                          carpon: e['carpon'],
                          token: e['token'],
                          image: e['image'],
                          finName: e['finName'],
                          finNum: e['finNum'],
                          juicePrice: e['juiceNum'],
                          juiseName: e['juiceName'],
                          driverToken: e['driverToken'] ?? null,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 2,
                        ),
                        Text(
                          !widget.isManager
                              ? 'طلباتك السابقة'
                              : 'الطلبات السابقة',
                          style: TextStyle(
                              color: Provider.of<myProvider>(context).isDark
                                  ? Colors.white
                                  : Color(0xff1e223a),
                              fontSize: 18,
                              fontFamily: 'tawasul'),
                        ),
                        Container(
                          width: 2,
                        ),
                      ],
                    ),
                    ...items.map((e) => userLogItem(
                          token: e['token'],
                          order: e['order'],
                          pos: e['orderPOS'],
                          lat: e['lat'],
                          lng: e['lng'],
                          total: e['total'],
                          isDriver: false,
                          id: e['orderId'],
                          ismanager: widget.isManager,
                          date: e['date'],
                          price: e['total'],
                          carpon: e['carpon'],
                          image: e['image'],
                          finName: e['finName'],
                          finNum: e['finNum'],
                          juicePrice: e['juiceNum'],
                          juiseName: e['juiceName'],
                          driverToken: e['driverToken'] ?? null,
                        ))
                  ],
                ),
        )
      ],
    );
  }

  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('orders');
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items2;
  int? val;

  Future<void> fitchData() async {
    await ref
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('orderPOS', isNotEqualTo: 'done')
        .get()
        .then((value) {
      setState(() {
        items2 = value.docs;
        val = value.docs.length;
      });
    });
  }

  Future<void> fitchData2() async {
    await ref
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('orderPOS', isEqualTo: 'done')
        .get()
        .then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
  }

  Future<void> fitchManagerData() async {
    await ref.where('orderPOS', isEqualTo: 'waiting').get().then((value) {
      setState(() {
        items2 = value.docs;
        val = value.docs.length;
      });
    });
  }

  Future<void> fitchManagerData2() async {
    await ref.where('orderPOS', isNotEqualTo: 'waiting').get().then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
  }
}
