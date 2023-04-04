// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Donornotification extends StatefulWidget {
  const Donornotification({super.key});

  @override
  State<StatefulWidget> createState() {
    return Donornotificationstate();
  }
}

class Donornotificationstate extends State {
  String myString = '';

// SharedPreferences prefs = await SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    myString = prefs.getString('donoremail') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String mydonor = myString;
    final Query<Map<String, dynamic>> usersCollection = FirebaseFirestore
        .instance
        .collection('AccepterRequest')
        .where('Donorid', isEqualTo: mydonor);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        ListTile(
                          textColor: Colors.black,
                          title: Text('Name: ' +
                              snapshot.data!.docs[index]['AccepName']),
                          subtitle: Text('Address: ' +
                              snapshot.data!.docs[index]['Address']),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('AccepterRequest')
                                      .where('Donorid', isEqualTo: mydonor)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs
                                        .forEach((documentSnapshot) {
                                      documentSnapshot.reference
                                          .update({'Status': true});
                                    });
                                  });
                                  Get.snackbar(
                                      'Approved', 'You have aproved it',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                },
                                child: const Text(' A p p r o v e '),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: () {
                                  Get.snackbar(
                                    'Rejected',
                                    'You have Rejected it',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: const Text(' R e j e c t '),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
