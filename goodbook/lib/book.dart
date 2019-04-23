class Book {
  String title, url;
  Book(this.title, this.url);
}

class Book1 {
  String title,
      writer,
      price,
      image,
      description;
    String pages;
  double rating;

  Book1(
      this.title, this.writer, this.price, this.image, this.rating, this.pages,this.description);

  factory Book1.fromJson(Map<String, dynamic> json){
    return new Book1(
      json['volumeInfo']['title'].toString()!=null?json['volumeInfo']['title'].toString():"",
      json['volumeInfo']['authors'].toString()!=null?json['volumeInfo']['authors'].toString():"",
      '10',
        json['volumeInfo']["imageLinks"]!=null?json['volumeInfo']["imageLinks"]["thumbnail"]:null,
        8,
        json['volumeInfo']['pageCount'].toString()!=null?json['volumeInfo']['pageCount'].toString():"",
        json['volumeInfo']['description'].toString()!=null?json['volumeInfo']['description'].toString():""
    );
  }
}

class BookList{
  List<Book1> books = new List<Book1>();

  BookList({this.books});

  factory BookList.fromJson(List<dynamic> parsedJson) {

    List<Book1> booksList = new List<Book1>();
    booksList = parsedJson.map((i)=>Book1.fromJson(i)).toList();

    return new BookList(
      books: booksList,
    );
  }
}



/*
final List<Book1> books = [
  Book1('CorelDraw untuk Tingkat Pemula Sampai Mahir', 'Jubilee Enterprise',
      'Rp 50.000', 'res/corel.jpg', 3.5, 123),
  Book1('Buku Pintar Drafter Untuk Pemula Hingga Mahir', 'Widada', 'Rp 55.000',
      'res/drafter.jpg', 4.5, 200),
  Book1('Adobe InDesign: Seri Panduan Terlengkap', 'Jubilee Enterprise',
      'Rp 60.000', 'res/indesign.jpg', 5.0, 324),
  Book1('Pemodelan Objek D  engan 3Ds Max 2014', 'Wahana Komputer', 'Rp 58.000',
      'res/max_3d.jpeg', 3.0, 200),
  Book1('Penerapan Visualisasi 3D Dengan Autodesk Maya', 'Dhani Ariatmanto',
      'Rp 90.000', 'res/maya.jpeg', 4.8, 234),
  Book1('Teknik Lancar Menggunakan Adobe Photoshop', 'Jubilee Enterprise',
      'Rp 57.000', 'res/photoshop.jpg', 4.5, 240),
  Book1('Adobe Premiere Terlengkap dan Termudah', 'Jubilee Enterprise',
      'Rp 56.000', 'res/premier.jpg', 4.8, 432),
  Book1('Cad Series : Google Sketchup Untuk Desain 3D', 'Wahana Komputer',
      'Rp 55.000', 'res/sketchup.jpeg', 4.5, 321),
  Book1('Webmaster Series : Trik Cepat Menguasai CSS', 'Wahana Komputer',
      'Rp 54.000', 'res/webmaster.jpeg', 3.5, 431),
];
*/
