import 'package:pro_planner/index.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'accountsettings_model.dart';
import 'package:pro_planner/pages/changepasswor/changepasswor_widget.dart';
export 'accountsettings_model.dart';



class AccountsettingsWidget extends StatefulWidget {
  /// create a profile information, in theprofile information page there will be
  /// user settings like email change password option , change profile photo and
  /// other user related settings
  const AccountsettingsWidget({super.key});

  @override
  State<AccountsettingsWidget> createState() => _AccountsettingsWidgetState();
}

class _AccountsettingsWidgetState extends State<AccountsettingsWidget> {
  late AccountsettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountsettingsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // Future<void> _signOut() async {
  //   try {
  //     await firebase_auth.FirebaseAuth.instance.signOut();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Successfully signed out')),
  //     );
  //     // Navigate to the login page
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => LoginWidget()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to sign out: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 8.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Profile Settings',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.0,
                          height: 120.0,
                          child: Stack(
                            children: [
                              Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(60.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: Image.network(
                                    'https://media.licdn.com/dms/image/v2/D4D03AQEGrXqgGuaVUA/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1713196199415?e=1738800000&v=beta&t=degWwHd1_nZPngFKjXGuyq3Z9HaE1cRgjKokNxOl_hs',
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.8, 0.8),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Najeeb Abu Kheit ',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Inter Tight',
                                letterSpacing: 0.0,
                              ),
                        ),
                        Text(
                          '@najeebakh',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 24.0, 24.0, 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Account Settings',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 24.0,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email Address',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            Text(
                                              'najeeb@example.com',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 24.0,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Change Password',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) =>
                                              ChangepassworWidget(),
                                            ),
                                          );
                                          },
                                          text: 'Change Password',
                                          options: FFButtonOptions(
                                          width: 150.0,
                                          height: 40.0,
                                          color: FlutterFlowTheme.of(context).primary,
                                          textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                            ),
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.notifications,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 24.0,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Notification Settings',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                Text(
                                                  'Manage your notifications',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(width: 12.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: SwitchListTile.adaptive(
                                            value: _model
                                                .switchListTileValue1 ??= true,
                                            onChanged: (newValue) async {
                                              safeSetState(() =>
                                                  _model.switchListTileValue1 =
                                                      newValue!);
                                            },
                                            title: Text(
                                              'Do not disturb',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily:
                                                            'Inter Tight',
                                                        fontSize: 19.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            subtitle: Text(
                                              'Mute all notifications',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            tileColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            activeTrackColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            dense: false,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: SwitchListTile.adaptive(
                                            value: _model
                                                .switchListTileValue2 ??= true,
                                            onChanged: (newValue) async {
                                              safeSetState(() =>
                                                  _model.switchListTileValue2 =
                                                      newValue!);
                                            },
                                            title: Text(
                                              'Generate with AI',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily:
                                                            'Inter Tight',
                                                        fontSize: 19.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            subtitle: Text(
                                              'AI suggestions will be hidden',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            tileColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            activeTrackColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            dense: false,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: SwitchListTile.adaptive(
                                            value: _model
                                                .switchListTileValue3 ??= true,
                                            onChanged: (newValue) async {
                                              safeSetState(() =>
                                                  _model.switchListTileValue3 =
                                                      newValue!);
                                            },
                                            title: Text(
                                              'Enable reminders',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily:
                                                            'Inter Tight',
                                                        fontSize: 19.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            subtitle: Text(
                                              'push notifications for events',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            tileColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            activeTrackColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            dense: false,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     await _signOut();
                            //   },
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: FlutterFlowTheme.of(context)
                            //           .primaryBackground,
                            //       borderRadius: BorderRadius.circular(12.0),
                            //     ),
                            //     child: Padding(
                            //       padding: EdgeInsetsDirectional.fromSTEB(
                            //           16.0, 16.0, 16.0, 16.0),
                            //       child: Row(
                            //         mainAxisSize: MainAxisSize.max,
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Row(
                            //             mainAxisSize: MainAxisSize.max,
                            //             children: [
                            //               Icon(
                            //                 Icons.logout,
                            //                 color: FlutterFlowTheme.of(context)
                            //                     .error,
                            //                 size: 24.0,
                            //               ),
                            //               Text(
                            //                 'Sign Out',
                            //                 style: FlutterFlowTheme.of(context)
                            //                     .bodyMedium
                            //                     .override(
                            //                       fontFamily: 'Inter',
                            //                       color: FlutterFlowTheme.of(
                            //                               context)
                            //                           .error,
                            //                       letterSpacing: 0.0,
                            //                     ),
                            //               ),
                            //             ].divide(SizedBox(width: 12.0)),
                            //           ),
                            //           Icon(
                            //             Icons.chevron_right,
                            //             color: FlutterFlowTheme.of(context)
                            //                 .secondaryText,
                            //             size: 24.0,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: FlutterFlowTheme.of(context)
                            //         .primaryBackground,
                            //     borderRadius: BorderRadius.circular(12.0),
                            //   ),
                            //   child: Padding(
                            //     padding: EdgeInsetsDirectional.fromSTEB(
                            //         16.0, 16.0, 16.0, 16.0),
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Row(
                            //           mainAxisSize: MainAxisSize.max,
                            //           children: [
                            //             Icon(
                            //               Icons.logout,
                            //               color: FlutterFlowTheme.of(context)
                            //                   .error,
                            //               size: 24.0,
                            //             ),
                            //             Text(
                            //               'Sign Out',
                            //               style: FlutterFlowTheme.of(context)
                            //                   .bodyMedium
                            //                   .override(
                            //                     fontFamily: 'Inter',
                            //                     color:
                            //                         FlutterFlowTheme.of(context)
                            //                             .error,
                            //                     letterSpacing: 0.0,
                            //                   ),
                            //             ),
                            //           ].divide(SizedBox(width: 12.0)),
                            //         ),
                            //         Icon(
                            //           Icons.chevron_right,
                            //           color: FlutterFlowTheme.of(context)
                            //               .secondaryText,
                            //           size: 24.0,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ].divide(SizedBox(height: 20.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ].divide(SizedBox(height: 24.0)),
            ),
          ),
        ),
      ),
    );
  }
}
