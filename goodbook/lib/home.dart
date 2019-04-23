import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:goodbook/book.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'detail.dart';
import 'package:dio/dio.dart';


class HomePage extends StatefulWidget {
  _HomePageSate createState() => _HomePageSate();
}

class _HomePageSate extends State<HomePage> {
  File _image;
  var image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "alex-loup-440761-unsplash.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top:140.0),
            child: Column(

              children: <Widget>[
//                Image.asset('bookshelf.png',
//                  fit: BoxFit.cover,
//                  height: 200,
//                ),
                Center(child: _searchBar(context)),
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget _searchBar(context) {
    return Container(
      decoration: BoxDecoration(
        //border: new Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: new BorderRadius.circular(30.0),
      ),
      width: 350,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
      color: Colors.green,
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
          GestureDetector(
            /*onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Detail(books[1])),
              );
            },*/
            child: Container(
              width: 140,
              child: Text("Search books",
                style: TextStyle(
                  //fontFamily: FontNameDefault,
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          _verticalDivider(),
          SizedBox(
            width: 1,
          ),
          IconButton(
            color: Colors.green,
            icon: Icon(Icons.camera_alt),
            onPressed: (){
              getImage();
              if(_image != null)
                _upload(_image);
            },
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 25.0,
      width: 2.2,
      color: Colors.blueAccent,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }

  Future getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void _upload(var file) {
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;


    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add("image", new UploadFileInfo(_image, basename(_image.path)));
    dio.post('http://192.168.1.2:5000/upload', data: formdata, options: Options(
        method: 'POST',
        responseType: ResponseType.json // or ResponseType.JSON
    ))
        .then((response) => print(response))
        .catchError((error) => print(error));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> names = ['mahmoud', 'mostafa', 'mohaned', 'menna'];
  List<String> recent = ['mahmoud'];
  final subject = new PublishSubject<String>();
  List<Book> _items = new List();
  List<Book1> _items1 = new List();
  BookList _bookList =new BookList() ;
  //final subject = new PublishSubject<String>();
  bool _isLoading = false;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    //subject.stream.debounce(new Duration(milliseconds: 600)).listen(_textChanged);
    //_textChanged(query);
    /*http.get("https://www.googleapis.com/books/v1/volumes?q=$query&max-results=40")
        .then((response) => response.body)
        .then(json.decode)
        .then((map) => map["items"])
        .then((list) {list.forEach(_addBook);})
        //.catchError((){}_onError)
        .then((e){});*/
    //loadBooks();

    /*return ListView.builder(
      itemCount: suggestionList.length,

      itemBuilder: (context, index) => ListTile(
        onTap: (){showResults(context);},
            leading: Icon(Icons.ac_unit),
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(
                      color: Colors.grey,

                    ),
                  ),
                ])),
          ),
    );*/
    /*return _bookList.books!=null?
    Container(
      child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemCount: _bookList.books.length,
        itemBuilder: (BuildContext context, int index) {

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Detail(_bookList.books[index])),
              );
            },
            child: Card(
                child: new Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        _bookList.books[index].image != null? new Image.network(_bookList.books[index].image): new Container(),
                        new Flexible(
                          child: new Text(_bookList.books[index].title.toString(), maxLines: 10),
                        ),
                      ],
                    )
                )
            ),
          );
        },
      ),
    )
    :Container();*/
    return FutureBuilder<BookList>(
      future: fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              itemCount: snapshot.data.books.length,
              itemBuilder: (BuildContext context, int index) {

                return InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Detail(snapshot.data.books[index])),
                    );
                  },
                  child: Card(
                      child: new Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              snapshot.data.books[index].image != null? new Image.network(snapshot.data.books[index].image): new Container(),
                              new Flexible(
                                child: new Text(snapshot.data.books[index].title.toString(), maxLines: 10),
                              ),
                            ],
                          )
                      )
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text("eeee${snapshot.error}");
        }

        // By default, show a loading spinner
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _addBook(dynamic book) {
    _items.add(new Book(book["volumeInfo"]["title"], book["volumeInfo"]["imageLinks"]["smallThumbnail"]));

  }
  void _addBook1(dynamic book) {
    //print(book["volumeInfo"]["title"]);
    //print(book["volumeInfo"]["pageCount"]);

    try {
      _items1.add(new Book1(
              book["volumeInfo"]["title"].toString(),
              //book["volumeInfo"]["authors"][0].toString(),
            "mahmoud",
              "10",
              book["volumeInfo"]["imageLinks"]["smallThumbnail"].toString(),
            3.0,
              book["volumeInfo"]["pageCount"].toString(),
        ""
          ));
    } catch (e) {
      print(e);
      _items1.add(new Book1(
        "",

        "mahmoud",
        "10",
        "max_3d.jpeg",
        3.0,
        "100",
        ""
      ));
    }

  }

  @override
  Widget buildSuggestions(BuildContext context) {

    /*loadBooks();
    return
     _bookList.books!=null?
    Container(
      child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemCount: _bookList.books.length,
        itemBuilder: (BuildContext context, int index) {

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Detail(_bookList.books[index])),
              );
            },
            child: Card(
                child: new Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        Hero(
                          tag: _bookList.books[index].title.toString(),
                          child: _bookList.books[index].image != null?
                          new Image.network(_bookList.books[index].image)
                              : new Container(),
                        ),
                        new Flexible(
                          child: new Text(_bookList.books[index].title.toString(), maxLines: 10),
                        ),
                      ],
                    )
                )
            ),
          );
        },
      ),
    )
        :Container();*/

    return FutureBuilder<BookList>(
      future: fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              itemCount: snapshot.data.books.length,
              itemBuilder: (BuildContext context, int index) {

                return InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Detail(snapshot.data.books[index])),
                    );
                  },
                  child: Card(
                      child: new Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              snapshot.data.books[index].image != null? new Image.network(snapshot.data.books[index].image): new Container(),
                              new Flexible(
                                child: new Text(snapshot.data.books[index].title.toString(), maxLines: 10),
                              ),
                            ],
                          )
                      )
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future loadBooks()async{
    try {
      dynamic res = await http.get("https://www.googleapis.com/books/v1/volumes?q=$query&max-results=40");
      res = res.body;
      final jsonResponse = json.decode(res.toString());
      _bookList = BookList.fromJson(jsonResponse['items']);
    } catch (e) {
      print(e);
    }

  }

  void _textChanged(String text) {
    if(text.isEmpty) {
      _isLoading = false;
      _clearList();
      return;
    }
    _isLoading = true;
    _clearList();
    http.get("https://www.googleapis.com/books/v1/volumes?q=$text&max-results=40")
        .then((response) => response.body)
        .then(json.decode)
        .then((map) => map["items"])
        .then((list) {list.forEach(_addBook);})

        .catchError(_onError)
        .then((e){_isLoading = false;});
  }

  void _onError(dynamic d) {
    _isLoading = false;
  }

  void _clearList() {
    _items.clear();
  }

  Future<BookList> fetchPost() async {
    print("https://www.googleapis.com/books/v1/volumes?q=${query.toString()}&max-results=40");
    final response =
    await http.get("https://www.googleapis.com/books/v1/volumes?q=$query&max-results=40");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      print(json.decode(response.body)['items']);
      return BookList.fromJson(json.decode(response.body)['items']);

    } else {
      // If that response was not OK, throw an error.
      //throw Exception('Failed to load post');
    }
  }
}
