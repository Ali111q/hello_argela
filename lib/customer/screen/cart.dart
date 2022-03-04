import 'dart:math';

import 'package:aloarkela2/all/screen/user_discouonts.dart';
import 'package:aloarkela2/customer/widgets/cart_item.dart';
import 'package:aloarkela2/customer/widgets/juices.dart';
import 'package:aloarkela2/customer/widgets/user_item.dart';
import 'package:aloarkela2/primary_widgets.dart';
import 'package:aloarkela2/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class cartScreen extends StatefulWidget {
  cartScreen({Key? key}) : super(key: key);

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  int carpon = 0;
  num total = 0;
  int carpPrice = 0;
  int finNum = 0;
  int finPrice = 0;
  List ind = [];
  late int Price;
  bool _adding = false;
  @override
  void initState() {
    fitchdata();
    super.initState();
  }

  bool _writing = false;
  String finName = '';
  @override
  Widget build(BuildContext context) {
    var juiceName = Provider.of<myProvider>(context).juiceName;
    var juice = Provider.of<myProvider>(context).juice;

    if (juice != null) {
      Price = Provider.of<myProvider>(context, listen: true).total +
          carpPrice +
          juice +
          finPrice;
    } else {
      Price = Provider.of<myProvider>(context, listen: true).total +
          carpPrice +
          finPrice;
    }
    int i = 1;

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image.asset(
              'assets/logo/smoke.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Provider.of<myProvider>(context).isDark
              ? Colors.transparent
              : Color(0xfff5f5f5),
          appBar: myAppBar(context: context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height:
                        MediaQuery.of(context).size.height < 926.0 ? 374 : 474,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ...Provider.of<myProvider>(context)
                            .items
                            .asMap()
                            .entries
                            .map((e) {
                          ind.add({e.key});
                          total = Provider.of<myProvider>(context).total;
                          print(total);

                          return cartItem(
                              juice: e.value['juice'],
                              fin: e.value['fin'],
                              name: e.value['name'],
                              price: e.value['price'],
                              num: e.value['num'],
                              index: e.key,
                              image: e.value['image'],
                              context: context);
                        }),
                        _adding
                            ? AnimatedOpacity(
                                opacity: _adding ? 1 : 0,
                                duration: Duration(milliseconds: 200),
                                child: Column(
                                  children: [
                                    Container(
                                        width: 354,
                                        height: 72,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          color: Color(0xc01E223A),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'فناجين',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'tawasul',
                                                  color: Color(
                                                    0xfff5f5f5,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                child: TextField(
                                                  style: TextStyle(
                                                      color: Color(0xfff5f5f5),
                                                      fontSize: 18),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      finName = val;
                                                      _writing = true;
                                                    });
                                                  },
                                                  onSubmitted: (v) {
                                                    setState(() {
                                                      _writing = false;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                      label: Center(
                                                          child: _writing
                                                              ? Container()
                                                              : Text(
                                                                  'اسم الخبطه',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'tawasul',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ))),
                                                ),
                                              ),
                                              Text(
                                                '5,000',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'tawasul',
                                                  color: Color(
                                                    0xfff5f5f5,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (finNum >= 1) {
                                                            finNum -= 1;
                                                            finPrice -= 5000;
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.remove,
                                                        color:
                                                            Color(0xfffff669),
                                                      )),
                                                  Text(
                                                    '$finNum',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'tawasul',
                                                      color: Color(
                                                        0xfff5f5f5,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          finNum += 1;
                                                          finPrice += 5000;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        color:
                                                            Color(0xfffff669),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    Container(
                                      width: 354,
                                      height: 72,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        color: Color(0xc01E223A),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'فحم',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'tawasul',
                                                color: Color(
                                                  0xfff5f5f5,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '1,500',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'tawasul',
                                                color: Color(
                                                  0xfff5f5f5,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (carpon != 0) {
                                                      setState(() {
                                                        carpon -= 8;
                                                        carpPrice -= 1500;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 35,
                                                    color: Color(0xfffff669),
                                                  ),
                                                ),
                                                Text(
                                                  '$carpon',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'tawasul',
                                                      color: Color(0xfff5f5f5)),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        carpon += 8;

                                                        carpPrice += 1500;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 35,
                                                      color: Color(0xfffff669),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          width: 354,
                          height: 89,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color(0xc01E223A),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'اضافات',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'tawasul',
                                    color: Color(
                                      0xfff5f5f5,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _adding = !_adding;
                                    });
                                  },
                                  icon: ImageIcon(_adding
                                      ? AssetImage('assets/logo/up.png')
                                      : AssetImage('assets/logo/down.png')),
                                  color: Color(0xfffff669),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                juice != null
                    ? Container(
                        width: 500,
                        height: 100,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Color(0xc01E223A),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<myProvider>(context,
                                              listen: false)
                                          .juice = null;

                                      Provider.of<myProvider>(context,
                                              listen: false)
                                          .juiceName = null;
                                    });
                                  },
                                  child: Text(
                                    'حذف',
                                    style: TextStyle(
                                        color: Color(0xfffff669),
                                        fontSize: 15,
                                        fontFamily: 'tawasul'),
                                  )),
                              Text(
                                '$juice',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 20,
                                    fontFamily: 'tawasul'),
                              ),
                              Text(
                                juice == 25000 ? 'نصف كيلو' : ' كيلو',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 20,
                                    fontFamily: 'tawasul'),
                              ),
                              Text(
                                '$juiceName',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 16,
                                    fontFamily: 'tawasul'),
                              )
                            ],
                          ),
                        ))
                    : Container(),
                Container(
                  width: 500,
                  height: 100,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color(0xc01E223A),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('coming soon')));
                            },
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                label: Center(
                                    child: Text(
                                  'قسيمة التخفيض',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'tawasul',
                                    color: Colors.white,
                                  ),
                                ))),
                          ),
                          width: 150,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('coming soon')));
                            },
                            child: Text('تطبيق',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'tawasul',
                                )))
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 414,
                  height: 100,
                  color: Color(0xc01E223A),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return userDiscountScreen(ismanager: false);
                            }));
                          },
                          child: Text(
                            'الذهاب للعروض',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'tawasul',
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'العروض',
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'tawasul',
                                color: Color(0xfff5f5f5)),
                          ),
                          Text('احصل على تخفيض من خلال العروض ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'tawasul',
                                  color: Color(0xfff5f5f5))),
                          Text(
                            'اللتي نقدمها لك',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'tawasul',
                                color: Color(0xfff5f5f5)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 142,
            decoration: BoxDecoration(
                color: Color(0xc01E223A),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$Price',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Color(0xfff5f5f5)),
                    ),
                    Text(
                      ':المبلغ',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Color(0xfff5f5f5)),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('ارسال الطلب؟'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'لا',
                                      style:
                                          TextStyle(color: Color(0xff000000)),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await getlocation().then((value) async {
                                        await makeOrder().then((value) {
                                          OneSignal.shared.postNotification(
                                              OSCreateNotification(
                                                  playerIds: tokens,
                                                  content: 'لديك طلب جديد'));
                                        }).then((value) {});
                                      });
                                    },
                                    child: Text(
                                      'نعم',
                                      style:
                                          TextStyle(color: Color(0xff000000)),
                                    ))
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: 187,
                      height: 47,
                      child: Center(
                        child: Text(
                          'تآكيد',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'tawasul',
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> makeOrder() async {
    if (lat != null && lng != null) {
      int ran = Random().nextInt(100000);
      FirebaseFirestore.instance.collection('orders').doc('a$ran').set({
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
        'order': Provider.of<myProvider>(context, listen: false).items,
        'carpon': carpon,
        'carpPrice': carpPrice,
        'id': FirebaseAuth.instance.currentUser!.uid,
        'total': Price,
        'orderPOS': 'waiting',
        'date':
            '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
        'orderId': 'a$ran',
        'lat': lat,
        'lng': lng,
        'token': myToken,
        'finName': finName,
        'finNum': finNum,
        'juiceName': Provider.of<myProvider>(context, listen: false).juiceName,
        'juiceNum': Provider.of<myProvider>(context, listen: false).juice,
        'image': Provider.of<myProvider>(context, listen: false)
            .items
            .first['image'],
        'driverToken': null
      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('تم ارسال الطلب'),
          )));
    }
  }

  double? lat;
  double? lng;
  Future<void> getlocation() async {
    await GeolocatorPlatform.instance.requestPermission();
    await GeolocatorPlatform.instance.getCurrentPosition().then((value) {
      setState(() {
        lng = value.longitude;
        lat = value.latitude;
      });
    });
  }

  String? myToken;
  CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('user');
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? managers;
  int? li;
  List<String> tokens = [];
  Future<void> fitchdata() async {
    await ref.where('type', isEqualTo: 'manager').get().then((value) {
      setState(() {
        managers = value.docs;
        li = value.docs.length;
      });
    }).then((value) {
      for (var i = 0; i < li!; i++) {
        tokens.add((managers![i]['token']).toString());
      }
    });
    OneSignal.shared.getDeviceState().then((value) {
      setState(() {
        myToken = value!.userId;
      });
    });
  }
}
