import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/menu_page.dart';
import 'package:tezal/model/raw_material.dart';
import 'package:tezal/raw_materials_page.dart';
import 'main.dart';
import 'model/containers.dart';
import 'model/order.dart';
import 'model/order_cart.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Заказы'),
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
        body: new OrdersScreen());
  }
}

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreen createState() => _OrdersScreen();
}

class _OrdersScreen extends State<OrdersScreen> {
  List<Order> container = List<Order>();
  List<Order> _containersForDisplay = List<Order>();

  Future<List<Order>> fetchNotes() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    int id = sharedPreferences.getInt('clientId');
    final responseContainers = await http.get('$url/order/all/client/$id',
        headers: {"Authorization": "Bearer_$token"});
    //print(responseTask.statusCode);
    if (responseContainers.statusCode == 200) {
      //print(responseTask.body);
      var containersMaps = jsonDecode(utf8.decode(responseContainers.bodyBytes));
      var containersList = List<Order>();
      for (var containersMap in containersMaps) {
        containersList.add(Order.fromJson(containersMap));
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
              var noteTitle = _container.organizationName.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

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
              Icons.shop,
              color: Colors.black,
            ),
          ),
          title: Text(
            '${_containersForDisplay[index].organizationName} ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            _container(_containersForDisplay[index].id);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new OrderCartScreen()));
          },
        ),
      ),
    );
  }

  _container(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("orderId", id);
    print(id);
  }
}

class OrderCartScreen extends StatefulWidget {
  @override
  _OrderCartScreen createState() => _OrderCartScreen();
}

class _OrderCartScreen extends State<OrderCartScreen> {
  List<OrderCart> cart = [];
  double summ = 0;
  _buildCartProduct(int index) {
    return ListTile(
      contentPadding: EdgeInsets.all(20.0),
      leading: Image(
        height: double.infinity,
        width: 100.0,
        image: AssetImage('assets/images/powerofhabit.jpg'
            //widget.cart[index].imageUrl,
            ),
        fit: BoxFit.contain,
      ),
      title: Text(
        cart[index].rawMaterialName,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: _buildCounter(index),
      trailing: Text(
        '${cart[index].rawMaterialVolume.toStringAsFixed(1)} с',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCounter(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'Количество ${cart[index].count.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getOrderCart().then((value) {
      setState(() {
        cart.addAll(value);
      });
    });
    super.initState();
  }

  _summRebuild() {
    if (cart == null) return;
    double tempsummto = 0;
    for (var temp in cart) {
      tempsummto += temp.sum;
    }
    setState(() {
      summ = tempsummto;
    });
  }

  @override
  Widget build(BuildContext context) {
    _summRebuild();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Корзина (${cart.length.toString()})",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.separated(
        itemCount: cart.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCartProduct(index);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[300],
          );
        },
      ),
      bottomSheet: Container(
        color: Colors.orange,
        height: 80.0,
        child: Center(
          child: Text(
            'Стоимость $summ сом',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<OrderCart>> _getOrderCart() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    int id = sharedPreferences.getInt('orderId');
    final responseContainers = await http.get(
        '$url/order_material/all?orderId=$id',
        headers: {"Authorization": "Bearer_$token"});
    //print(responseTask.statusCode);
    if (responseContainers.statusCode == 200) {
      print(responseContainers.body);
      var containersMaps = jsonDecode(responseContainers.body);
      var containersList = List<OrderCart>();
      for (var containersMap in containersMaps) {
        containersList.add(OrderCart.fromJson(containersMap));
      }
      return containersList;
    }
  }
}
