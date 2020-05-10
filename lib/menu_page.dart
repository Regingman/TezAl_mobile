import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Разделы')),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName:
                  new Text(user.lastName != null ? user.lastName : ''),
              accountEmail: new Text(user.telephon != null ? user.telephon : ''),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
              ),
            ),
            new ListTile(
              leading: Icon(Icons.mode_edit),
              title: new Text(
                'История покупок',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {},
            ),
            new ListTile(
              leading: Icon(Icons.check_circle),
              title: new Text(
                'Избранные контейнеры',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {},
            ),
            new ListTile(
              leading: Icon(Icons.person),
              title: new Text(
                'Мои скидки',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {},
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

  _loadUser() async {
   /* String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    int userId = sharedPreferences.getInt('user');
    final responseTask = await http.get('$url/client/$userId',
        headers: {"Authorization": "Bearer_$token"});
    if (responseTask.statusCode == 200) {
      var userMaps = jsonDecode(responseTask.body);
      var tempUser = User.fromJson(userMaps);
      setState(() {
        user = tempUser;
      });
    }*/
  }

  _loadCC() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    final responseContainerCategory = await http.get('$url/orgCategory/all');
    //print(responseTask.statusCode);
    if (responseContainerCategory.statusCode == 200) {
      
      var containerCategoryMaps = jsonDecode(utf8.decode(responseContainerCategory.bodyBytes));
      var containerCategoryList = List<ContainerCategory>();
      for (var containerCategoryMap in containerCategoryMaps) {
        containerCategoryList
            .add(ContainerCategory.fromJson(containerCategoryMap));
      }
      setState(() {
        containerCategory = containerCategoryList;
      });
    }
  }

  @override
  void initState() {
    _loadCC();
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
              child: Text(containerCategory[i].name != null
                  ? containerCategory[i].name
                  : null),
            ),
          );
        });
  }
}
