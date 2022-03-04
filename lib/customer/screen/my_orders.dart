import 'package:aloarkela2/customer/widgets/juices.dart';
import 'package:aloarkela2/customer/widgets/order_tile_widget.dart';
import 'package:aloarkela2/primary_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class myOrdersScreen extends StatefulWidget {
  myOrdersScreen(
      {Key? key,
      required this.ismanager,
      required this.id,
      required this.isDriver,
      required this.order,
      required this.total,
      required this.carpon,
      required this.pos,
      required this.lat,
      required this.lng,
      required this.token,
      required this.juiceName,
      this.juicePrice,
      this.finName,
      this.finNum,
      this.driverToken});
  final ismanager;
  final id;
  final isDriver;
  final order;
  final total;
  final carpon;
  final pos;
  final lat;
  final lng;
  final token;
  final juiceName;
  final juicePrice;
  final finName;
  final finNum;
  final driverToken;

  @override
  State<myOrdersScreen> createState() => _myOrdersScreenState();
}

class _myOrdersScreenState extends State<myOrdersScreen> {
  bool isloading = false;
  @override
  void initState() {
    setState(() {
      isloading = true;
    });
    fitchData().then((value) {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Provider.of<myProvider>(context).isDark
              ? Colors.transparent
              : Color(0xfff5f5f5),
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
          body: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 450,
                          width: 350,
                          child: Card(
                            color: Color(0xc01E223A),
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                ...order.map((e) => orderTile(
                                      name: e['name'],
                                      price: e['price'],
                                      num3: e['num'],
                                      fin: e['fin'],
                                      juice: e['juice'],
                                      image: e['image'],
                                    )),
                                Container(
                                  height: 20,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('فحم',
                                          style: TextStyle(
                                              color: Color(0xfff5f5f5),
                                              fontSize: 20,
                                              fontFamily: 'tawasul')),
                                      Text('${widget.carpon * 1500 / 8} IQD',
                                          style: TextStyle(
                                              color: Color(0xfff5f5f5),
                                              fontSize: 20,
                                              fontFamily: 'tawasul')),
                                      Text('${widget.carpon} ',
                                          style: TextStyle(
                                              color: Color(0xfff5f5f5),
                                              fontSize: 20,
                                              fontFamily: 'tawasul'))
                                    ]),
                                Container(
                                  height: 20,
                                ),
                                widget.juiceName == null
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                            Text('${widget.juiceName}',
                                                style: TextStyle(
                                                    color: Color(0xfff5f5f5),
                                                    fontSize: 20,
                                                    fontFamily: 'tawasul')),
                                            Text('${widget.juicePrice} IQD',
                                                style: TextStyle(
                                                    color: Color(0xfff5f5f5),
                                                    fontSize: 20,
                                                    fontFamily: 'tawasul')),
                                            Text(
                                                widget.juicePrice == 25
                                                    ? 'نصف كيلو '
                                                    : 'كيلو',
                                                style: TextStyle(
                                                    color: Color(0xfff5f5f5),
                                                    fontSize: 20,
                                                    fontFamily: 'tawasul'))
                                          ]),
                                Container(
                                  height: 20,
                                ),
                                widget.finNum == null
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                            widget.finName == null
                                                ? Container()
                                                : Text('${widget.finName}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xfff5f5f5),
                                                        fontSize: 20,
                                                        fontFamily: 'tawasul')),
                                            Text('${widget.finNum * 5000} IQD',
                                                style: TextStyle(
                                                    color: Color(0xfff5f5f5),
                                                    fontSize: 20,
                                                    fontFamily: 'tawasul')),
                                            Text('${widget.finNum} ',
                                                style: TextStyle(
                                                    color: Color(0xfff5f5f5),
                                                    fontSize: 20,
                                                    fontFamily: 'tawasul'))
                                          ]),
                                Container(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${widget.total} IQD ',
                                      style: TextStyle(
                                          color: Color(0xfff5f5f5),
                                          fontSize: 20,
                                          fontFamily: 'tawasul'),
                                    ),
                                    Text(
                                      ':المبلغ',
                                      style: TextStyle(
                                          color: Color(0xfff5f5f5),
                                          fontSize: 20,
                                          fontFamily: 'tawasul'),
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.pos == 'done' ||
                                              widget.pos == 'dilevared'
                                          ? 'مكتمل'
                                          : widget.pos == 'waiating3'
                                              ? 'في الطريق'
                                              : 'بانتظار الموافقة',
                                      style: TextStyle(
                                          color: Color(0xfffff669),
                                          fontSize: 20,
                                          fontFamily: 'tawasul'),
                                    ),
                                    Text(
                                      ' :حالة الطلب',
                                      style: TextStyle(
                                          color: Color(0xfffff669),
                                          fontSize: 20,
                                          fontFamily: 'tawasul'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Container(
                          width: 350,
                          height: 254,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: !widget.isDriver
                                ? GoogleMap(
                                    myLocationButtonEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(widget.lat, widget.lng),
                                        zoom: 16),
                                    markers: {
                                      Marker(
                                          markerId: MarkerId('order'),
                                          position:
                                              LatLng(widget.lat, widget.lng))
                                    },
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: widget.ismanager || widget.isDriver
              ? ElevatedButton(
                  onPressed: () async {
                    if (!widget.isDriver) {
                      var drivers;
                      int val = 0;
                      await FirebaseFirestore.instance
                          .collection('user')
                          .where('type', isEqualTo: 'driver')
                          .get()
                          .then((value) {
                        setState(() {
                          drivers = value.docs;
                          val = value.docs.length;
                        });
                      });
                      await showDialog(
                        context: context,
                        builder: (_) => FunkyOverlay(
                          count: val,
                          drivers: drivers,
                          widgeetId: widget.id,
                        ),
                      )
                          .then((value) => fitchData())
                          .then((value) => Navigator.of(context).pop());
                    } else {
                      if (widget.pos == 'waiating2') {
                        OneSignal.shared.postNotification(OSCreateNotification(
                            playerIds: [widget.token],
                            content: 'طلبك في الطريق'));
                        FirebaseFirestore.instance
                            .collection('orders')
                            .doc('${widget.id}')
                            .update({
                          'orderPOS': 'waiating3',
                        }).then((value) => Navigator.of(context).pop());
                      } else {
                        OneSignal.shared.postNotification(OSCreateNotification(
                            playerIds: [widget.token],
                            content: 'نشكرك على الطلب من الو اركيلة'));
                        FirebaseFirestore.instance
                            .collection('orders')
                            .doc('${widget.id}')
                            .update({
                              'orderPOS': 'dilevared',
                            })
                            .then((value) => fitchData())
                            .then((value) => Navigator.of(context).pop());
                      }
                    }
                  },
                  child: Container(
                    width: 187,
                    height: 87,
                    child: Center(
                      child: Text(
                        widget.pos == 'waiating3' ? 'تم التوصيل' : 'موافقة',
                        style: TextStyle(fontSize: 32, fontFamily: 'tawasul'),
                      ),
                    ),
                  ),
                )
              : widget.pos == 'dilevared'
                  ? ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'ارجاع الاركيلة',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'tawasul'),
                                ),
                                content: Text(
                                  'هل اكملت التدخين؟',
                                  style: TextStyle(
                                      fontSize: 17, fontFamily: 'tawasul'),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'لا',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc('${widget.id}')
                                            .update({'orderPOS': 'done'}).then(
                                                (value) {
                                          OSCreateNotification(
                                              playerIds: [widget.driverToken],
                                              content:
                                                  'هناك اركيلة جاهزة للارجاع');
                                        });
                                      },
                                      child: Text(
                                        'نعم',
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              );
                            }).then((value) => Navigator.of(context).pop());
                      },
                      child: Container(
                        width: 187,
                        height: 87,
                        child: Center(
                          child: Text(
                            'ارجاع الاركيلة',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'tawasul'),
                          ),
                        ),
                      ),
                    )
                  : null,
        )
      ],
    );
  }

  DocumentReference<Map<String, dynamic>>? ref;

  late DocumentSnapshot<Map<String, dynamic>> items;
  late List order;

  int? val;

  Future<void> fitchData() async {
    ref = FirebaseFirestore.instance.collection('orders').doc(widget.id);

    await ref!.get().then((value) async {
      setState(() {
        items = value;
        order = value['order'];
      });
    });
  }
}

