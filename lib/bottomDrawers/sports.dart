import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bottom_bar/Request/post.dart';
import 'package:bottom_bar/detailpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

Future<Post> fetchPostSports() async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=47ada2986be0434699996aaf4902169b');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    //var responseData = Post.fromJson(json.decode(response.body));
    var responseData = json.decode(response.body);
    var post = Post.fromJson(responseData);
    return post;
  } else {
    // If that call was not successful, throw an error.
    Fluttertoast.showToast(
        msg: "Offline",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    throw Exception('Failed to load post');
  }
}

class Sports extends StatelessWidget {
  final Future<Post> post;

  Sports({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: RefreshIndicator(
          onRefresh: fetchPostSports,
          child: Center(
            child: FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemExtent: 150,
                      itemCount: snapshot.data.articles.length,
                      itemBuilder: (BuildContext context, int index) {
                        var dataStored = "";
                        var imageUrl = "";
                        dataStored = snapshot.data.articles[index].title;
                        var finalData = "";
                        if (dataStored.length < 80) {
                          finalData = dataStored;
                        } else {
                          finalData = dataStored.substring(0, 80) + "...";
                        }
                        if (snapshot.data.articles[index].urlToImage == null) {
                          imageUrl = 'assets/placeholder';
                        } else {
                          imageUrl = snapshot.data.articles[index].urlToImage;
                        }
                        return Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (context) {
                                        var article =
                                            snapshot.data.articles[index];
                                        return DetailPage(
                                            title: article.title,
                                            image: article.urlToImage,
                                            author: article.author,
                                            description: article.description,
                                            url: article.url);
                                      }));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                            child: ListTile(
                                          leading: Image(
                                            image: NetworkImage(
                                              imageUrl,
                                            ),
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                          ),
                                          title: Text(
                                            finalData,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ))
                                      ],
                                    ))));
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
