// ignore_for_file: camel_case_types

import 'dart:ui';
import 'package:app_cityguide/categoriesdetail.dart';
import 'package:app_cityguide/cities.dart';
import 'package:app_cityguide/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class categories extends StatefulWidget {
  final String cityName;
  final String categoriesName;
  final String cityImage;
  final String uId;

  const categories(
      {Key? key,
      required this.cityImage,
      required this.cityName,
      required this.uId,
      required this.categoriesName})
      : super(key: key);

  @override
  State<categories> createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(214, 189, 144, 12),
        centerTitle: true,
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/images/cityguide.png'),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Image.network(widget.cityImage, fit: BoxFit.cover),
          ),
          Column(children: [
            Container(
              width: 500,
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.categoriesName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 500,
              color: const Color.fromARGB(215, 156, 118, 4).withOpacity(0.5),
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'Browse your Favourite Place',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(_getCollectionName(widget.categoriesName))
                    .where('cityName', isEqualTo: widget.cityName)
                    //  .where('categoriesName', isEqualTo: widget.categoriesName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                  var collectiondata = snapshot.data?.docs;
                  switch (widget.categoriesName) {
                    case 'restaurants':
                      return ListView.builder(
                        itemCount: collectiondata?.length,
                        itemBuilder: ((context, index) {
                          var document = collectiondata![index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => categoriesdetail(
                                        documentID: document.id,
                                        categoriesName:
                                            document['categoriesName'],
                                        uId: widget.uId),
                                  ),
                                );
                                print("user Id pass succesfully ${widget.uId}");
                              },
                              child: ListTile(
                                title: Text(
                                  '${document['rName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${document['rAddress']}',
                                    ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    document['rImage'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        }),
                      );
                    case 'hotels':
                      return ListView.builder(
                        itemCount: collectiondata?.length,
                        itemBuilder: ((context, index) {
                          var document = collectiondata![index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => categoriesdetail(
                                      documentID: document.id,
                                      categoriesName:
                                          document['categoriesName'],
                                      uId: widget.uId,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  '${document['hotelName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${document['hotelAddress']}',
                                    ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    document['hotelImage'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        }),
                      );
                    case 'historicalsites':
                      return ListView.builder(
                        itemCount: collectiondata?.length,
                        itemBuilder: ((context, index) {
                          var document = collectiondata![index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => categoriesdetail(
                                      uId: widget.uId,
                                      documentID: document.id,
                                      categoriesName:
                                          document['categoriesName'],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  '${document['hName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${document['hAddress']}',
                                    ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    document['hImage'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        }),
                      );
                    case 'shopping':
                      return ListView.builder(
                        itemCount: collectiondata?.length,
                        itemBuilder: ((context, index) {
                          var document = collectiondata![index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => categoriesdetail(
                                      documentID: document.id,
                                      categoriesName:
                                          document['categoriesName'],
                                      uId: widget.uId,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  '${document['shoppingName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${document['shoppingAddress']}',
                                    ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    document['shoppingImage'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        }),
                      );
                    default:
                      const Text("this category is not available");
                  }
                  return const SizedBox();
                },
              ),
            ),
          ])
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uId)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('User data not found');
            }
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            String uName = userData['uName'] ?? 'Unknown';
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(214, 189, 144, 12),
                  ),
                  child: Text(
                    'WELCOME $uName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => profile(uId: widget.uId)),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getCollectionName(String category) {
    switch (category) {
      case 'restaurants':
        return 'restaurants';
      case 'hotels':
        return 'hotels';
      case 'historicalsites':
        return 'historicalsites';
      case 'shopping':
        return 'shopping';
      default:
        throw ArgumentError('Invalid category name: $category');
    }
  }
}
