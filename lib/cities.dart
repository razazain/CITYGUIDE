// ignore_for_file: avoid_print

import 'package:app_cityguide/citiesdetail.dart';
import 'package:app_cityguide/profile.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final String id;
  final String cityName;
  final String cityDescription;
  final String address;
  final String imagePath;

  City(
      {required this.id,
      required this.address,
      required this.cityDescription,
      required this.cityName,
      required this.imagePath});
}

class HomePage extends StatelessWidget {
  final String uId;
  HomePage({Key? key, required this.uId}) : super(key: key);
  final List<City> famousPlaces = [
    City(
        id: randomNumeric(4),
        cityName: 'Port Grand',
        address:
            'Native Jetty Bridge and M.T. Khan Road, Karachi 74000 Pakistan',
        cityDescription:
            'Port Grand is one of the finest developments that celebrates the city of Karachi with diverse concepts in food, art, leisure, entertainment, adventure, fun and shopping, A cultural hub on Pakistan’s Seaport, celebrations at Port Grand are a truly delightful experience!',
        imagePath: 'assets/images/Karachi/portgrand.jpg'),
    City(
        id: randomNumeric(4),
        cityName: 'TDF Ghar',
        address:
            '	47 Amil Colony No 1, M.A. Jinnah Road, Soldier Bazaar, Catholic Colony',
        cityDescription:
            'The TDF Ghar (House in Urdu) is an informal learning space situated in Karachi, Pakistan. It is a house constructed in the 1930s and restored as a living museum',
        imagePath: 'assets/images/Karachi/tdfghar.jpg'),
    City(
        id: randomNumeric(4),
        cityName: 'Lahore Fort',
        address: '	Lahore, Punjab, Pakistan',
        cityDescription:
            'The Lahore Fort (Punjabi, Urdu: شاہی قلعہ, romanized: Shāhī Qilā, lit. is a citadel in the city of Lahore in Punjab, Pakistan.',
        imagePath: 'assets/images/lahore/lahorefort.jpg'),
    City(
        id: randomNumeric(4),
        cityName: 'Minar-E-Pakistan',
        address: '	Greater Iqbal Park, Circular Road, Lahore',
        cityDescription:
            'Minar-e-Pakistan (Urdu: مینارِ پاکستان, literally "Tower of Pakistan") is a tower located in Lahore, Punjab, Pakistan.[1] The tower was built between 1960 and 1968 on the site where the All-India Muslim League passed the Lahore Resolution (which was later called the Pakistan Resolution) on 23 March 1940 - the first official call for a separate and independent homeland for the Muslims of British India, as espoused by the two-nation theory.',
        imagePath: 'assets/images/lahore/minarepaskitantwo.jpg'),
    City(
        id: randomNumeric(4),
        cityName: 'LakeView Park',
        address: 'Islamabad, Pakistan',
        cityDescription:
            'Lake View Park (also known as Rawal Lake View Point or Rawal Lake Promenade) is a wildlife park, amusement park and adventure park',
        imagePath: 'assets/images/islamabad/lakeview.jpg'),
  ];

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
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18.0),
              child: const Text(
                'Explore New City',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(215, 156, 118, 4),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('city').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var cityData = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => citiesdetail(
                                  cityName: cityData['cityName'],
                                  cityImage: cityData['cityImage'],
                                  uId: uId),
                            ),
                          );
                          print('Tapped on ${cityData[index].id}');
                        },
                        child: GridTile(
                          footer: GridTileBar(
                            backgroundColor: Colors.black54,
                            title: Text(
                              cityData['cityName'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              cityData['cityImage'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              color: const Color.fromARGB(215, 156, 118, 4).withOpacity(0.4),
              child: const Text(
                'Suggested Places',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: famousPlaces.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          _showPlaceDialog(context, famousPlaces[index]);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                famousPlaces[index].imagePath,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                famousPlaces[index].cityName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ), //DRAWER
      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uId).get(),
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
                                uId: uId,
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
                          builder: (context) => profile(uId: uId)),
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

  void _showPlaceDialog(BuildContext context, City city) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(city.cityName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                city.imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                'Description: ${city.cityDescription}',
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Text(
                'Address: ${city.address}',
                textAlign: TextAlign.start,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
