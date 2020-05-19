import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

/// A indicator for one page of the onboarding view.
class PageIndicator extends StatelessWidget {
  /// The activity status.
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

/// An indicator of the current page inside the onboarding view.
///
/// It is a list of [PageIndicator] with one of them being active.
class PageIndicators extends StatelessWidget {
  /// The index of the current active page.
  final int currentPageIndex;

  /// The number of [PageIndicator].
  final int pageCount;

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
