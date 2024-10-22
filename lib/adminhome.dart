import 'package:app_cityguide/addcategory.dart';
import 'package:app_cityguide/addcity.dart';
import 'package:app_cityguide/addhistoricalsites.dart';
import 'package:app_cityguide/addhotels.dart';
import 'package:app_cityguide/addrestaurant.dart';
import 'package:app_cityguide/addshopping.dart';
import 'package:app_cityguide/adminprofile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class adminhome extends StatefulWidget {
  final String uId;
  const adminhome({required this.uId, super.key});

  @override
  State<adminhome> createState() => _adminhomeState();
}

class _adminhomeState extends State<adminhome> {
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
            Container(
              padding: const EdgeInsets.all(18.0),
              child: const Text(
                'Admin Dashboard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(215, 156, 118, 4),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCityPage(
                                  uId: widget.uId,
                            )
                        ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(215, 156, 118, 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Add City",
                      style: TextStyle(color: Colors.white),
                    )),

                ElevatedButton(
                    onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addcategory(
                                uId: widget.uId,
                              )
                              ),
                        );
                    },
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
                    child: Text("Add Category")),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRestaurantPage(
                                uId: widget.uId,
                              )
                            ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(215, 156, 118, 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text("Add Restaurant",
                      style: TextStyle(color: Colors.white)),
                ),

                ElevatedButton(
                    onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => addshopping(
                                uId: widget.uId,
                              )
                          ),
                          );
                    },
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
                    child: Text("Add Shopping")),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addhotels(
                                uId: widget.uId,
                              )
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(215, 156, 118, 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Add Hotels",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => addhistoricalsites(
                                uId: widget.uId,
                              )
                          ),
                          );
                    },
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
                    child: Text("Add Historical Sites")),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => adminprofile(uId: widget.uId)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(215, 156, 118, 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
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
