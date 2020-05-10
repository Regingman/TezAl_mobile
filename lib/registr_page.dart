import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/login_page.dart';

import 'main.dart';
import 'menu_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  List<Male> _companies = Male.getCompanies();
  List<DropdownMenuItem<Male>> _dropdownMenuItems;
  Male _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
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
                  buttonSection(),
                  buttonSectionLogin()
                ],
              ),
      ),
    );
  }

  signIn(String firstName, lastName, patronymic, female) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'firstName': firstName.trim(), 'lastName': lastName.trim(), 'patronymic':patronymic.trim(), 'female':female};
    var jsonResponse;
    String url = TezAL.getUrl;
    var response = await http.post("$url/client",
        headers: {"Content-Type": "application/json"},
        body: utf8.encode(json.encode(data)));
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        sharedPreferences.setInt("clientId", jsonResponse['id']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => RegisterPageLVLTwo()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      //print(response.body);
    }
  }

 Container buttonSectionLogin() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:(){
           Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);

                  },
        elevation: 0.0,
        color: Colors.indigo,
        child: Text("Войти", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
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
        child: Text("Далее", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController patronymic = new TextEditingController();

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
              icon: Icon(Icons.text_fields, color: Colors.white70),
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
              icon: Icon(Icons.text_fields, color: Colors.white70),
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
              icon: Icon(Icons.text_fields, color: Colors.white70),
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

class RegisterPageLVLTwo extends StatefulWidget {
  @override
  _RegisterPageLVLTwoState createState() => _RegisterPageLVLTwoState();
}

class _RegisterPageLVLTwoState extends State<RegisterPageLVLTwo> {
  bool _isLoading = false;
  
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
                  buttonSection(),
                  buttonSectionLogin()
                ],
              ),
      ),
    );
  }

Container buttonSectionLogin() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:(){
           Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);

                  },
        elevation: 0.0,
        color: Colors.indigo,
        child: Text("Войти", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  _signIn(String firstName, lastName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int clientId = sharedPreferences.getInt('clientId');
    print(clientId);
    Map client = {'id':clientId};
    Map data = {'client': client, 'phoneNumber': firstName.trim(), 'password': lastName, 'imei':'imei',
    'status':true, 'lastEnterDate':"2020-10-20"};
    var jsonResponse;
    print(data);
    String url = TezAL.getUrl;
    var response = await http.post("$url/clientDevice",
        headers: {"Content-Type": "application/json"},
        body: utf8.encode(json.encode(data)));
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        sharedPreferences.setInt("clientDeviceId", jsonResponse['id']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MenuPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      //print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:
            firstName.text == "" || lastName.text == "" 
                ? null
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    _signIn(firstName.text, lastName.text);
                  },
        elevation: 0.0,
        color: Colors.indigo,
        child: Text("Завершить регистрацию", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();

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
              icon: Icon(Icons.phone, color: Colors.white70),
              hintText: "Телефон",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: lastName,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
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
