// ignore_for_file: unnecessary_const, avoid_print

import 'package:app_cityguide/register.dart';
import 'package:app_cityguide/cities.dart';
import 'package:app_cityguide/adminhome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            Container(
              child: const Text(
                "Welcom Back!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color.fromARGB(215, 156, 118, 4)),
              ),
            ),
            const SizedBox(
              height: 25,
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
                  if (uEmail.text.isNotEmpty && uPassword.text.isNotEmpty) {
                    if (_isValidEmail(uEmail.text)) {
                      loginData(uEmail.text, uPassword.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: const Text('Please enter a valid email')));
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
                  "Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                // Navigator.push(context,
                //  MaterialPageRoute(builder: (context) => ForgetPassword()));
              },
              child: const Text(
                'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginData(String uEmail, String uPassword) {
    FirebaseFirestore.instance
        .collection("users")
        .where('uEmail', isEqualTo: uEmail)
        .where('uPassword', isEqualTo: uPassword)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          querySnapshot.docs.forEach(
            (DocumentSnapshot documentSnapshot) {
              Map<String, dynamic> userData =
                  documentSnapshot.data() as Map<String, dynamic>;
              String uRole = userData['uRole']; // Get the value of uRole
              String uId = documentSnapshot.id;
              if (uRole == 'admin') {
                // Redirect to admin dashboard
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => adminhome(
                            uId: uId,
                          )),
                );
              } else {
                // Redirect to home page
                loginsuccess(uId);
              }
            },
          );
        } else {
          print("No data match");
          nodatamatch();
        }
      },
    ).catchError(
      (error) {
        print("Error found: $error");
      },
    );
  }

  void loginsuccess(String uId) {
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
          content: const Text("Login succesfully"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(uId: uId)),
                  );
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  void nodatamatch() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50],
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              Text("Error"),
            ],
          ),
          content: const Text("No data found"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text("OK"),
            )
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