class FunkyOverlay extends StatefulWidget {
  final drivers;
  final count;
  final widgeetId;

  const FunkyOverlay(
      {Key? key,
      required this.drivers,
      required this.count,
      required this.widgeetId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  String place = '';
  int price = 0;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 380,
            height: 360,
            decoration: ShapeDecoration(
                color: Color(0xaf1E223A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: ListView.builder(
                itemCount: widget.count,
                itemBuilder: (BuildContext context, index) {
                  return userWidget1(
                    wigdetId: widget.widgeetId,
                    Type: widget.drivers[index]['type'],
                    name: widget.drivers[index]['name'],
                    place: widget.drivers[index]['place'],
                    phone: widget.drivers[index]['phone'],
                    number: widget.drivers[index]['phone'],
                    driverId: widget.drivers[index]['id'],
                    ontap: () {
                      OneSignal.shared
                          .postNotification(OSCreateNotification(playerIds: [
                        widget.drivers[index]['token'],
                      ], content: 'طلب جديد'));
                      FirebaseFirestore.instance
                          .collection('orders')
                          .doc('${widget.widgeetId}')
                          .update({
                        'orderPOS': 'waiating2',
                        'driverId': '${widget.drivers[index]['id']}',
                        'driverToken': widget.drivers[index]['token']
                      }).then((value) => Navigator.of(context).pop());
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class userWidget1 extends StatefulWidget {
  const userWidget1(
      {Key? key,
      required this.Type,
      required this.name,
      required this.place,
      required this.phone,
      required this.number,
      required this.wigdetId,
      required this.driverId,
      required this.ontap})
      : super(key: key);
  final Type;
  final name;
  final place;
  final phone;
  final number;
  final wigdetId;
  final driverId;
  final ontap;

  @override
  _userWidget1State createState() => _userWidget1State();
}

class _userWidget1State extends State<userWidget1> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.ontap();
      },
      child: SizedBox(
        width: 254,
        height: 90,
        child: Card(
          color: Color(0xc01E223A),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xfff5f5f5),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${widget.place}',
                  style: TextStyle(color: Color(0xfff5f5f5), fontSize: 20),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${widget.name}',
                  style: TextStyle(color: Color(0xfff5f5f5), fontSize: 20),
                ),
                Text(
                  '${widget.phone}',
                  style: TextStyle(color: Color(0xfff5f5f5), fontSize: 20),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
