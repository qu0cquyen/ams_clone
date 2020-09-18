import 'package:ams/blocs/blocs.dart';
import 'package:ams/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:slider_button/slider_button.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static double _billAmount = 50.0;
  PageController paymentBottomController = PageController();
  TextEditingController _customTipTextController = new TextEditingController();

  Map<String, dynamic> _cardPref;

  int _numPageView = 2;
  int _currentPage = 0;
  int _currentSelected = 0;
  String _dropDownCurrentValue = 'Choose your promotion';
  bool _isCustomTip = false;
  bool _isDropDownIconChecked = false;
  List<Map<String, dynamic>> _lstBankCard = [
    {"cardNumber": "**** **** **** 1234", "balance": 1250, "imgLink": "image"},
    {"cardNumber": "**** **** **** 5678", "balance": 2250, "imgLink": "image"},
    {"cardNumber": "**** **** **** 9101", "balance": 3250, "imgLink": "image"},
  ];

  // Future<void> _loadingCardPref() async {
  //   final _prefs = await SharedPreferences.getInstance();
  //   if (_prefs != null) {
  //     setState(() {
  //       _cardPref = jsonDecode(_prefs.getString("preferred_card"));
  //     });
  //   }
  // }

  @override
  void dispose() {
    paymentBottomController.dispose();
    _customTipTextController.dispose();
    super.dispose();
  }

  Widget _buildPromoPopUp() {
    return Container(
      height: 280.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 6.0, right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select your discount',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.help_outline,
                  size: 30.0,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40.0,
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your discount vouncher',
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 40.0,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {},
                          child: Text('Apply'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 140.0,
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Referral Reward"),
                              subtitle: Text("50% off"),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTipSelection() {
    int _minPercentTip = 5;
    List<Widget> lstTipSelection = [];

    for (int index = 0; index < 4; index++) {
      double _amountPercentTip =
          _billAmount * (_minPercentTip * (index + 3) / 100);
      lstTipSelection.add(
        Expanded(
          child: Container(
            height: 74.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: _currentSelected != index ? Colors.grey : Colors.blue,
              ),
            ),
            child: ListTile(
              title: index < 3
                  ? Text(
                      (_minPercentTip * (index + 3)).toString() + '%',
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Other',
                      textAlign: TextAlign.center,
                    ),
              subtitle: index < 3
                  ? Text(
                      '\$' + _amountPercentTip.toString(),
                      textAlign: TextAlign.center,
                    )
                  : null,
              onTap: () {
                setState(() {
                  if (index < 3) {
                    _currentSelected = index;
                    _isCustomTip = false;
                    context.bloc<PaymentBloc>().add(
                          TipSelectionChange(tipSelection: _amountPercentTip),
                        );
                  } else {
                    _currentSelected = index;
                    setState(() {
                      _isCustomTip = true;
                    });
                  }
                });
              },
            ),
          ),
        ),
      );
    }
    return lstTipSelection;
  }

  Widget buildPaymentPopUp(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Confirm your payment',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 2.0,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Funding Source'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: _cardPref != null
                      ? ListTile(
                          leading: Icon(Icons.image),
                          trailing: FlatButton(
                            child: Text('Change'),
                            onPressed: () {
                              paymentBottomController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            },
                          ),
                          title: Text(_cardPref["cardNumber"]),
                          subtitle: Text('\$${_cardPref["balance"]}'),
                        )
                      : ListTile(
                          leading: Icon(Icons.info, color: Colors.blue),
                          trailing: FlatButton(
                            child: Text('Change'),
                            onPressed: () {
                              context
                                  .bloc<PaymentBloc>()
                                  .add(ChangeCardPressed());
                            },
                          ),
                          title: Text(
                            "You haven't chosen a card to make a payment",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                ),
                Divider(
                  height: 12.0,
                  thickness: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$50',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tip: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$10',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount: ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '-\$10',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$50',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                // Slider
                Center(
                  child: SliderButton(
                    height: 50.0,
                    width: 250.0,
                    buttonSize: 50.0,
                    vibrationFlag: false,
                    dismissible: false,
                    //shimmer: false,
                    buttonColor: Colors.black,
                    action: () {
                      print('Paying');
                    },
                    label: Text(
                      'Slide to Pay',
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'You will receive ${_billAmount.toInt()} points reward',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateLoading) {
          showDialog(
              context: context,
              builder: (context) => Center(child: CircularProgressIndicator()));
        }

        if (state is PaymentStateLoaded) {
          Navigator.of(context).pop();
        }

        if (state is PaymentStatePrefLoaded) {
          setState(() {
            _cardPref = state.cardPref;
            print("$_cardPref ==========================================");
          });
        }

        if (state is PaymentStateBottom1SheetShowed) {
          buildPaymentPopUp(this.context);
        }

        if (state is PaymentStateBottom2SheetShowed) {
          paymentBottomController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 32.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IdentifierContainer(
                              title: "Recipient", owner: "The Coffee House"),
                          SizedBox(height: 30.0),
                          Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Bill Amount',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "\$50",
                                  style: TextStyle(
                                    fontSize: 60.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -5.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text('Add tip'),
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70.0,
                            child: Row(
                              children: _buildTipSelection(),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          _isCustomTip
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2),
                                  ),
                                  child: TextFormField(
                                    controller: _customTipTextController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                      prefix: Text('\$'),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) {
                                      context.bloc<PaymentBloc>().add(
                                          TipInputChange(
                                              customTip: int.parse(
                                                  _customTipTextController.text
                                                      .toString())));
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Promo'),
                                InkWell(
                                  child: Text('Add promo'),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return _buildPromoPopUp();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _dropDownCurrentValue,
                                isExpanded: true,
                                icon: _isDropDownIconChecked
                                    ? Icon(Icons.check,
                                        color: Colors.green[700])
                                    : Icon(Icons.arrow_drop_down),
                                onChanged: (val) {
                                  if (val != '') {
                                    setState(() {
                                      _isDropDownIconChecked = true;
                                      _dropDownCurrentValue = val;
                                      context.bloc<PaymentBloc>().add(
                                          PromoSelectionChange(promo: val));
                                    });
                                  }
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 'Choose your promotion',
                                    child: Text('Choose your promotion'),
                                  ),
                                  DropdownMenuItem(
                                    value: "Use \$5 discount",
                                    child: Text('Use \$5 discount'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: 45.0,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.black,
                          child: Text(
                            'Confirm Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onPressed: () {
                            context.bloc<PaymentBloc>().add(ConfirmPressed());
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                //_loadingCardPref(); // Temporary placed
                                return PageView(
                                  controller: paymentBottomController,
                                  children: [
                                    buildPaymentPopUp(this.context),
                                    BottomPopUpCardInfo(
                                        header: "Select funding source",
                                        clickAbleSubHeader: "Add",
                                        hasTrailing: false,
                                        lstItem: _lstBankCard,
                                        onClickHeader: () => print("Clicked"),
                                        onSelected: (bool isSelected) {
                                          context
                                              .bloc<PaymentBloc>()
                                              .add(CardSelectionChange());
                                          print("Card Selection activated");
                                          paymentBottomController.previousPage(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              curve: Curves.easeInOut);
                                        }),
                                  ],
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentPage = page;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
