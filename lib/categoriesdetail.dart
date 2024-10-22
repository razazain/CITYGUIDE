import 'package:app_cityguide/cities.dart';
import 'package:app_cityguide/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class categoriesdetail extends StatefulWidget {
  final String documentID;
  final String categoriesName;
  final String uId;
  const categoriesdetail({
    required this.categoriesName,
    required this.documentID,
    required this.uId,
    Key? key,
  }) : super(key: key);

  @override
  State<categoriesdetail> createState() => categoriesdetailState();
}

class categoriesdetailState extends State<categoriesdetail> {
  bool isFavorite = false;

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
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              _toggleFavorite(widget.documentID, widget.uId, isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(_getCollectionName(widget.categoriesName))
            .doc(widget.documentID)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          var documentData = snapshot.data!.data() as Map<String, dynamic>;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: _buildDetailItems(documentData),
          );
        },
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

  List<Widget> _buildDetailItems(Map<String, dynamic> documentData) {
    switch (widget.categoriesName) {
      case 'restaurants':
        return [
          Stack(
            children: [
              Image.network(
                documentData['rImage'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  documentData['rName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['rDescription']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'ADDRESS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['rAddress']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'TIME',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['Hours']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(215, 156, 118, 4).withOpacity(0.5),
                child: Text(
                  '${documentData['Contact']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ];
      case 'hotels':
        return [
          Stack(
            children: [
              Image.network(
                documentData['hotelImage'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  documentData['hotelName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['hotelDescription']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'ADDRESS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['hotelAddress']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'TIME',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['hotelHours']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(215, 156, 118, 4).withOpacity(0.5),
                child: Text(
                  '${documentData['HotelContact']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ];

      case 'historicalsites':
        return [
          Stack(
            children: [
              Image.network(
                documentData['hImage'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  documentData['hName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['hDescription']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'ADDRESS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['hAddress']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'TIME',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['hHours']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(215, 156, 118, 4).withOpacity(0.5),
                child: Text(
                  '${documentData['hContact']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ];
      case 'shopping':
        return [
          Stack(
            children: [
              Image.network(
                documentData['shoppingImage'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  documentData['shoppingName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['shoppingDescription']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'ADDRESS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['shoppingAddress']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'TIME',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${documentData['shoppingHours']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(215, 156, 118, 4).withOpacity(0.5),
                child: Text(
                  '${documentData['shoppingContact']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ];
      default:
        return [
          const Text('No data available'),
        ];
    }
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

  void _toggleFavorite(String documentID, String uId, bool isFavorite) {
    if (isFavorite) {
      String id = randomNumeric(4);

      FirebaseFirestore.instance.collection("favourite").doc(id).set({
        "favouriteId": id,
        "categoryId": documentID,
        "userId": uId,
      });
    } else {
      FirebaseFirestore.instance
          .collection("favourite")
          .where("categoryId", isEqualTo: documentID)
          // .where("documentID", isEqualTo: documentID)
          .where("uId", isEqualTo: uId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    }
  }
}
