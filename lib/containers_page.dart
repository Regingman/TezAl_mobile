import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/menu_page.dart';
import 'package:tezal/raw_materials_page.dart';
import 'data/moor_filename.dart';
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

  List<Task> taskMain = new List<Task>();

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
      var containersMaps =
          jsonDecode(utf8.decode(responseContainers.bodyBytes));
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
    /**/

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

  bool flajok = true;

  _searchBar() {
    if (flajok) _buildTaskList();
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
              color: flag(_containersForDisplay[index].id)
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {
              _buildTextField(_containersForDisplay[index].id,
                  _containersForDisplay[index].name);
            },
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

  bool flag(int id) {
    if (taskMain == null) return false;
    for (int i = 0; i < taskMain.length; i++) {
      if (id == taskMain[i].containerId) {
        return true;
      }
    }
    return false;
  }

  Expanded _buildTextField(int cont, String name) {
    final database = Provider.of<TezAlDb>(context);

    bool flag = false;
    if (taskMain != null)
      for (int i = 0; i < taskMain.length; i++) {
        if (taskMain[i].containerId == cont) {
          flag = true;
        }
      }
    if (flag == false) {
      final task = Task(
        containerId: cont,
        name: name,
      );
      database.insertTask(task);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Оповещение"),
            content: Text("Контейнер был успешно добавлен в список избранных"),
            actions: <Widget>[
              FlatButton(
                child: Text("Закрыть"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ContainersPage()));
                  ;
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Оповещение"),
            content: Text("Контейнер уже есть в списке избранных"),
            actions: <Widget>[
              FlatButton(
                child: Text("Закрыть"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ContainersPage()));
                  ;
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Task>> _buildTaskList() {
    final database = Provider.of<TezAlDb>(context);
    Future<List<Task>> taskTemp = database.getAllTasks();
    taskTemp.then((value) {
      setState(() {
        flajok = false;
        taskMain.addAll(value);
        print(taskMain);
      });
    });
  }

  _container(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("container", id);
  }
}
