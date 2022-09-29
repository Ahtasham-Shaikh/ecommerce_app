import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../constants.dart';
import '../widgets/custom_btn.dart';
import '../services/firebase_services.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({Key key}) : super(key: key);

  String title;

  int price;

  String description;

  String imageUrl;

  void addProduct() async {
    final newProductDoc = FirebaseServices().productsRef.doc();
    final json = {
      'desc': description,
      'images': [imageUrl],
      "name": title,
      "price": price,
      "size": ["S", "M", "L"]
    };
    await newProductDoc.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInput(
                hintText: "Title",
                onChanged: (value) {
                  title = value;
                },
              ),
              CustomInput(
                hintText: "Price",
                textInputType: TextInputType.number,
                onChanged: (value) {
                  price = int.parse(value);
                },
              ),
              CustomInput(
                hintText: "Description",
                onChanged: (value) {
                  description = value;
                },
              ),
              CustomInput(
                hintText: "Image Url",
                onChanged: (value) {
                  imageUrl = value;
                },
                textInputType: TextInputType.url,
              ),
              CustomBtn(
                outlineBtn: true,
                text: "Add Product",
                onPressed: () {
                  addProduct();
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
