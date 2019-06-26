import 'package:flutter/material.dart';
import 'package:httplearning/api_service.dart';

void main() => runApp(App());

class URLs {
  static const BASE_API_URL = "https://jsonplaceholder.typicode.com";
}

class App extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
        title: 'Flutter demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Login());
  }
}

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isloading = false;
  TextEditingController _usernameController = new TextEditingController();

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Log in'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
              Container(
                height: 20,
              ),
              SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: new RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      final users = await ApiService.getUserList();
                      setState(() {
                        _isloading = false;
                      });
                      if (users == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Check your internet connection'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                        return;
                      } else {
                        final userwithUsernameExists = users.any(
                            (u) => u['username'] == _usernameController.text);
                        if (userwithUsernameExists) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Post()));
                        } else {}
                      }
                    },
                  )),
            ],
          )),
    );
  }
}

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('posts'),
      ),
      body: FutureBuilder(
        future: ApiService.getPostList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final posts = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(height: 2, color: Colors.black);
              },
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    posts[index]['title'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(posts[index]['body']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Posts(posts[index]['id']),
                        ));
                  },
                );
              },
              itemCount: posts.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Posts extends StatelessWidget {
  final int _id;

  Posts(this._id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: ApiService.getPosts(_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    Text(snapshot.data['title'],
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(snapshot.data['body']),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Container(
            height: 20.0,
          ),
          Divider(color: Colors.black, height: 3.0),
          Container(
            height: 20.0,
          ),
          FutureBuilder(
            future: ApiService.getCommentsforPosts(_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final comments = snapshot.data;
                return Expanded(
                  child: new ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(height: 2, color: Colors.black);
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        comments[index]['name'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(comments[index]['body']),
                      // onTap: (){
                      //   Navigator.push(context,
                      //   MaterialPageRoute(
                      //     builder: (context)=>Posts(posts[index]['id']),
                      //   )
                      //   );
                      // },
                );
                  },
                  itemCount: comments.length,
                )
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
