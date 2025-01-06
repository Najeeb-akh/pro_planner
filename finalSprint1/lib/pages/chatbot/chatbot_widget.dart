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
import 'package:firebase_database/firebase_database.dart';
import 'package:pro_planner/pages/mainpage/mainpage_model.dart';
import 'package:pro_planner/pages/chatbot/riveanimation.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../state/user_state.dart';

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key, this.user});

  final firebase_auth.User? user;

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> with WidgetsBindingObserver {
  late ChatbotModel _model;
  bool _isKeyboardVisible = false;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final List<ChatBubbleWidget> _messages = [];
  final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash-002');
  final ValueNotifier<bool> _messageNotifier = ValueNotifier(false);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('users/userId1/events');
  String rrespond = '';
  String _userName = '';


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = createModel(context, () => ChatbotModel());
    _fetchEvents();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    model.generateContent([Content.text("hi my name is ${Provider.of<UserState>(context, listen: false).userName} respond with 2 lovely emojis and a greeting message based on time and weather one line at maximum")]).then((response) {
      setState(() {
        rrespond = response.text ?? '';
      });
    });

  }

  // void _fetchUserName() async {
  //   final userId = widget.user?.uid;
  //   if (userId != null) {
  //     final snapshot = await FirebaseDatabase.instance.ref().child('users/$userId/name').get();
  //     if (snapshot.exists) {
  //       setState(() {
  //         _userName = snapshot.value as String;
  //       });
  //     }
  //   }
  // }

  //Fetch schedules from Firebase based on the query
  List<Event> _events = [];
  void _fetchEvents() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _events = data.values.map((e) => Event.fromMap(e)).toList();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    _scrollController.dispose();
    _messageNotifier.dispose();
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
  
  Future<String> _firstResponse() async {
    final response = await model.generateContent(
      [Content.text("hi my name is adam")],
    );
    final responseText = response.text ?? '';
    return responseText;
  }

  void _sendMessage() async {
    if (_model.textController!.text.isNotEmpty) {
      final userMessage = _model.textController!.text;

      // Clear the text input field after sending the message
      _model.textController!.clear();

      // Add the user's message to the list of messages and update the UI
      setState(() {
        _messages.add(ChatBubbleWidget(
          isAi: false,
          title: 'You',
          message: userMessage,
        ));
        _isLoading = true;
      });

      _messageNotifier.value = true;
      // Scroll to the bottom of the list after the frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      String eventsToString() {
        return _events.map((event) {
          return 'Title: ${event.title}, '
                'Color: ${event.color}, '
                'Start Time: ${event.startTime}, '
                'End Time: ${event.endTime}, '
                'Description: ${event.description}, '
                'Location: ${event.location}';
        }).join('\n');
      }

      // today's date
      final today = DateTime.now();

      String messageTOrespons = "today's date and time are : " + today.toIso8601String() + ", start answering :" + userMessage + ".if you need more detailes for the answer take a look in my events , Here is my upcoming events: " + eventsToString() +
      "reply with short answers, avoid writing with * and make dicisions based on the context of the event title only if the event title is not clear to you, ask me for more details" +
      "its okay if there are clashing events,but dont give or suggest an event that clash with other events";

      // Generate a response from the AI model
      try {
        final response = await model.generateContent(
          [Content.text(messageTOrespons)],
        );
        if (response.text != null && response.text!.isNotEmpty) {
          setState(() {
            _messages.add(ChatBubbleWidget(
              isAi: true,
              title: 'AI Assistant',
              message: response.text!,
            ));
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _messages.add(ChatBubbleWidget(
              isAi: true,
              title: 'AI Assistant',
              message: "I was unable to generate an answer",
            ));
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
          _messages.add(ChatBubbleWidget(
            isAi: true,
            title: 'AI Assistant',
            message: "An error occurred during API call",
          ));
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        print("Error summarizing text: $error");
      }
    }
  }

  void ScheduleBiAI(String s) async {
    String eventsToString() {
      return _events.map((event) {
        return 'Title: ${event.title}, '
              'Color: ${event.color}, '
              'Start Time: ${event.startTime}, '
              'End Time: ${event.endTime}, '
              'Description: ${event.description}, '
              'Location: ${event.location}';
      }).join('\n');
    }

    final response = await model.generateContent(
      [Content.text("i want you to help me " + s + "imagine that you are my personal assistant," + "Here are all of my events, parse the events to title, start time end time location as needed: " + eventsToString() +
             "reply with short answers, avoid writing with * " +
             "also make sure to take into consideration the prompt and event that i want to add, including suitable times based on common sense and suitable time based on events from the past only if the titles of the events make sense to you." +
             "ignore clashing events, if the clash occurs look at the starting time if you need" +
             "preferably answer should include the event title (new one not from previous eventsr) and the time of the event in readable format, and location, add small describtion if needed")],
    );
    setState(() {
      _messages.add(ChatBubbleWidget(
        isAi: true,
        title: 'AI Assistant',
        message: response.text!,
      ));
      _isLoading = false;
    });
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
            //show the greeting message
            'AI Assistant',
            // hda sho ekon mktoob b3d el icon up bar
            //_getGreeting(),
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
                ? MediaQuery.sizeOf(context).height * 0.55
                : MediaQuery.sizeOf(context).height * 0.85,
            child: SafeArea(
              top: false,
              child: Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                      height: 150,
                                      width: 150,
                                        color: Colors.transparent,
                                      child:MyRiveAnimation(),
                                    ),
                                
                                Expanded(
                                  child: SpeechBalloon(
                                    nipLocation: NipLocation.left,
                                    nipHeight: 13,
                                    color: Color(0xFFCDC1FF).withOpacity(0.8),
                                    borderRadius: 12.0,
                                    height: 100,
                                    width: 150,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: FutureBuilder<String>(
                                        future: Future.value(rrespond),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data ?? '',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //suggetions for input
                        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  // Your logic for "Plan team meeting"
                                  ScheduleBiAI("plan a meeting");
                                },
                                child: Text('Plan team meeting'),
                              ),
                              SizedBox(width: 8), // Add spacing between buttons
                              ElevatedButton(
                                onPressed: () {
                                  // Your logic for "Schedule a meeting"
                                  ScheduleBiAI("Schedule a meeting");
                                },
                                child: Text('Schedule a meeting'),
                              ),
                              SizedBox(width: 8), // Add spacing between buttons
                              ElevatedButton(
                                onPressed: () {
                                  // Your logic for "Schedule a workout"
                                  ScheduleBiAI("Schedule a workout");
                                },
                                child: Text('Schedule a workout'),
                              ),
                            ],
                          ),
                        ),
                        ],
                        ),
                        ),

                        // chat bubbles
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                          valueListenable: _messageNotifier,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                // Chat messages section
                                Expanded(
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    itemCount: _messages.length,
                                    itemBuilder: (context, index) {
                                      return _messages[index]; // Assuming _messages contains widgets
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  child: Row(
                                    children: [
                                      // Text field
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          child: TextFormField(
                                            controller: _model.textController,
                                            focusNode: _model.textFieldFocusNode,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              hintText: 'Type your message...',
                                              hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                
                                
                                                  ),
                                                  border: InputBorder.none,
                                              contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0, vertical: 12.0),
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Inter',
                                                ),
                                            textAlign: TextAlign.start,
                                            minLines: 1,
                                            maxLines: 4,
                                          ),
                                        ),
                                      ),
                                      // Send button
                                      const SizedBox(width: 8.0),
                                      Container(
                                        width: 45.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primary,
                                          borderRadius: BorderRadius.circular(22.0),
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
                                    ],
                                    
                                  ),
                                ),
                              ],
                            );
                          },
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

class Event {
  final String title;
  final Color color;
  final String startTime;
  final String endTime;
  final String description;
  final String location;
  final DateTime date; // Add date field

  Event({
    required this.title,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.location,
    required this.date, // Initialize date field
  });

  factory Event.fromMap(Map<dynamic, dynamic> map) {
    return Event(
      title: map['title'] ?? '',
      color: _getColorFromNumber(map['color'] ?? 0),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(), // Parse date field
    );
  }

  static Color _getColorFromNumber(int number) {
    return Color(number);
  }
}