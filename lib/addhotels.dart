import 'dart:io';
import 'package:app_cityguide/addcategory.dart';
import 'package:app_cityguide/addcity.dart';
import 'package:app_cityguide/addhistoricalsites.dart';
import 'package:app_cityguide/addrestaurant.dart';
import 'package:app_cityguide/addshopping.dart';
import 'package:app_cityguide/adminprofile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

void main() async {
  FirebaseStorage.instance.bucket = 'gs://cityguide-1de67.appspot.com';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(addhotels(
    uId: 'uId',
  ));
}

class addhotels extends StatefulWidget {
  final String uId;

  const addhotels({Key? key, required this.uId}) : super(key: key);
  @override
  _addhotelsState createState() => _addhotelsState();
}

class _addhotelsState extends State<addhotels> {
  late TextEditingController hotelNameController;
  late TextEditingController hotelAddressController;
  late TextEditingController cityNameController;
  late TextEditingController categoriesController;
  late TextEditingController hotelHoursController;
  late TextEditingController hotelContactController;
  late TextEditingController hotelDescriptionController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    hotelNameController = TextEditingController();
    hotelAddressController = TextEditingController();
    cityNameController = TextEditingController();
    categoriesController = TextEditingController();
    hotelHoursController = TextEditingController();
    hotelContactController = TextEditingController();
    hotelDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    hotelNameController.dispose();
    hotelAddressController.dispose();
    cityNameController.dispose();
    categoriesController.dispose();
    hotelHoursController.dispose();
    hotelContactController.dispose();
    hotelDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImageAndAddHotel() async {
    if (_imageFile == null) {
      print('No image selected.');
      return;
    }

    try {
      // Upload image to Firebase Storage
      String imagePath = await _uploadImageToStorage();

      // Add hotel details to Firestore
      await FirebaseFirestore.instance.collection('hotels').add({
        'hotelName': hotelNameController.text,
        'hotelAddress': hotelAddressController.text,
        'cityName': cityNameController.text,
        'categoriesName': categoriesController.text,
        'hotelHours': hotelHoursController.text,
        'hotelContact': hotelContactController.text,
        'hotelDescription': hotelDescriptionController.text,
        'hotelId': randomAlphaNumeric(10), // Generate random hotelId
        'hotelImage': imagePath,
      });

      // Show success message or navigate to a different screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hotel details added successfully!'),
        ),
      );
    } catch (error) {
      // Handle any errors that occur during saving
      print('Error saving hotel details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  Future<String> _uploadImageToStorage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('$fileName.jpg');
    await ref.putFile(_imageFile!);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hotel'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null) ...[
              Image.file(
                _imageFile!,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Select Image'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: hotelNameController,
              decoration: InputDecoration(
                labelText: 'Hotel Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: hotelAddressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cityNameController,
              decoration: InputDecoration(
                labelText: 'City Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoriesController,
              decoration: InputDecoration(
                labelText: 'Categories',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: hotelHoursController,
              decoration: InputDecoration(
                labelText: 'Hotel Hours',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: hotelContactController,
              decoration: InputDecoration(
                labelText: 'Contact',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: hotelDescriptionController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImageAndAddHotel,
              child: Text('Add Hotel'),
            ),
          ],
        ),
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
                  leading: Icon(Icons.add_location),
                  title: const Text('Add City'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCityPage(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  title: const Text('Add Category'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addcategory(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.restaurant),
                  title: const Text('Add Restaurant'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddRestaurantPage(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: const Text('Add Shopping'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addshopping(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.hotel),
                  title: const Text('Add hotels'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addhotels(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_city),
                  title: const Text('Add Historical Sites'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addhistoricalsites(
                                uId: widget.uId,
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: const Text('adminprofile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => adminprofile(uId: widget.uId)),
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
}
