import 'package:pro_planner/pages/mainpage/mainpage_widget.dart';
import '/components/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chatbot_model.dart';
export 'chatbot_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
//import mainpage_model.dart;
import 'package:pro_planner/pages/mainpage/mainpage_model.dart';

class ChatbotWidget extends StatefulWidget {
  /// create a generate by ai page, the page is for a chat bot, a small bar for
  /// recommended suggestions of prompts and after the chat gives a suggestiona
  /// button for adding the event to schedule will show up
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}
String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, Najeeb';
    } else if (hour < 18) {
      return 'Good Afternoon, Najeeb';
    } else {
      return 'Good Evening, Najeeb';
    }
  }

class _ChatbotWidgetState extends State<ChatbotWidget> with WidgetsBindingObserver {
  late ChatbotModel _model;
  bool _isKeyboardVisible = false;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final List<ChatBubbleWidget> _messages = [];
  final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash-001');

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = createModel(context, () => ChatbotModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0.0;
      if (!_isKeyboardVisible) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_model.textController!.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatBubbleWidget(
          isAi: false,
          title: 'You',
          message: _model.textController!.text,
         ));
        _isLoading = true;
      });
      final userMessage = _model.textController!.text;
      _model.textController!.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      final response = await model.generateContent(
        [Content.text(userMessage)],
      );
      if (response.text != null) {
        setState(() {
          _messages.add(ChatBubbleWidget(
            isAi: true,
            title: 'AI Assistant',
            message: response.text!,
           ));
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).secondaryBackground),
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              // Navigate back to the main page
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainpageWidget()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
          ),
          title: Text(
            _getGreeting(),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        body: SingleChildScrollView(
          //controller: _scrollController,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: _isKeyboardVisible
                ? MediaQuery.sizeOf(context).height * 0.7
                : MediaQuery.sizeOf(context).height * 1.0,
            child: SafeArea(
              top: false,
              child: Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    children:[
                      // header still view
                      Container(
                        
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //header and title
                        Container(
                           //padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'AI Assistant',
                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        fontFamily: 'Inter Tight',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Text(
                                  'How can I help you today?',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ),
                        ),
                        //suggetions for input
                       
                        Container(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                          height: 70.0,
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                              16.0,
                              0,
                              16.0,
                              0,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              // suggestions for input
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                                  child: Text(
                                    'Schedule a workout',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).alternate,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                ),  
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                                  child: Text(
                                    'Plan team meeting',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context).alternate,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),

                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                   padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                                    child: Text(
                                      'Family dinner',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).alternate,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        ],
                        ),
                        ),
                      
                        // chat bubbles
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                Container(
                                  height: MediaQuery.sizeOf(context).height * 0.55,
                                  child: 
                                  ListView(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                  children: _messages,
                                  
                                  ),
                                  
                                  ),
                                
                                // this is the input box
                                Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 16.0, 8.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0.0, 0.0),
                                              child: Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: _model.textController,
                                                  focusNode:
                                                      _model.textFieldFocusNode,
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Type your message...',
                                                    hintStyle:
                                                        FlutterFlowTheme.of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily: 'Inter',
                                                              letterSpacing: 0.0,
                                                            ),
                                                    enabledBorder: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedErrorBorder:
                                                        InputBorder.none,
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                  textAlign: TextAlign.center,
                                                  minLines: 1,
                                                  validator: _model
                                                      .textControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 45.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(22.0),
                                          ),
                                          child: _isLoading
                                              ? CircularProgressIndicator(
                                                  color: FlutterFlowTheme.of(context).info,
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: FlutterFlowTheme.of(context).info,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: _sendMessage,
                                                ),
                                        ),
                                      ].divide(SizedBox(width: 16.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubbleWidget extends StatelessWidget {
  final bool isAi; // false => user, true => AI
  final String title;
  final String message;

  const ChatBubbleWidget({
    Key? key,
    required this.isAi,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = isAi
      ? FlutterFlowTheme.of(context).primary // AI style
      : FlutterFlowTheme.of(context).secondaryBackground; // user style

    final textColor = isAi
      ? FlutterFlowTheme.of(context).info
      : FlutterFlowTheme.of(context).primaryText;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              message,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: textColor,
                  ),
            ),
          ].divide(const SizedBox(height: 8.0)),
        ),
      ),
      ),
    );
  }
}