import 'package:pro_planner/index.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import the User class
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pro_planner/pages/mainpage/mainpage_widget.dart';
import 'generatebyai_model.dart';
export 'generatebyai_model.dart';
import '../../state/user_state.dart';


class GeneratebyaiWidget extends StatefulWidget {
  /// Add generate by AI button, make it with special color and gradient border
  const GeneratebyaiWidget({super.key, required this.user, required this.events});

  final User? user;
  final List<Event> events;

  @override
  State<GeneratebyaiWidget> createState() => _GeneratebyaiWidgetState();
}

class _GeneratebyaiWidgetState extends State<GeneratebyaiWidget> {
  late GeneratebyaiModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GeneratebyaiModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              FlutterFlowTheme.of(context).primary,
              FlutterFlowTheme.of(context).secondary,
              FlutterFlowTheme.of(context).tertiary
            ],
            stops: [0.0, 0.5, 1.0],
            begin: AlignmentDirectional(1.0, -1.0),
            end: AlignmentDirectional(-1.0, 1.0),
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FFButtonWidget(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatbotWidget(
                      user: widget.user,
                      events: widget.events,
                    ),
                  ),
                );
              },
              text: 'Generate With AI',
              icon: Icon(
                Icons.auto_awesome,
                color: FlutterFlowTheme.of(context).info,
                size: 20.0,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: Color(0xFF1A1A2F),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: FlutterFlowTheme.of(context).info,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
