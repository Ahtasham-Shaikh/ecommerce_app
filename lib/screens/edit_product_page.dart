import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';

import '../widgets/custom_input.dart';
import '../widgets/custom_btn.dart';

class EditProductPage extends StatefulWidget {
  String title;
  int price;
  String description;
  String imageUrl;
  String id;
  DocumentReference product;

  EditProductPage(this.id) {
    print("Constructor ran");
    product = FirebaseServices().productsRef.doc(id);
    product.get().then((value) {
      this.title = value.get('name');
      this.price = value.get('price');
      this.imageUrl = value.get('images')[0];
      this.description = value.get('desc');
    });
    print(title);
  }

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  void updateProduct() async {
    final updatedTitle = widget.title;
    final updatedPrice = widget.price;
    final updatedImageUrl = widget.imageUrl;
    final updatedDescription = widget.description;
    final json = {
      'desc': updatedDescription,
      'images': [updatedImageUrl],
      "name": updatedTitle,
      "price": updatedPrice,
      "size": ["S", "M", "L"]
    };
    await widget.product.set(json);
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget.title);
    print("build ran");
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInput(
                initialValue: "Hey there",
                onChanged: (value) {
                  widget.title = value;
                },
              ),
              CustomInput(
                initialValue: widget.price.toString(),
                textInputType: TextInputType.number,
                onChanged: (value) {
                  widget.price = int.parse(value);
                },
              ),
              CustomInput(
                initialValue: widget.description,
                onChanged: (value) {
                  widget.description = value;
                },
              ),
              CustomInput(
                initialValue: widget.imageUrl,
                onChanged: (value) {
                  widget.imageUrl = value;
                },
                textInputType: TextInputType.url,
              ),
              CustomBtn(
                outlineBtn: true,
                text: "Update Product",
                onPressed: () {
                  updateProduct();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
