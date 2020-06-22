import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/model/container_category.dart';

import 'package:http/http.dart' as http;
import 'containers_page.dart';
import 'main.dart';
import 'model/user.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MenuScreen();
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreen createState() => new _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  List<ContainerCategory> containerCategory = List<ContainerCategory>();
  User user = new User();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(title: Text('Разделы')),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(user.lastName != null
                        ? '${user.lastName} ${user.firstName}'
                        : ''),
                    accountEmail:
                        new Text(user.telephon != null ? user.telephon : ''),
                    currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: user.image == null
                            ? Image.asset('images/samsung_gear')
                            : imageFromBase64String(
                                '${user.image.substring(22)}')),
                  ),
                  new ListTile(
                    leading: Icon(Icons.mode_edit),
                    title: new Text(
                      'Активные заказы',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/order');
                    },
                  ),
                  new ListTile(
                    leading: Icon(Icons.check_circle),
                    title: new Text(
                      'Избранные контейнеры',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/taskIzb');
                    },
                  ),
                  new ListTile(
                    leading: Icon(Icons.person),
                    title: new Text(
                      'Личные данные',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/account');
                    },
                  ),
                  new ListTile(
                    leading: Icon(Icons.person),
                    title: new Text(
                      'Выйти',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/login');
                    },
                  )
                ],
              ),
            ),
            body: _widget(context),
          );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Image imageFromBase64StringWH(
      String base64String, double width, double height) {
    return Image.memory(base64Decode(base64String),
        width: width, height: height, fit: BoxFit.cover);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  _loadUser() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userId = sharedPreferences.getInt('clientId');
    final responseTask = await http.get('$url/client/$userId');
    if (responseTask.statusCode == 200) {
      var userMaps = jsonDecode(utf8.decode(responseTask.bodyBytes));
      var tempUser = User.fromJson(userMaps);
      setState(() {
        user = tempUser;
      });
    }
    String token = sharedPreferences.getString('token');
    final responseContainerCategory = await http.get('$url/orgCategory/all');
    //print(responseTask.statusCode);
    if (responseContainerCategory.statusCode == 200) {
      var containerCategoryMaps =
          jsonDecode(utf8.decode(responseContainerCategory.bodyBytes));
      var containerCategoryList = List<ContainerCategory>();
      for (var containerCategoryMap in containerCategoryMaps) {
        containerCategoryList
            .add(ContainerCategory.fromJson(containerCategoryMap));
      }
      setState(() {
        containerCategory = containerCategoryList;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  _select(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("category", id);
  }

  Widget _widget(BuildContext context) {
    return ListView.builder(
        itemCount: containerCategory.length,
        itemBuilder: (context, i) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: RaisedButton(
              onPressed: () {
                _select(containerCategory[i].id);
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ContainersPage()));
              },
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2.0,
                            blurRadius: 5.0),
                      ]),
                  margin: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        child: imageFromBase64StringWH(
                          containerCategory[i].image.contains('jpeg')
                              ? containerCategory[i].image.substring(23)
                              : containerCategory[i].image.substring(22),
                          90,
                          90,
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(containerCategory[i].name),
                              /*Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0, bottom: 2.0),
                                child: Text(
                                  finalString,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                "Min. Order: ${object["minOrder"]}",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black54),
                              )*/
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
