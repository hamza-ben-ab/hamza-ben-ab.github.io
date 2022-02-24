import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * .93,
      width: w * .75,
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          Container(
            width: w * .35,
            height: h * .93,
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey[300]))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: h * .1,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Credit Card",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                            fontFamily: "SPProtext"),
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Text(
                        "You can find all information about your credit card here.",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.0,
                            fontFamily: "SPProtext"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: h * .93,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: h * .1,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[50],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My spending",
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18.0,
                              fontFamily: "SPProtext"),
                        ),
                        SizedBox(
                          height: h * .02,
                        ),
                        Text(
                          "You can find all information about your credit card here.",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.0,
                              fontFamily: "SPProtext"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
