import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class BottomPaymentPopUp extends StatefulWidget {
  final String header;
  final String clickAbleHeader;
  final Map<String, dynamic> cardPref;
  final Map<String, dynamic> detailsServiceFees;
  final VoidCallback onClickHeader;
  final VoidCallback onClickChangeCard;
  final VoidCallback onPaymentMade;

  const BottomPaymentPopUp({
    @required this.header,
    @required this.clickAbleHeader,
    @required this.cardPref,
    @required this.detailsServiceFees,
    @required this.onClickHeader,
    this.onClickChangeCard,
    this.onPaymentMade,
  });

  @override
  _BottomPaymentPopUpState createState() => _BottomPaymentPopUpState();
}

class _BottomPaymentPopUpState extends State<BottomPaymentPopUp> {
  double _total;

  List<Widget> _buildServiceFeeDisplay() {
    _total = 0;
    List<Widget> lstWidget = [];

    widget.detailsServiceFees.forEach((key, value) {
      if (key.compareTo("Discount") == 0)
        _total += value * -1;
      else
        _total += value;

      lstWidget.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key + ": ",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            key.compareTo("Discount") == 0
                ? "-\$" + value.toString()
                : "\$" + value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));
    });
    return lstWidget;
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.header,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  child: Text(
                    widget.clickAbleHeader,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                  onPressed: widget.onClickHeader,
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
                  child: ListTile(
                    leading: Icon(Icons.image),
                    trailing: FlatButton(
                      child: Text('Change'),
                      onPressed: widget.onClickChangeCard,
                    ),
                    title: widget.cardPref != null
                        ? Text(widget.cardPref["cardNumber"])
                        : Text(
                            "You haven't chosen a card to make a payment",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                    subtitle: widget.cardPref != null
                        ? Text('\$${widget.cardPref["balance"]}')
                        : null,
                  ),
                ),
                Divider(
                  height: 12.0,
                  thickness: 2.0,
                ),

                for (var widget in _buildServiceFeeDisplay()) widget,

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
                      '\$$_total',
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
                    action: widget.onPaymentMade,
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
                    'You will receive $_total points reward',
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
}
