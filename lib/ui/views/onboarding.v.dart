import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/viewmodels/onboarding.vm.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
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
        color: isActive ? Colors.white : Colors.white54,
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
                      color: Colors.green,
                      child: Center(
                        child: Text("Welcome"),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      child: Center(
                        child: Text("Coucou 2"),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      child: Center(
                        child: Text("Coucou 3"),
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
          floatingActionButton: _currentPage != _pageCount - 1
          ? null
          : FloatingActionButton(
            onPressed: () => model.exit(),
            child: Icon(Icons.arrow_forward),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }
}
