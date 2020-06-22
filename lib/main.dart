import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezal/account_page.dart';
import 'package:tezal/data/moor_filename.dart';
import 'package:tezal/orders_page.dart';
import 'package:tezal/raw_materials_page.dart';
import 'package:tezal/registr_page.dart';

import 'containers_page.dart';
import 'containers_page_izb.dart';
import 'menu_page.dart';

void main() => runApp(TezAL());

class TezAL extends StatelessWidget {
  static String url = "https://tezal.herokuapp.com/api";

  static String get getUrl {
    return url;
  }

  static set setUrl(String _url) {
    url = _url;
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => TezAlDb(),
      child: MaterialApp(
        title: 'TezAl',
        theme: ThemeData(
            primaryColor: Colors.orange,
            textTheme: TextTheme(title: TextStyle(color: Colors.white))),
        initialRoute: '/login',
        routes: {
          '/login': (context) => RegisterPage(),
          '/mainCatalogContainer': (context) => MenuPage(),
          '/containers': (context) => ContainersPage(),
          '/rawMaterial': (context) => RawMaterialScreen(),
          '/order': (context) => OrdersPage(),
          '/account': (context) => AccountPage(),
          '/taskIzb': (context) => ContainerTaskIzbPage(),
          //'/taskHistoryDetail': (context) => TaskHistoryPageDetail(),
          //'/department': (context) => Home(),
          //'/chat': (context) => ChatScreen(),
        },
        onGenerateRoute: (routeSettings) {
          var path = routeSettings.name.split('/');
          if (path[1] == 'account') {
            //  return new MaterialPageRoute(builder: (context)=>new AccountPage(id:int.parse(path[2])), settings: routeSettings);
          }
        },
      ),
    );
  }
}
