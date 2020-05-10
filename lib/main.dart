import 'package:flutter/material.dart';
import 'package:tezal/raw_materials_page.dart';
import 'package:tezal/registr_page.dart';

import 'containers_page.dart';
import 'login_page.dart';
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
    return MaterialApp(
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
        //'/account': (context) => AccountPage(),
        //'/taskHistory': (context) => TaskHistoryPage(),
        //'/taskCreate': (context) => FormScreen(),
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
    );
  }
}
