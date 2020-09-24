import 'package:ams/blocs/blocs.dart';
import 'package:ams/config/us_fomart_phone.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ams/config/string.dart';
import 'package:ams/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int numPage = 12;
  int _currentPage = 0;
  int _maxAttempt = 2;
  final PageController _pageController = PageController(initialPage: 0);
  TextEditingController _phoneNumberController = TextEditingController();

  String userPhoneNumber = '';

  @override
  void dispose() {
    _pageController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Widget _buildNextButton() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      child: IconButton(
        onPressed: () => setState(() {
          _currentPage += 1;
          _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        }),
        icon: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: IconButton(
        onPressed: () => setState(() {
          _currentPage -= 1;
          _pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        }),
        icon: Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _buildContentPage4(OnBoardingState state) {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(), // Image put here
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(OnBoardingString.title_page4,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0))),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 350.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Row(children: <Widget>[
                    Flexible(
                      flex: 0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        width: 50.0,
                        child: Text(OnBoardingString.prefix_phone_number),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter
                                .digitsOnly, // Only numbers are allowed
                            LengthLimitingTextInputFormatter(10),
                            USNumberTextInputFormatter() // Limits input characters
                          ],
                          decoration: InputDecoration(
                              hintText: OnBoardingString.hint_phone_number,
                              border: InputBorder.none), // Clear underline
                          autofocus: true,
                          autovalidate: true,
                          keyboardType: TextInputType.phone,
                          validator: (_) => !state.isPhoneNumberValid &&
                                  _phoneNumberController.text.isNotEmpty
                              ? 'Invalide Phone Number'
                              : null,
                          onChanged: (val) {
                            print(val);
                            context
                                .bloc<OnBoardingBloc>()
                                .add(PhoneNumberChanged(phoneNumber: val));
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 200.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: state.isPhoneNumberValid &&
                            _phoneNumberController.text.isNotEmpty
                        ? () {
                            userPhoneNumber =
                                OnBoardingString.prefix_phone_number +
                                    " " +
                                    _phoneNumberController.text;
                            context.bloc<OnBoardingBloc>().add(
                                ContinueButtonPressed(
                                    phoneNumber: userPhoneNumber));
                          }
                        : null,
                    color: Colors.black,
                    child: Text('Continue',
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: TextSpan(
                  text: OnBoardingString.policy1,
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: OnBoardingString.private_policy,
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print('Privacy Policy')),
                    TextSpan(
                      text: OnBoardingString.policy2,
                    ),
                    TextSpan(
                        text: OnBoardingString.terms,
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print('Term')),
                  ]),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage5(state) {
    final String minutesStr =
        ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');

    final String secondsStr =
        (state.duration % 60).floor().toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Container(
                  child: Text(
                    "Enter the 6-digit code sent to you at $userPhoneNumber",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  onCompleted: (v) {},
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Didn\'t receive the code?'),
                SizedBox(height: 5.0),
                // Try to replace this the below widget to Rich Text
                // We want the time will be replaced by a button when the timer is up
                // Notice: We only allow user to send OTP request twice / day.

                Row(
                  children: <Widget>[
                    Text(
                      'REQUEST NEW CODE IN ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    state.isTimerFinished
                        ? Container(
                            width: 140.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.black,
                              child: Text(
                                'Request code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _maxAttempt > 0
                                  ? () {
                                      setState(() {
                                        _maxAttempt -= 1;
                                      });
                                      context
                                          .bloc<OnBoardingBloc>()
                                          .add(TimerStarted());
                                    }
                                  : null,
                            ),
                          )
                        : Text(
                            '$minutesStr : $secondsStr',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingBloc, OnBoardingState>(
      listener: (context, state) {
        if (state.isSuccess) {
          // Move to the Page 5
          _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          context.bloc<OnBoardingBloc>().add(TimerStarted());
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: _currentPage < 2
                        ? FlatButton(
                            onPressed: () => print('Skip'),
                            child: Text(OnBoardingString.btn_skip,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          )
                        : SizedBox.shrink(),
                  ),
                  Flexible(
                    child: Container(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          buildContentPage(
                              imgLink: "reservedImage",
                              title: OnBoardingString.title_page1,
                              content: OnBoardingString.content_page1),
                          buildContentPage(
                              imgLink: "reservedImage",
                              title: OnBoardingString.title_page2,
                              content: OnBoardingString.content_page2),
                          buildContentPage(
                              imgLink: "reservedImage",
                              title: OnBoardingString.title_page3,
                              content: OnBoardingString.content_page3),

                          // Page 4
                          _buildContentPage4(state),

                          // Page 5
                          _buildContentPage5(state),
                        ],
                      ),
                    ),
                  ),
                  // Build Bottom Page
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _currentPage == 2
                        ? Container(
                            margin: const EdgeInsets.only(
                                top: 20.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 0.0),
                            height: 50.0,
                            width: 400.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              color: Colors.black,
                              onPressed: () => _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut),
                              child: Text(OnBoardingString.btn_checkIn,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.white)),
                            ),
                          )
                        : _currentPage < 2
                            ? Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(color: Colors.grey)),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _currentPage > 0
                                          ? _buildBackButton()
                                          : SizedBox(width: 40.0),
                                      Row(
                                        children: buildPageIndicator(
                                            currentPage: _currentPage),
                                      ),
                                      _currentPage < 2
                                          ? _buildNextButton()
                                          : SizedBox(width: 40.0),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
