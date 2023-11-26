import 'package:flutter/material.dart';
import '../functions/function.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Photos extends StatefulWidget {
  const Photos({Key? key});

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  late List<dynamic> lists = [];
  bool isLoading = false;
  bool shouldShowSearchField = true; // Set this based on your condition
  Future<void> filterData(String query) async {
    try {
      setState(() {
        isLoading = true;
      });

      var apiKey = '26840154-b2cc4dd169a66b64d7418b216';
      var url = Uri.parse('https://pixabay.com/api/?key=$apiKey&q=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          lists = jsonDecode(response.body)['hits'] as List<dynamic>;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var apiKey = '26840154-b2cc4dd169a66b64d7418b216';
      var url = Uri.parse('https://pixabay.com/api/?key=$apiKey');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          lists = jsonDecode(response.body)['hits'] as List<dynamic>;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "PIXBAY",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.green),
              // Add GestureDetector to handle taps
              // Conditionally apply it based on shouldShowSearchField
              boxShadow: shouldShowSearchField
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]
                  : [],
            ),
            child: GestureDetector(
              onTap: () {
                // Close the keyboard when tapping outside the text field
                FocusScope.of(context).unfocus();
              },
              child: TextFormField(
                cursorColor: Colors.amber,
                onChanged: (value) {
                  filterData(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search everything',
                  contentPadding: EdgeInsets.all(16.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : lists.length == 0
                      ? Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Image.network(
                                    'https://media3.giphy.com/media/fj2fBq5IQNcbTDZ4ho/giphy.gif?cid=ecf05e47n8oxhnzkm8moa2cnpl7zp2nyhi6kw03xuxnebka5&ep=v1_gifs_search&rid=giphy.gif&ct=g', // Replace with your image URL
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'No data found.',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AutofillHints.birthday),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lists.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          lists[index]['webformatURL'],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ListTile(
                                          title: Text(
                                            lists[index]['user'].toString(),
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Icon(Icons.person),
                                          leading: Container(
                                            height: 60,
                                            width: 60,
                                            child: ClipOval(
                                              child: Image.network(
                                                lists[index]['userImageURL'],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "downloads",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 9),
                                            ),
                                            Icon(Icons.comment),
                                            Text(lists[index]['comments']
                                                .toString())
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            const Text(
                                              "comments",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 9),
                                            ),
                                            Icon(Icons.download),
                                            Text(lists[index]['downloads']
                                                .toString())
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "TAGS:   ${lists[index]['tags']}",
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchURL(lists[index]['pageURL']);
                                    },
                                    child: Text(
                                      "PAGE URL:   ${lists[index]['pageURL']}",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
