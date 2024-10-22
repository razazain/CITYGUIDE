// ignore_for_file: avoid_print, file_names

import 'package:app_cityguide/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController uName = TextEditingController();
  TextEditingController uEmail = TextEditingController();
  TextEditingController uPassword = TextEditingController();
  bool _obscurePassword = true;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Register",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color.fromARGB(215, 156, 118, 4)),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: uName,
                decoration: const InputDecoration(hintText: "Enter Your Name"),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: uEmail,
                decoration: const InputDecoration(hintText: "Enter Email"),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: uPassword,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (uName.text.isNotEmpty &&
                      uEmail.text.isNotEmpty &&
                      uPassword.text.isNotEmpty) {
                    if (_isValidEmail(uEmail.text)) {
                      addUser();
                      addalert();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter a valid email')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('All fields are required')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(215, 156, 118, 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text('Already Registered? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addUser() {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    String id = randomNumeric(4);
    return users
        .doc(id)
        .set(
          {
            'uId': id,
            'uName': uName.text,
            'uEmail': uEmail.text,
            'uPassword': uPassword.text,
            'uRole': 'customer'
          },
        )
        .then(
          (value) => print("User Added successfully with id#$id"),
        )
        .catchError(
          (error) => print("some error: $error"),
        );
  }

  void addalert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50],
          title: const Row(
            children: [
              Icon(Icons.check, color: Colors.green),
              Text("Success"),
            ],
          ),
          content: const Text("Record added succesfully"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
