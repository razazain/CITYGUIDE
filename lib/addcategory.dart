// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class addcategory extends StatefulWidget {
  final String uId;
  const addcategory({required this.uId, super.key});

  @override
  State<addcategory> createState() => _addcategoryState();
}

class _addcategoryState extends State<addcategory> {
  TextEditingController Description = TextEditingController();
  TextEditingController categoriesName = TextEditingController();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "ADD CATEGORY",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(214, 189, 144, 12),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: categoriesName,
                decoration:
                    const InputDecoration(hintText: "Enter Category Name"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: Description,
                decoration: const InputDecoration(
                    hintText: "Enter Category Description"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                addcategory();

                addalert();
              },
              child: const Text("ADD"),
            ),
          ],
        ),
      ),
    );
  }

  void addalert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 250, 177, 60),
          title: const Row(
            children: [
              Icon(Icons.check, color: Colors.green),
              Text("Success"),
            ],
          ),
          content: const Text("Your Category Has Been Saved!!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(
                  context,
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addcategory() {
    CollectionReference categories =
        FirebaseFirestore.instance.collection("categories");
    String idd = randomNumeric(4);

    return categories
        .doc(idd)
        .set({
          'categoriesId': idd,
          'categoriesName': categoriesName.text,
          'Description': Description.text,
        })
        //.then((value) => addalert())
        .then((value) => print("Categoriy Add with custom ID: $idd"))
        .catchError((error) => print("Failed something wrong : $error"));
  }
}
