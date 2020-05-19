import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/theme.dart';
import 'package:treasurer/ui/widgets/account_header.dart';
import 'package:treasurer/ui/widgets/header_clipper.dart';
import 'package:treasurer/ui/widgets/operation_tile.dart';

/// The View of an account.
///
/// Displays the list of operations  performed on this account
/// as well as the total amounts of bank and cash.
class AccountView extends StatefulWidget {
  AccountView({Key key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

/// The state of the [AccountView].
class _AccountViewState extends State<AccountView> {
  /// The controller used for the scroll animation.
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Sets up the scroll controller
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// The offset of the current scroll view.
  double get offset =>
      _scrollController.hasClients ? _scrollController.offset : 0.0;

  /// Returns the given value if it is positive, `0.0` otherwise.
  double valueOrZero(double value) {
    return value >= 0 ? value : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>.reactive(
      // Fetches the global view model.
      viewModelBuilder: () => locator<AccountViewModel>(),
      // Keeps view model alive.
      disposeViewModel: false,
      // Loads the data when the model is ready.
      onModelReady: (model) => model.loadData(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: DefaultThemeColors.white.withAlpha(240),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: model.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DefaultThemeColors.white,
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      ClipPath(
                        clipper: HeaderClipper(
                          opening: valueOrZero(80.0 - offset / 2),
                        ),
                        child: Container(
                          height: 400.0 + offset,
                          decoration: BoxDecoration(
                            gradient: CustomTheme.gradient,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: model.operations.length + 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      color: DefaultThemeColors.white,
                                      onPressed: () => model.newOperation(),
                                    ),
                                  ],
                                );
                              } else if (index == 1) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 48.0),
                                  child: Opacity(
                                      opacity: valueOrZero(1 - offset / 100),
                                      child: AccountHeader(model: model)),
                                );
                              }
                              index -= 2;
                              return OperationTile(
                                operation: model.operations[index],
                                onTap: () => model.navigateToOperation(
                                    model.operations[index]),
                              );
                            }),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
