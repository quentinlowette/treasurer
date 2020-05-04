import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/viewmodels/onboarding.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/theme.dart';
import 'package:treasurer/ui/widgets/buttons.dart';
import 'package:treasurer/ui/widgets/page_indicator.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  /// Global key of the form
  ///
  /// Needed for the Form widget
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Auto validate status
  bool _autoValidate = false;

  /// Number of pages in the onboarding
  final int _pageCount = 4;

  /// Current page index
  int _currentPage = 0;

  /// Controller of the page view
  PageController _pageController = PageController(initialPage: 0);

  /// Controller of the bank amount input
  TextEditingController _bankAmountController = TextEditingController();

  /// Controller of the cash amount input
  TextEditingController _cashAmountController = TextEditingController();

  RegExp _amountRegex = RegExp(r'^[1-9][0-9]*([\.,][0-9]+)?$');

  @override
  void dispose() {
    _pageController.dispose();
    _bankAmountController.dispose();
    _cashAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViemModel>.reactive(
      viewModelBuilder: () => OnboardingViemModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: CustomTheme.gradient,
                    ),
                  ),
                  SafeArea(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int pageIndex) {
                        setState(() {
                          _currentPage = pageIndex;
                        });
                      },
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 48.0,
                                ),
                                child: Image.asset(
                                    "assets/images/welcoming.png",
                                    width: 200.0,
                                    height: 200.0),
                              ),
                              Text(
                                "Bienvenue",
                                style:
                                    Theme.of(context).accentTextTheme.headline3,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Suivez ces quelques étapes pour paramétrer votre livre de compte",
                                style:
                                    Theme.of(context).accentTextTheme.subtitle1,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 48.0,
                                ),
                                child: Image.asset("assets/images/card.png",
                                    width: 200.0, height: 200.0),
                              ),
                              Text(
                                "Veuillez indiquer le montant initial de votre compte :",
                                style:
                                    Theme.of(context).accentTextTheme.subtitle1,
                              ),
                              SizedBox(height: 32.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "0.0",
                                  fillColor: DefaultThemeColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                      width: 0.0,
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.number,
                                controller: _bankAmountController,
                                validator: (value) {
                                  if (!_amountRegex.hasMatch(value)) {
                                    return 'Veuillez entrer un montant correct';
                                  }
                                  return null;
                                },
                              ),
                              // SizedBox(
                              //   height: 16.0,
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 48.0,
                                ),
                                child: Image.asset("assets/images/wallet.png",
                                    width: 200.0, height: 200.0),
                              ),
                              Text(
                                "Veuillez indiquer le montant initial de votre caisse :",
                                style:
                                    Theme.of(context).accentTextTheme.subtitle1,
                              ),
                              SizedBox(height: 32.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "0.0",
                                  fillColor: DefaultThemeColors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                      width: 0.0,
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.number,
                                controller: _cashAmountController,
                                validator: (value) {
                                  if (!_amountRegex.hasMatch(value)) {
                                    return 'Veuillez entrer un montant correct';
                                  }
                                  return null;
                                },
                              ),
                              // SizedBox(
                              //   height: 16.0,
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 48.0,
                                ),
                                child: Image.asset(
                                    "assets/images/completed.png",
                                    width: 200.0,
                                    height: 200.0),
                              ),
                              // Text(
                              //   "Réglages terminés",
                              //   style:
                              //       Theme.of(context).accentTextTheme.headline3,
                              // ),
                              SizedBox(
                                height: 120.0,
                              ),
                              CustomRaisedButton(
                                onPressed: () {
                                  double bankAmount = double.parse(
                                      _bankAmountController.text
                                          .replaceAll(',', '.'));
                                  double cashAmount = double.parse(
                                      _cashAmountController.text
                                          .replaceAll(',', '.'));
                                  model.exit(bankAmount, cashAmount);
                                },
                                title: "Commencer",
                                backgroundColor: DefaultThemeColors.white,
                                textColor: DefaultThemeColors.black,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24.0,
                    left: 0.0,
                    right: 0.0,
                    child: PageIndicators(
                      pageCount: _pageCount,
                      currentPageIndex: _currentPage,
                    ),
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
