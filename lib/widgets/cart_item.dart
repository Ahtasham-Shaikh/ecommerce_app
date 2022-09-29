import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/services/firebase_services.dart';

class CartItem extends StatelessWidget {
  CartItem(this.productSnap);
  final productSnap;
  @override
  Widget build(BuildContext context) {
    Map _productMap = productSnap.data.data();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "${_productMap['images'][0]}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_productMap['name']}",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  child: Text(
                    "₹${_productMap['price']}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  "Size - ${document.data()['size']}",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.only(left: 80),
            onPressed: () {
              print(FirebaseServices().getUserId());
              final userDoc = FirebaseServices()
                  .usersRef
                  .doc(FirebaseServices().getUserId());
              userDoc.collection("Cart").doc(_productMap["id"]).delete();
            },
            child: const Icon(
              Icons.delete,
              semanticLabel: 'delete',
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
