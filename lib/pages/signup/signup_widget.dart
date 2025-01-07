import 'package:pro_planner/index.dart';
import 'package:pro_planner/main.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup_model.dart';
export 'signup_model.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> with SingleTickerProviderStateMixin {
  late SignupModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignupModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    try {
      firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _model.textController1!.text,
        password: _model.textController2!.text,
      );

      final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('users/');
      final userId = userCredential.user?.uid;
      databaseReference.child('/$userId').set({
        'name': _model.textController3!.text,
        'email': _model.textController1!.text,
        'description': _model.textController4!.text,
        'events': [],
        'suggestions': [],
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Successfully signed up as ${userCredential.user?.email}')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainpageWidget(
            user: userCredential.user,
          ),
        ),
      );
    } catch (e) {
      String errorMessage;
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Operation not allowed.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'An unknown error occurred.';
        }
      } else {
        errorMessage = 'Failed to sign up: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

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
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                      Color(0xFF0F2027),
                    ],
                    begin: _animation.value,
                    end: AlignmentDirectional(-1.0, 1.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: MediaQuery.sizeOf(context).height * 1.0,
                        decoration: BoxDecoration(
                          color: Color(0x66000000),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.75,
                              child: Material(
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    color: FlutterFlowTheme.of(context).alternate,
                                    size: 60.0,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Create Account',
                              style: FlutterFlowTheme.of(context).displaySmall.override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Sign up to start your journey',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFE0E0E0),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Material(
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _model.textController3,
                                          focusNode: _model.textFieldFocusNode3,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  letterSpacing: 0.0,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0x1AFFFFFF),
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).alternate,
                                                letterSpacing: 0.0,
                                              ),
                                          minLines: 1,
                                          validator: _model.textController3Validator.asValidator(context),
                                        ),
                                        TextFormField(
                                          controller: _model.textController1,
                                          focusNode: _model.textFieldFocusNode1,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  letterSpacing: 0.0,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0x1AFFFFFF),
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).alternate,
                                                letterSpacing: 0.0,
                                              ),
                                          minLines: 1,
                                          keyboardType: TextInputType.emailAddress,
                                          validator: _model.textController1Validator.asValidator(context),
                                        ),
                                        TextFormField(
                                          controller: _model.textController2,
                                          focusNode: _model.textFieldFocusNode2,
                                          autofocus: false,
                                          obscureText: !_model.passwordVisibility,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  letterSpacing: 0.0,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0x1AFFFFFF),
                                            suffixIcon: InkWell(
                                              onTap: () => safeSetState(
                                                () => _model.passwordVisibility = !_model.passwordVisibility,
                                              ),
                                              focusNode: FocusNode(skipTraversal: true),
                                              child: Icon(
                                                _model.passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).alternate,
                                                letterSpacing: 0.0,
                                              ),
                                          minLines: 1,
                                          validator: _model.textController2Validator.asValidator(context),
                                        ),
                                        TextFormField(
                                          controller: _model.textController4,
                                          focusNode: _model.textFieldFocusNode4,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  letterSpacing: 0.0,
                                                ),
                                            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0x1AFFFFFF),
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).alternate,
                                                letterSpacing: 0.0,
                                              ),
                                          minLines: 1,
                                          validator: _model.textController4Validator.asValidator(context),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () {
                                            _signUp();
                                          },
                                          text: 'Sign Up',
                                          options: FFButtonOptions(
                                            width: MediaQuery.sizeOf(context).width * 1.0,
                                            height: 50.0,
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                  fontFamily: 'Inter Tight',
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  letterSpacing: 0.0,
                                                ),
                                            elevation: 3.0,
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 16.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginWidget(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ].divide(SizedBox(height: 24.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
