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

/// View of an account
class AccountView extends StatefulWidget {
  AccountView({Key key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get offset =>
      _scrollController.hasClients ? _scrollController.offset : 0.0;

  double valueOrZero(double value) {
    return value >= 0 ? value : 0.0;
  }

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<AccountViewModel>.reactive(
          viewModelBuilder: () => locator<AccountViewModel>(),
          disposeViewModel: false,
          onModelReady: (model) => model.loadData(),
          builder: (context, model, child) {
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
                      : Stack(children: <Widget>[
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
                                          opacity:
                                              valueOrZero(1 - offset / 100),
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
                        ]),
                ));
          });
}
