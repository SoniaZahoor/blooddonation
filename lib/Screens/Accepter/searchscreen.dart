// ignore_for_file: unnecessary_string_interpolations

import 'package:assignmen_1/Screens/Accepter/send_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _bloodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  Stream<QuerySnapshot> _getStream() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("Donor");
    Query query = collectionReference;

    String blood = _bloodController.text.trim();
    String city = _cityController.text.trim();
    String area = _areaController.text.trim();

    if (blood.isNotEmpty) {
      query = query.where("Blood Group", isEqualTo: blood);
    }

    if (city.isNotEmpty) {
      query = query.where("City", isEqualTo: city);
    }

    if (area.isNotEmpty) {
      query = query.where("Area", isEqualTo: area);
    }

    return query.snapshots();
  }

  void _searchdonor() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Search Donor"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _bloodController,
              decoration: const InputDecoration(
                hintText: "Blood Group..",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: "Enter City name..",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: _areaController,
              decoration: const InputDecoration(
                hintText: "Enter Area..",
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: const Size(350, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {
              _searchdonor();
            },
            child: const Text(
              "S e a r c h",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot document = documents[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Text(document['Blood Group']),
                              title: Text(document["Name"]),
                              subtitle: Text(document["City"]),
                              trailing: Text(document["Area"]),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                String mydonorid = document['Donoremail'];
                                print(document['Donoremail']);
                                Get.to(() => const Requesttodonor(),
                                    arguments:
                                        MyPageArguments(donorid: '$mydonorid'));
                                setState(() {});
                              },
                              child: const Text(
                                ' R e q u e s t ',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyPageArguments {
  final String donorid;

  MyPageArguments({
    required this.donorid,
  });
}
