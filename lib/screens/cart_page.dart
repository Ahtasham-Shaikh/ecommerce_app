import 'package:a_commerce/screens/product_page.dart';
import 'package:a_commerce/services/firebase_services.dart';
import 'package:a_commerce/widgets/custom_action_bar.dart';
import 'package:a_commerce/widgets/custom_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  int total = 399;
  Razorpay razorpay;
  List cartItemId;
  get cartDocs async {
    final docs = await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .get();
    docs.docs.map((e) => cartItemId.add(e.id));
  }

  @override
  void initState() {
    // TODO: implement initState
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    razorpay.clear();
  }

  void handlePaymentSuccess() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Your Order has been Placed")));
  }

  void handlePaymentError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment Failed")));
  }

  void handleExternalWallet() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment failed")));
  }

  void openCheckout() async {
    bool paymentFlag = false;
    var options = {
      "key": "rzp_test_tEAXYHYyDNbbeE",
      "amount": total * 100,
      "name": "Ahtasham Shaikh",
      "description": "Payment for your online order",
      "prefill": {"email": "shaikh.ahtasham05263@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      },
    };
    try {
      razorpay.open(options);
      paymentFlag = true;
      print("try statement ran");
      print(paymentFlag);
      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
    if (paymentFlag) {
      print("if statement first print");
      List cartItemId;
      final docs = await _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("Cart")
          .get();
      docs.docs.map((e) => cartItemId.add(e.id));
      cartItemId.forEach(
        (id) {
          final cartItemRef = _firebaseServices.usersRef
              .doc(_firebaseServices.getUserId())
              .collection("Cart")
              .doc(id);
          cartItemRef.delete();
        },
      );
      print("if statement ran");
    }
  }

  final cartRef = FirebaseServices()
      .usersRef
      .doc(FirebaseServices().getUserId())
      .collection("Cart");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: cartRef.get(),
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
                // Display the data inside a list view
                return ListView(
                    padding: EdgeInsets.only(
                      top: 108.0,
                      bottom: 12.0,
                    ),
                    children: [
                      ...snapshot.data.docs.map((document) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    productId: document.id,
                                  ),
                                ));
                          },
                          child: FutureBuilder(
                            future: _firebaseServices.productsRef
                                .doc(document.id)
                                .get(),
                            builder: (context, productSnap) {
                              if (productSnap.hasError) {
                                return Container(
                                  child: Center(
                                    child: Text("${productSnap.error}"),
                                  ),
                                );
                              }

                              if (productSnap.connectionState ==
                                  ConnectionState.done) {
                                Map _productMap = productSnap.data.data();

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_productMap['name']}",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                "₹${_productMap['price']}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                        onPressed: () {
                                          print(document.id);
                                          cartRef.doc(document.id).delete();
                                          print("hello");
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "One Item removed from cart"),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Price ₹$total",
                            style: Constants.boldHeading,
                          ),
                        ],
                      ),
                      CustomBtn(
                        onPressed: () {
                          openCheckout();
                        },
                        text: "Order Now",
                        outlineBtn: false,
                      ),
                    ]);
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrrow: true,
            title: "Cart",
          )
        ],
      ),
    );
  }
}
