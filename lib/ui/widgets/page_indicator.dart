import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

class PageIndicator extends StatelessWidget {

  final bool isActive;

  const PageIndicator({Key key, this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class PageIndicators extends StatelessWidget {

  final int pageCount;

  final int currentPageIndex;

  const PageIndicators({Key key, this.pageCount, this.currentPageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> indicators = [];
    for (int i = 0; i < pageCount; i++) {
      indicators.add(PageIndicator(
        isActive: i == currentPageIndex
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}
