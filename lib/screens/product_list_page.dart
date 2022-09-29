import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './add_product_page.dart';
import '../widgets/product_row_item.dart';
import '/services/firebase_services.dart';

import '../services/firebase_services.dart';

class ProductListPage extends StatelessWidget {
  final CollectionReference _productsRef = FirebaseServices().productsRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: snapshot.data.docs.map(
                    (document) {
                      return ProductRowItem(
                        id: document.id,
                        imageUrl: document.data()['images'][0],
                        price: document.data()["price"],
                        title: document.data()['name'],
                      );
                    },
                  ).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
