import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/menu_page.dart';
import 'package:tezal/raw_materials_page.dart';
import 'main.dart';
import 'model/containers.dart';

class ContainersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Контейнеры'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new MenuPage()));
              },
            )),
        body: new ContainerScreen());

    /* ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
          itemCount: _containersForDisplay.length + 1,
        ))*/
  }
}

class ContainerScreen extends StatefulWidget {
  @override
  _ContainerScreen createState() => _ContainerScreen();
}

class _ContainerScreen extends State<ContainerScreen> {
  List<Containers> container = List<Containers>();
  List<Containers> _containersForDisplay = List<Containers>();

  Future<List<Containers>> fetchNotes() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    int id = sharedPreferences.getInt('category');
    final responseContainers = await http.get(
        '$url/organization/list/category/$id',
        headers: {"Authorization": "Bearer_$token"});
    //print(responseTask.statusCode);
    if (responseContainers.statusCode == 200) {
      //print(responseTask.body);
      var containersMaps = jsonDecode(responseContainers.body);
      var containersList = List<Containers>();
      for (var containersMap in containersMaps) {
        containersList.add(Containers.fromJson(containersMap));
      }
      return containersList;
    }
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        container.addAll(value);
        _containersForDisplay = container;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (context, index) {
        return index == 0 ? _searchBar() : _listItem(index - 1);
      },
      itemCount: _containersForDisplay.length + 1,
    ));
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Поиск...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _containersForDisplay = container.where((_container) {
              var noteTitle = _container.name.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  /*_listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _containersForDisplay[index].name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _containersForDisplay[index].number.toString(),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
*/
  _listItem(index) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Container(
        decoration: BoxDecoration(color: Colors.orange),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: Container(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.category,
              color: Colors.black,
            ),
          ),
          title: Text(
            '${_containersForDisplay[index].name} ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          onTap: () {
            _container(_containersForDisplay[index].id);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new RawMaterialScreen()));
          },
        ),
      ),
    );
  }

  _container(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("container", id);
  }
}
