import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/viewmodels/onboarding.vm.dart';

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
  final int _pageCount = 3;

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
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).accentColor : Theme.of(context).accentColor.withAlpha(150),
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

  Widget _buildAmountForm(String title, TextEditingController controller) {
    return Column(
      children: <Widget>[
        SizedBox(height: 100.0,),
        Text(title, style: Theme.of(context).textTheme.bodyText1),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Montant',
            suffixIcon: Icon(Icons.euro_symbol),
          ),
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
          body: SafeArea(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Stack(
                children: <Widget>[
                  PageView(
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
                          children: <Widget>[
                            SizedBox(
                              height: 50.0,
                            ),
                            Text(
                              "Bienvenue",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Text(
                              "Suivez ces quelques étapes pour paramétrer votre livre de compte",
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(40.0),
                        child: _buildAmountForm(
                          "Veuillez indiquer le montant initial de votre compte :",
                          _bankAmountController
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(40.0),
                        child: _buildAmountForm(
                          "Veuillez indiquer le montant initial de votre caisse :",
                          _cashAmountController
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 24.0,
                    left: 0.0,
                    right: 0.0,
                    child: _buildPageIndicatorList(),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: _currentPage != _pageCount - 1
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      double bankAmount = double.parse(_bankAmountController.text.replaceAll(',', '.'));
                      double cashAmount = double.parse(_cashAmountController.text.replaceAll(',', '.'));
                      model.exit(bankAmount, cashAmount);
                    }
                  },
                  child: Icon(Icons.check),
                  backgroundColor: Theme.of(context).accentColor,
                ),
        );
      },
    );
  }
}
