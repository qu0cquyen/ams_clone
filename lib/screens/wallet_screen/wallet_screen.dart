import 'package:ams/screens/screens.dart';
import 'package:ams/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _lstBankCard = [
    {"cardNumber": "**** **** **** 1234", "balance": 1250, "imgLink": "image"},
    {"cardNumber": "**** **** **** 5678", "balance": 2250, "imgLink": "image"},
    {"cardNumber": "**** **** **** 9101", "balance": 3250, "imgLink": "image"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        'Wallet',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {},
                      icon: Icon(Icons.help_outline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Balance',
                style: TextStyle(fontSize: 17.0),
              ),
              Text(
                '\$50',
                style: TextStyle(fontSize: 30.0, letterSpacing: -2.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          child: Icon(Icons.image, size: 70.0),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TopUpScreen(),
                            ),
                          ),
                        ),
                        Text(
                          'Top Up',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          child: Icon(Icons.image, size: 70.0),
                          onTap: () {},
                        ),
                        Text(
                          'Pay',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          child: Icon(Icons.image, size: 70.0),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return BottomPopUpCardInfo(
                                  header: "Link Bank",
                                  clickAbleSubHeader: "Add",
                                  lstItem: _lstBankCard,
                                  onClickHeader: () {},
                                );
                              },
                            );
                          },
                        ),
                        Text(
                          'Link Bank',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text("Title"),
                  subtitle: Text("A long subTitle"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Text('Reserved for List'),
              FlatButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "View All Transactions",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
