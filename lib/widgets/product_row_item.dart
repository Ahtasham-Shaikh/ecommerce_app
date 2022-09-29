import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firebase_services.dart';
import '../screens/edit_product_page.dart';

class ProductRowItem extends StatelessWidget {
  const ProductRowItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
  });

  final String title;
  final String id;
  final String imageUrl;
  final int price;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 76,
              height: 76,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    // style: Styles.productRowItemName,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    '$price',
                    // style: Styles.productRowItemPrice,
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProductPage(id)));
            },
            child: const Icon(
              Icons.edit,
              semanticLabel: 'Add',
              color: Colors.black87,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              final productDoc = FirebaseServices().productsRef.doc(id);
              productDoc.delete();
            },
            child: const Icon(
              Icons.delete,
              semanticLabel: 'delete',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );

    // if (lastItem) {
    //   return row;
    // }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 100,
            right: 16,
          ),
          child: Container(
            height: 1,
            // color: Styles.productRowDivider,
          ),
        ),
      ],
    );
  }
}
