import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

String username = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App with MYSQL',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();

    futureAlbum = fetchAlbum();
  }

  Future<List> senddata() async {
    final response =
        await http.post("https://laagbe.com/insertdata.php", body: {
      "name": name.text,
      "email": email.text,
      "mobile": mobile.text,
    });
  }

  Future<Album> fetchAlbum() async {
    final response = await http.get("https://laagbe.com/alldata.php");
    // final response =
    // await http.get("https://jsonplaceholder.typicode.com/albums/1");
    // var data = jsonDecode(response.body);
    //print(data);
    print('getEmployees Response: ${response.body}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Album.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'name'),
              ),
              Text(
                "Email",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              Text(
                "Mobile",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: mobile,
                decoration: InputDecoration(hintText: 'Mobile'),
              ),
              RaisedButton(
                child: Text("Register"),
                onPressed: () {
                  senddata();
                },
              ),
              // Text(
              //   name.toString(),
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // Text(
              //   "Username",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // Text(
              //   "Username",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // Text(
              //   "Username",
              //   style: TextStyle(fontSize: 18.0),
              // )
              FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.name);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Album {
  final int id;
  final String name;
  final String email;
  final String mobile;

  Album({this.id, this.name, this.email, this.mobile});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}
