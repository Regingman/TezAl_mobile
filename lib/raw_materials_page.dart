import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/menu_page.dart';
import 'package:tezal/model/raw_material.dart';
import 'main.dart';

class RawMaterialScreen extends StatefulWidget {
  @override
  _RawMaterialScreen createState() => _RawMaterialScreen();
}

class _RawMaterialScreen extends State<RawMaterialScreen> {
  String title;
  List<RawMaterial> products = List<RawMaterial>();
  List<RawMaterial> cart = new List<RawMaterial>();

  //List<Containers> _containersForDisplay = List<Containers>();

  Future<List<RawMaterial>> fetchNotes() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    int id = sharedPreferences.getInt('container');
    final responseContainers = await http.get('$url/rate/model/list/$id');
    //print(responseTask.statusCode);
    if (responseContainers.statusCode == 200) {
      var containersMaps = jsonDecode(responseContainers.body);
      var containersList = List<RawMaterial>();
      for (var containersMap in containersMaps) {
        containersList.add(RawMaterial.fromJson(containersMap));
      }
      return containersList;
    }
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        products.addAll(value);
      });
    });
    super.initState();
  }

  _buildProductCard(int index) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          SizedBox(height: 8.0),
          Text(
            products[index].name != null ? products[index].name : 'i',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  products[index].retailPrice.toString() != null
                      ? products[index].retailPrice.toString()
                      : '',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                FlatButton(
                  padding: EdgeInsets.all(4.0),
                  onPressed: () {
                    !cart.contains(products[index])
                        ? _addToCard(products[index])
                        : _removeToCard(products[index]);
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text(
                    !cart.contains(products[index]) ? '+' : "-",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _addToCard(RawMaterial product) {
    setState(() {
      cart.add(product);
    });
  }

  _removeToCard(RawMaterial product) {
    setState(() {
      cart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Товары'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new MenuPage()));
          },
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12.0, right: 20.0),
                child: InkResponse(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(
                        cart: cart,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_basket,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 8.0,
                right: 16.0,
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      cart.length.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 280.0,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildProductCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<RawMaterial> cart;

  const CartScreen({Key key, this.cart}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
        widget.cart[index].name,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: _buildCounter(index),
      trailing: Text(
        '${widget.cart[index].retailPrice.toStringAsFixed(1)} с',
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
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.black,
            ),
            onPressed: () {
              _countRebuild(-1, index);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              widget.cart[index].count.toString(),
              style: TextStyle(fontSize: 15),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              _countRebuild(1, index);
            },
          ),
        ],
      ),
    );
  }

  _countRebuild(int incr, index) {
    if (widget.cart[index].count == 0 && incr == (-1)) return;

    _summRebuild();
    setState(() {
      widget.cart[index].count += incr;
      widget.cart[index].summ =
          widget.cart[index].count * widget.cart[index].retailPrice;
    });
  }

  _summRebuild() {
    double tempsummto = 0;
    double tempSumm = 0;
    for (var temp in widget.cart) {
      tempSumm = temp.count * temp.retailPrice;
      tempsummto += tempSumm;
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
            "Корзина (${widget.cart.length.toString()})",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView.separated(
          itemCount: widget.cart.length,
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
          height: 80.0,
          child: RaisedButton(
            color: Colors.orange,
            onPressed: () {
              _bye();
            },
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
        ));
  }

  _bye() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int containerId = sharedPreferences.getInt('container');
    int clientId = sharedPreferences.getInt('clientId');
    Map data = {
      'clientId': clientId,
      'organizationId': containerId,
      'ordersStatus': 'AWAITING'
    };
    var response = await http.post("$url/order",
        headers: {"Content-Type": "application/json"},
        body: utf8.encode(json.encode(data)));

    var jsonResponse = json.decode(response.body);
    int orderId = jsonResponse['id'];
    for (var tempCart in widget.cart) {
      Map dataCart = {
        'orderId': orderId,
        'count': tempCart.count,
        'sum': tempCart.summ,
        'rawMaterialId': tempCart.rawMaterialId
      };
      var responseCart = await http.post("$url/order_material",
          headers: {"Content-Type": "application/json"},
          body: utf8.encode(json.encode(dataCart)));

      Navigator.pushNamed(context, '/mainCatalogContainer');
    }
  }
}
