import 'package:ams/blocs/blocs.dart';
import 'package:ams/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static double _billAmount = 50.0;
  PageController paymentBottomController = PageController(keepPage: false);
  TextEditingController _customTipTextController = new TextEditingController();

  Map<String, dynamic> _cardPref;

  int _currentSelected = 0;
  String _dropDownCurrentValue = 'Choose your promotion';
  bool _isCustomTip = false;
  bool _isDropDownIconChecked = false;
  List<Map<String, dynamic>> _lstBankCard = [
    {"cardNumber": "**** **** **** 1234", "balance": 1250, "imgLink": "image"},
    {"cardNumber": "**** **** **** 5678", "balance": 2250, "imgLink": "image"},
    {"cardNumber": "**** **** **** 9101", "balance": 3250, "imgLink": "image"},
  ];

  Map<String, dynamic> _serviceFee = {
    "Subtotal": 50,
    "Tip": 10,
    "Discount": 10
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    paymentBottomController.dispose();
    _customTipTextController.dispose();
    super.dispose();
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
                          PaymentPageTipSelectionChanged(
                              tipSelection: _amountPercentTip),
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

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IdentifierContainer(title: "Recipient", owner: "The Coffee House"),
        SizedBox(height: 30.0),
        Center(
          child: Column(
            children: <Widget>[
              Text(
                'Bill Amount',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    prefix: Text('\$'),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    context.bloc<PaymentBloc>().add(PaymentPageTipInputChanged(
                        customTip: int.parse(
                            _customTipTextController.text.toString())));
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
                      return BottomPromoPopUp();
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _dropDownCurrentValue,
              isExpanded: true,
              icon: _isDropDownIconChecked
                  ? Icon(Icons.check, color: Colors.green[700])
                  : Icon(Icons.arrow_drop_down),
              onChanged: (val) {
                if (val != '') {
                  setState(() {
                    _isDropDownIconChecked = true;
                    _dropDownCurrentValue = val;
                    context
                        .bloc<PaymentBloc>()
                        .add(PaymentPagePromoSelectionChanged(promo: val));
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
    );
  }

  Widget _buildConfirmButton(BuildContext context, PaymentState state) {
    return Container(
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
          context.bloc<PaymentBloc>().add(PaymentPageConfirmPressed());
        },
      ),
    );
  }

  // Widget _buildPageView() {
  //   return PageView(
  //     controller: paymentBottomController,
  //     children: [
  //       buildPaymentPopUp(context),
  //       BottomPopUpCardInfo(
  //           header: "Select funding source",
  //           clickAbleSubHeader: "Add",
  //           hasTrailing: false,
  //           lstItem: _lstBankCard,
  //           onClickHeader: () => print("Clicked"),
  //           onSelected: (bool isSelected) {
  //             //context.bloc<PaymentBloc>().add(CardSelectionChange());
  //             print("Card Selection activated");
  //             paymentBottomController.previousPage(
  //                 duration: const Duration(
  //                   milliseconds: 400,
  //                 ),
  //                 curve: Curves.easeInOut);
  //           }),
  //     ],
  //     onPageChanged: (int page) {
  //       setState(() {
  //         _currentPage = page;
  //         // paymentBottomController.addListener(() { })
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(listener: (context, state) {
      if (state is PaymentStateLoading) {
        showDialog(
            context: context,
            builder: (context) => Center(child: CircularProgressIndicator()));
      }

      if (state is PaymentStateLoaded) {
        Navigator.of(context).pop();
      }

      if (state is PaymentStatePrefLoaded) {
        _cardPref = state.cardPref;
      }

      if (state is PaymentStatePaySuccess) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Icon(Icons.check_circle, color: Colors.green, size: 100.0),
            content: Text('Payment has been successfully made'),
          ),
        );
      }

      if (state is PaymentStatePayFailure) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Icon(Icons.close, color: Colors.red, size: 100.0),
            content: Text('Oops! Something went wrong. Please try again.'),
          ),
        );
      }

      if (state is PaymentStateBottom1SheetShowed) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return BottomPaymentPopUp(
                  header: 'Confirm your payment',
                  clickAbleHeader: 'Cancel',
                  cardPref: _cardPref,
                  detailsServiceFees: _serviceFee,
                  onClickHeader: () => Navigator.pop(context),
                  onClickChangeCard: () {
                    context
                        .bloc<PaymentBloc>()
                        .add(PaymentPageChangeCardPressed());
                    Navigator.pop(context);
                  },
                  onPaymentMade: () {
                    _cardPref == null
                        ? showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Icon(Icons.close,
                                  color: Colors.red, size: 100.0),
                              content: Text(
                                  'Oops! Something went wrong. Please try again.'),
                            ),
                          )
                        : context
                            .bloc<PaymentBloc>()
                            .add(PaymentPagePayButtonSlided());
                  },
                );
              },
            );
          },
        );
      }

      if (state is PaymentStateBottom2SheetShowed) {
        print("Getting Here ???");
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomPopUpCardInfo(
                header: "Select funding source",
                clickAbleSubHeader: "Add",
                cardPref: _cardPref,
                lstItem: _lstBankCard,
                onClickHeader: () => print("Clicked"),
                onCardPrefChanged: (cardPref) {
                  // This event will be fired once user made a card selection
                  context
                      .bloc<PaymentBloc>()
                      .add(PaymentPageCardSelectionChanged(cardPref: cardPref));
                  Navigator.pop(context);
                },
              );
            });
      }
    }, builder: (context, state) {
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
                    _buildBody(),
                    Spacer(),
                    _buildConfirmButton(context, state),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
