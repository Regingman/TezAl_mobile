import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/login_page.dart';

import 'main.dart';
import 'menu_page.dart';
import 'model/user.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoading = true;
  List<Male> _companies = Male.getCompanies();
  List<DropdownMenuItem<Male>> _dropdownMenuItems;
  Male _selectedCompany;
  User user = new User();

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController patronymic = new TextEditingController();
  final TextEditingController tehelphone = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    _loadUser();
    super.initState();
  }

  _loadUser() async {
    String url = TezAL.getUrl;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userId = sharedPreferences.getInt('clientId');
    int deviceuUserId = sharedPreferences.getInt('deviceId');
    final responseTask = await http.get('$url/client/$userId');

    final responseTaskDevice =
        await http.get('$url/clientDevice/$deviceuUserId');
    var tempUser;
    if (responseTask.statusCode == 200) {
      var userMaps = jsonDecode(utf8.decode(responseTask.bodyBytes));
      tempUser = User.fromJson(userMaps);
    }
    if (responseTaskDevice.statusCode == 200) {
      var userMaps = jsonDecode(utf8.decode(responseTaskDevice.bodyBytes));
      // print(userMaps);
      tempUser.telephon = userMaps['phoneNumber'];
      tempUser.password = userMaps['password'];
    }
    setState(() {
      user = tempUser;
      firstName.text = user.firstName;
      lastName.text = user.lastName;
      patronymic.text = user.patronymic;
      tehelphone.text = user.telephon;
      password.text = user.password;
      _isLoading = false;
    });
  }

  List<DropdownMenuItem<Male>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Male>> items = List();
    for (Male company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Male selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.orange));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.orangeAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  textSection(),
                  _female(),
                  textSectionTwo(),
                  buttonSection(),
                ],
              ),
      ),
    );
  }

  signIn(String firstName, lastName, patronymic, female) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userId = sharedPreferences.getInt('clientId');

    int deviceuUserId = sharedPreferences.getInt('deviceId');
    Map data = {
      'phoneNumber': tehelphone.text,
      'password': password.text,
    };
    String url = TezAL.getUrl;
    var responseDevice = await http.put("$url/clientDevice/$deviceuUserId",
        headers: {"Content-Type": "application/json"},
        body: utf8.encode(json.encode(data)));

    Map dataTwo = {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'patronymic': patronymic.trim(),
      'female': female
    };
    var response = await http.put("$url/client/$userId",
        headers: {"Content-Type": "application/json"},
        body: utf8.encode(json.encode(dataTwo)));
    _isLoading = false;
    //  print(response.statusCode);
    //print(responseDevice.body);
    Navigator.of(context).pop();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new MenuPage()));
    //if (response.statusCode == 200) {}
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:
            firstName.text == "" || lastName.text == "" || patronymic.text == ""
                ? null
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    signIn(firstName.text, lastName.text, patronymic.text,
                        _selectedCompany.name);
                  },
        elevation: 0.0,
        color: Colors.indigo,
        child: Text("Изменить", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: firstName,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Text("Имя"),
              hintText: "Имя",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: lastName,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Text("Фамилия"),
              hintText: "Фамилия",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: patronymic,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Text("Отчество"),
              hintText: "Отчество",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container _female() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
              value: _selectedCompany,
              items: _dropdownMenuItems,
              onChanged: onChangeDropdownItem,
            ),
          ],
        ),
      ),
    );
  }

  Container textSectionTwo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: tehelphone,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Text("Телефон"),
              hintText: "Телефон",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: password,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Text("Пароль"),
              hintText: "Пароль",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class Male {
  int id;
  String name;

  Male(this.id, this.name);

  static List<Male> getCompanies() {
    return <Male>[
      Male(1, 'MALE'),
      Male(2, 'FEMALE'),
    ];
  }
}
