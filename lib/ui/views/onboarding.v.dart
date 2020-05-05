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
  /// Number of pages in the onboarding
  final int _pageCount = 4;

  /// Current page index
  int _currentPage = 0;

  /// Controller of the page view
  PageController _pageController = PageController(initialPage: 0);

  /// Controller of the bank amount input
  TextEditingController _bankAmountController = TextEditingController();

  bool _bankFieldValid = true;

  bool _cashFieldValid = true;

  /// Controller of the cash amount input
  TextEditingController _cashAmountController = TextEditingController();

  RegExp _amountRegex = RegExp(r'^([1-9][0-9]*|0)([\.,][0-9]+)?$');

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 16.0,),
                            Text(
                              "Veuillez indiquer le montant initial de votre compte :",
                              style:
                                  Theme.of(context).accentTextTheme.subtitle1,
                            ),
                            SizedBox(height: 32.0),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "0.0",
                                hintStyle: TextStyle(
                                  color: _bankFieldValid ? DefaultThemeColors.black.withAlpha(125) : DefaultThemeColors.error,
                                ),
                                fillColor: _bankFieldValid ? DefaultThemeColors.white : DefaultThemeColors.error2,
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
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(height: 16.0,),
                            Text(
                              "Veuillez indiquer le montant initial de votre caisse :",
                              style:
                                  Theme.of(context).accentTextTheme.subtitle1,
                            ),
                            SizedBox(height: 32.0),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "0.0",
                                hintStyle: TextStyle(
                                  color: _cashFieldValid ? DefaultThemeColors.black.withAlpha(125) : DefaultThemeColors.error,
                                ),
                                fillColor: _cashFieldValid ? DefaultThemeColors.white : DefaultThemeColors.error2,
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
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "Votre livre de compte est prêt",
                              style:
                                  Theme.of(context).accentTextTheme.headline3,
                            ),
                            Spacer(),
                            CustomRaisedButton(
                              onPressed: () {
                                if (_cashAmountController.text.isEmpty || !_amountRegex.hasMatch(_cashAmountController.text)) {
                                  setState(() {
                                    _cashFieldValid = false;
                                    _currentPage = 2;
                                    _pageController.animateToPage(
                                      _currentPage,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.decelerate);
                                  });
                                } else {
                                  setState(() {
                                    _cashFieldValid = true;
                                  });
                                }

                                if (_bankAmountController.text.isEmpty || !_amountRegex.hasMatch(_bankAmountController.text)) {
                                  setState(() {
                                    _bankFieldValid = false;
                                    _currentPage = 1;
                                    _pageController.animateToPage(
                                      _currentPage,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.decelerate);
                                  });
                                } else {
                                  setState(() {
                                    _bankFieldValid = true;
                                  });
                                }

                                if (_bankFieldValid && _cashFieldValid) {
                                  double bankAmount = double.parse(
                                    _bankAmountController.text
                                        .replaceAll(',', '.'));
                                  double cashAmount = double.parse(
                                      _cashAmountController.text
                                          .replaceAll(',', '.'));
                                  model.exit(bankAmount, cashAmount);
                                }
                              },
                              title: "Commencer",
                              backgroundColor: DefaultThemeColors.white,
                              textColor: DefaultThemeColors.blue,
                            ),
                            SizedBox(height: 24.0,),
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
        );
      },
    );
  }
}
