// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

void main() async {
  FirebaseStorage.instance.bucket = 'gs://cityguide-1de67.appspot.com';
  WidgetsFlutterBinding.ensureInitialized();

  /*
  FirebaseStorage storage = FirebaseStorage.instance;
  storage.bucket = 'gs://cityguide-1de67.appspot.com';
  */
  await Firebase.initializeApp();

  runApp(const AddCityPage(
    uId: 'uId',
  ));
}

class AddCityPage extends StatefulWidget {
  final String uId;

  const AddCityPage({super.key, required this.uId});
  @override
  _AddCityPageState createState() => _AddCityPageState();
}

class _AddCityPageState extends State<AddCityPage> {
  late TextEditingController cityNameController;
  late TextEditingController cityDescriptionController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    cityNameController = TextEditingController();
    cityDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    cityNameController.dispose();
    cityDescriptionController.dispose();
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

  Future<void> _uploadImageAndAddCity() async {
    if (_imageFile == null) {
      print('No image selected.');
      return;
    }

    try {
      String imagePath = await _uploadImageToStorage();

      await FirebaseFirestore.instance.collection('city').add({
        'cityName': cityNameController.text,
        'cityDescription': cityDescriptionController.text,
        'cityImage': imagePath,
        'cityId': randomAlphaNumeric(10), 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('City details added successfully!'),
        ),
      );
    } catch (error) {
      print('Error saving city details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        backgroundColor: const Color.fromARGB(214, 189, 144, 12),
        centerTitle: true,
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/images/cityguide.png'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null) ...[
              Image.network(
                  _imageFile!.path), // Display the image using Image.network
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityNameController,
              decoration: const InputDecoration(
                labelText: 'City Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityDescriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'City Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImageAndAddCity,
              child: const Text('Add City'),
            ),
          ],
        ),
      ),
    );
  }
}
