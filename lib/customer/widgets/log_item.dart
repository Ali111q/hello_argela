import 'package:aloarkela2/customer/screen/my_orders.dart';
import 'package:aloarkela2/customer/widgets/juices.dart';
import 'package:aloarkela2/driver/ui/mapScreen.dart';
import 'package:flutter/material.dart';

class userLogItem extends StatelessWidget {
  const userLogItem(
      {Key? key,
      required this.isDriver,
      required this.date,
      required this.price,
      required this.ismanager,
      required this.id,
      required this.order,
      required this.total,
      required this.carpon,
      required this.pos,
      required this.lat,
      required this.lng,
      required this.token,
      required this.image,
      this.finName,
      this.finNum,
      this.juicePrice,
      this.juiseName,
      this.driverToken})
      : super(key: key);
  final token;
  final date;
  final price;
  final ismanager;
  final id;
  final isDriver;
  final order;
  final total;
  final carpon;
  final pos;
  final lat;
  final lng;
  final image;
  final finName;
  final finNum;
  final juicePrice;
  final juiseName;
  final driverToken;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isDriver) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return mapScreen(
              id: id,
            );
          }));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return myOrdersScreen(
              finName: finName,
              finNum: finNum,
              juicePrice: juicePrice,
              juiceName: juiseName,
              token: token,
              pos: pos,
              order: order,
              carpon: carpon,
              lat: lat,
              lng: lng,
              total: total,
              isDriver: isDriver,
              ismanager: ismanager,
              id: id,
              driverToken: driverToken,
            );
          }));
        }
      },
      child: Container(
        width: 354,
        height: 90,
        child: Card(
          color: Color(0xc01E223A),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 69,
                child: image == 'assets/logo/hooka.png'
                    ? Image.asset('assets/logo/hooka.png')
                    : Image.network(image),
              ),
              Text(
                '$price',
                style: TextStyle(
                    color: Color(0xfff5f5f5),
                    fontSize: 20,
                    fontFamily: 'tawasul'),
              ),
              Text(
                '${date}',
                style: TextStyle(
                    color: Color(0xfff5f5f5),
                    fontSize: 20,
                    fontFamily: 'tawasul'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
