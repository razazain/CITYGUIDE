import 'package:app_cityguide/addcategory.dart';
import 'package:app_cityguide/addcity.dart';
import 'package:app_cityguide/addhistoricalsites.dart';
import 'package:app_cityguide/addhotels.dart';
import 'package:app_cityguide/addrestaurant.dart';
import 'package:app_cityguide/addshopping.dart';
import 'package:app_cityguide/cities.dart';
import 'package:app_cityguide/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class adminprofile extends StatefulWidget {
  final String uId;

  const adminprofile({Key? key, required this.uId}) : super(key: key);

  @override
  State<adminprofile> createState() => _adminprofileState();
}

class _adminprofileState extends State<adminprofile> {
  TextEditingController _uEmailcontroller = TextEditingController();
  TextEditingController _uNamecontroller = TextEditingController();
  TextEditingController _uPasswordcontroller = TextEditingController();

  late Future<DocumentSnapshot> _userData;
  @override
  void initState() {
    super.initState();
    _userData = getUserData();
  }

  Future<DocumentSnapshot> getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uId)
        .get();
  }

  Future<void> updateUserData() async {
    try {
      // Extract text from TextEditingController objects
      String email = _uEmailcontroller.text;
      String name = _uNamecontroller.text;
      String passwrod = _uPasswordcontroller.text;

      // Update Firestore document with extracted text values
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uId)
          .update({'uEmail': email, 'uName': name, 'uPassword': passwrod});

      // Reload user data after update
      setState(() {
        _userData = getUserData();
      });

      Navigator.of(context).pop(); // Close the dialog after update
    } catch (e) {
      print('Error updating user data: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user data. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await showLogoutSuccessAlert(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: "City Guide",
                )));
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "ADMIN PROFILE",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(214, 189, 144, 12),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                String uEmail = userData['uEmail'] ?? '';
                String uName = userData['uName'] ?? '';
                String uPassword = userData['uPassword'] ?? '';

                _uEmailcontroller.text = uEmail;
                _uNamecontroller.text = uName;
                _uPasswordcontroller.text = uPassword;

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Email: $uEmail',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'User Name: $uName',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'User Password: $uPassword',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Update User Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _uEmailcontroller,
                                    decoration:
                                        InputDecoration(labelText: 'New Email'),
                                  ),
                                  TextField(
                                    controller: _uNamecontroller,
                                    decoration:
                                        InputDecoration(labelText: 'New Name'),
                                  ),
                                  TextField(
                                    controller: _uPasswordcontroller,
                                    decoration: InputDecoration(
                                        labelText: 'New Password'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: updateUserData,
                                  child: Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Update Details'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => logout(),
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                );
              },
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

  Future<void> showLogoutSuccessAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Successful'),
          content: Text('You have been logged out successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
