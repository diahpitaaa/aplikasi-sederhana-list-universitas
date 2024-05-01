import 'package:flutter/material.dart'; // Package untuk membuat UI Flutter
import 'package:http/http.dart' as http; // Package untuk membuat HTTP requests
import 'dart:convert'; // Package untuk mengonversi data

class UnivPage {
  // Atribut untuk menampung nama universitas
  String name;
  // Atribut untuk menampung kode alpha dua universitas
  String alphaTwoCode;
  // Atribut untuk menampung negara universitas
  String country;
  // Atribut untuk menampung daftar domain universitas
  List<String> domains;
  // Atribut untuk menampung daftar halaman web universitas
  List<String> webPages;

  // Constructor untuk inisialisasi objek UnivPage
  UnivPage({required this.name, required this.alphaTwoCode, required this.country, required this.domains, required this.webPages});
}

class Univ {
  // Atribut untuk menampung daftar objek UnivPage
  List<UnivPage> ListPop = <UnivPage>[];

  // Constructor untuk inisialisasi objek Univ
  Univ(List<dynamic> json) {
    // Looping untuk mengonversi data JSON ke objek UnivPage
    for (var val in json) {
      // Konversi data JSON ke atribut objek UnivPage
      var name = val["name"];
      var alphaTwoCode = val["alpha_two_code"];
      var country = val["country"];
      var domains = List<String>.from(val["domains"]);
      var webPages = List<String>.from(val["web_pages"]);
      // Tambahkan objek UnivPage ke daftar
      ListPop.add(UnivPage(name: name, alphaTwoCode: alphaTwoCode, country: country, domains: domains, webPages: webPages));
    }
  }

  // Method untuk mengonversi data JSON ke objek Univ
  factory Univ.fromJson(List<dynamic> json) {
    // Konversi data JSON ke objek Univ
    return Univ(json);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Univ> futurePopulasi;

  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  Future<Univ> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Univ.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePopulasi = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Populations',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('University Populations'),
        ),
        body: Center(
          child: FutureBuilder<Univ>(
            future: futurePopulasi,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: ListView.builder(
                    itemCount: snapshot.data!.ListPop.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5, // Atur elevasi kartu
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Atur margin kartu
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Atur penempatan teks ke kiri
                            children: [
                              Text(
                                'Name: ${snapshot.data!.ListPop[index].name}', // Tampilkan nama universitas
                                style: TextStyle(fontWeight: FontWeight.bold), // Teks bold
                              ),
                              SizedBox(height: 8), // Buat jarak vertikal antara teks
                              Text('Alpha Code: ${snapshot.data!.ListPop[index].alphaTwoCode}'), // Tampilkan kode alpha dua universitas
                              Text('Country: ${snapshot.data!.ListPop[index].country}'), // Tampilkan negara universitas
                              Text('Domains: ${snapshot.data!.ListPop[index].domains.join(', ')}'), // Tampilkan daftar domain universitas
                              Text('Web Pages: ${snapshot.data!.ListPop[index].webPages.join(', ')}'), // Tampilkan daftar halaman web universitas
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
