import '/components/drawer_widget.dart';
import '/components/generatebyai_widget.dart';
import '/components/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'mainpage_widget.dart' show MainpageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainpageModel extends FlutterFlowModel<MainpageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for menu component.
  late MenuModel menuModel;
  // Model for Drawer component.
  late DrawerModel drawerModel;
  // Model for generatebyai component.
  late GeneratebyaiModel generatebyaiModel;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    drawerModel = createModel(context, () => DrawerModel());
    generatebyaiModel = createModel(context, () => GeneratebyaiModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    drawerModel.dispose();
    generatebyaiModel.dispose();
  }
}
