import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/viewmodels/onboarding.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/widgets/buttons.dart';

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

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 32.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? DefaultThemeColors.white : DefaultThemeColors.white54,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  Widget _buildPageIndicatorList() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pageCount; i++) {
      indicators.add(_buildPageIndicator(i == _currentPage));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  Widget _buildAmountForm({String title, TextEditingController controller}) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 250.0,
        ),
        Text(title, style: Theme.of(context).accentTextTheme.bodyText1),
        SizedBox(height: 16.0),
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
              )
            ),
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
          keyboardType: TextInputType.number,
          controller: controller,
          validator: (value) {
            Pattern amountPattern = r'^[1-9][0-9]*([\.,][0-9]+)?$';
            RegExp amountRegex = RegExp(amountPattern);
            if (!amountRegex.hasMatch(value)) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

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
              // systemNavigationBarColor: Colors.transparent,
            ),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.4, 0.7, 0.9],
                        colors: [
                          DefaultThemeColors.blue1,
                          DefaultThemeColors.blue2,
                          DefaultThemeColors.blue3,
                          DefaultThemeColors.blue4,
                        ],
                      ),
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
                              SizedBox(
                                height: 250.0,
                              ),
                              Text(
                                "Bienvenue",
                                style:
                                    Theme.of(context).accentTextTheme.headline4,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Suivez ces quelques étapes pour paramétrer votre livre de compte",
                                style:
                                    Theme.of(context).accentTextTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: _buildAmountForm(
                            title:
                                "Veuillez indiquer le montant initial de votre compte :",
                            controller: _bankAmountController,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: _buildAmountForm(
                            title:
                                "Veuillez indiquer le montant initial de votre caisse :",
                            controller: _cashAmountController,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 250.0,
                              ),
                              Text(
                                "Paramétrage terminé",
                                style:
                                    Theme.of(context).accentTextTheme.headline4,
                              ),
                              SizedBox(
                                height: 20.0,
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
                    child: _buildPageIndicatorList(),
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
