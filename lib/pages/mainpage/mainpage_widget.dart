import '/components/drawer_widget.dart';
import '/components/generatebyai_widget.dart';
import '/components/menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mainpage_model.dart';
export 'mainpage_model.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../theme/theme_notifier.dart';
import 'package:flutter/services.dart';


class Event {
  final String title;
  final Color color;
  final String startTime;
  final String endTime;
  final String description;
  final String location;

  Event({
    required this.title,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.location,
  });

  factory Event.fromMap(Map<dynamic, dynamic> map) {
    return Event(
      title: map['title'],
      color: _getColorFromNumber(map['color']),
      startTime: map['startTime'],
      endTime: map['endTime'],
      description: map['description'],
      location: map['location'],
    );
  }

  static Color _getColorFromNumber(int number) {
    switch (number) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.blueAccent;
      case 3:
        return Colors.greenAccent;
      case 4:
        return Colors.yellowAccent;
      case 5:
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }
}

class FadingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const FadingText({
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 1000),
    Key? key,
  }) : super(key: key);

  @override
  _FadingTextState createState() => _FadingTextState();
  }

class _FadingTextState extends State<FadingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Widget> _letters;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _letters = widget.text.split('').map((letter) {
      return FadeTransition(
        opacity: _animation,
        child: Text(letter, style: widget.style),
      );
    }).toList();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _letters,
    );
  }
}





class MainpageWidget extends StatefulWidget {
  /// Description:
  ///
  /// The Opening Page of the app serves as the main dashboard for users. It
  /// includes the following elements:
  ///
  /// Header Section:
  ///
  /// A welcoming text or user’s name (e.g., "Good Morning, Najeeb").
  /// Current date displayed prominently.
  /// Suggestion Slidebar:
  ///
  /// A horizontally scrollable row at the top or middle of the page.
  /// Contains AI-generated suggestion cards (e.g., “Add gym to your schedule,”
  /// “You have free time on Wednesday afternoon”).
  /// Cards are interactive, allowing users to swipe, accept, or dismiss
  /// suggestions.
  /// Weekly Calendar View:
  ///
  /// Displays the current week in a Google Calendar-like format.
  /// Shows events in time blocks, with interactive features like tapping on
  /// events for details or empty slots to add new tasks.
  /// Current day highlighted for easy visibility.
  /// Action Buttons:
  ///
  /// Floating action button (FAB) at the bottom-right corner to quickly add a
  /// new event, task, or reminder.
  /// Navigation Menu:
  ///
  /// A bottom navigation bar with icons for easy access to key sections of the
  /// app (e.g., Home, Calendar, Settings).
  /// Design and Style:
  ///
  /// Clean, modern design with soft colors and minimalistic icons.
  /// A focus on readability and usability, with sufficient spacing between
  /// elements.
  /// add padding from the buttom
  const MainpageWidget({super.key});

  @override
  State<MainpageWidget> createState() => _MainpageWidgetState();
}


class _MainpageWidgetState extends State<MainpageWidget> {
  late MainpageModel _model;
  bool isDarkMode = false;
  //should be changed to the user id from the firebase auth
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('users/userId1/events');

  final scaffoldKey = GlobalKey<ScaffoldState>();

// support for greetings based on time of the day
  

  DateTime _selectedDate = DateTime.now();
  bool _isPopupVisible = false;

  void _togglePopup() {
    setState(() {
      _isPopupVisible = !_isPopupVisible;
    });
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainpageModel());
    _fetchEvents();
    _selectedDate = DateTime.now(); // Select the current date when the app is loaded
  }

  void _fetchEvents() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _events = data.values.map((e) => Event.fromMap(e)).toList();
      });
    });
  }

  List<Event> _events = [];

  List<Event> _getTodayEvents(_selectedDate) {
    DateTime now = _selectedDate;
    return _events.where((event) {
      DateTime eventDate = DateTime.parse(event.startTime);
      return eventDate.year == now.year &&
             eventDate.month == now.month &&
             eventDate.day == now.day;
    }).toList();
  }

  String _formatTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  var event_counter = 0;
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _togglePopup,
          backgroundColor: FlutterFlowTheme.of(context).primaryText,
          icon: Icon(
            Icons.more_time_rounded,
            color: FlutterFlowTheme.of(context).primaryBackground,
            size: 25.0,
          ),
          elevation: 8.0,
          label: Text(
            'Add Event',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).alternate,
                  letterSpacing: 0.0,
                ),
          ),
        ),
        drawer: Drawer(
          elevation: 16.0,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: wrapWithModel(
              model: _model.drawerModel,
              updateCallback: () => safeSetState(() {}),
              child: DrawerWidget(),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.sizeOf(context).height * 0.1),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).secondaryBackground),
            leadingWidth: 90000.0,
            automaticallyImplyLeading: true,
            leading: Opacity(
              opacity: 1,
              
              child: Align(
                alignment: AlignmentDirectional(1.0, 1.0),
                child: Row(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    // wrapWithModel(
                    //   model: _model.menuModel,
                    //   updateCallback: () => safeSetState(() {}),
                    //   child: MenuWidget(),
                    // ),
                    IconButton(
                      onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24,
                    ),
                  iconSize: 24,
                ),
                    Text(
                      _getGreeting(),
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Inter Tight',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
             
            ],
            centerTitle: false,
            toolbarHeight: MediaQuery.sizeOf(context).height * 0.2,
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                child: WeeklyCalendarWidget(
                                  onDateSelected: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                  },
                                  selectedDate: _selectedDate,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
                                child:  Column(
                                    key: ValueKey(_selectedDate),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Today\'s Schedule',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: 'Inter Tight',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      
                                      // take the events from the firebase and put inside of the widget
                                      if (_getTodayEvents(_selectedDate).isEmpty)
                                        
                                        Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0)),
                                                 
                                                    ShaderMask(
                                                        shaderCallback: (bounds) => LinearGradient(
                                                          colors: [Colors.blue, Colors.purple, Colors.amber[700]!],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ).createShader(bounds),
                                                        child: Center(
                                                          child: Column(
                                                          children: [
                                                              
                                                          FadingText(
                                                          //textAlign: TextAlign.center,
                                                          text: "You have no events today.",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontStyle: FontStyle.italic,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white, // Acts as a fallback color
                                                          ),
                                                        ),
                                                            FadingText(
                                                          //textAlign: TextAlign.center,
                                                          text: "Why not add something to look forward to?",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontStyle: FontStyle.italic,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white, // Acts as a fallback color
                                                          ),
                                                        ),
                                                            
                                                            ],
                                                          ),    
                                                        
                                                        ),
                                                      ),
                                                  Padding(padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0)),
                                                  
                                                
                                                ],
                                              ),
                                      for (var event in _getTodayEvents(_selectedDate)..sort((a, b) => DateTime.parse(a.startTime).compareTo(DateTime.parse(b.startTime)))) 
                                        EventCardWidget(
                                              title: event.title,
                                              color: event.color,
                                              startTime: event.startTime,
                                              endTime: event.endTime,
                                            ),
                                      
                                    ].divide(SizedBox(height: 16.0)),
                                  ),
                                ),
                              ),
                            ),
                          
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: 190.0,
                              decoration: BoxDecoration(),
                              child: ListView(
                                padding: EdgeInsets.fromLTRB(
                                  16.0,
                                  0,
                                  16.0,
                                  0,
                                ),
                                primary: false,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  // suggestion card sprint 2
                                  // Material(
                                  //   color: Colors.transparent,
                                  //   elevation: 2.0,
                                  //   shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(16.0),
                                  //   ),
                                  //   child: Container(
                                  //     width: 280.0,
                                  //     height: double.infinity,
                                  //     decoration: BoxDecoration(
                                  //       color: FlutterFlowTheme.of(context)
                                  //           .secondaryBackground,
                                  //       borderRadius: BorderRadius.circular(16.0),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: EdgeInsetsDirectional.fromSTEB(
                                  //           16.0, 16.0, 16.0, 16.0),
                                  //       child: Column(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             mainAxisSize: MainAxisSize.max,
                                  //             children: [
                                  //               Icon(
                                  //                 Icons.fitness_center,
                                  //                 color:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .primary,
                                  //                 size: 24.0,
                                  //               ),
                                  //               Text(
                                  //                 'Fitness Suggestion',
                                  //                 style:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .bodySmall
                                  //                         .override(
                                  //                           fontFamily: 'Inter',
                                  //                           color:
                                  //                               FlutterFlowTheme.of(
                                  //                                       context)
                                  //                                   .primary,
                                  //                           letterSpacing: 0.0,
                                  //                         ),
                                  //               ),
                                  //             ].divide(SizedBox(width: 12.0)),
                                  //           ),
                                  //           Text(
                                  //             'Add gym to your schedule',
                                  //             style: FlutterFlowTheme.of(context)
                                  //                 .headlineSmall
                                  //                 .override(
                                  //                   fontFamily: 'Inter Tight',
                                  //                   letterSpacing: 0.0,
                                  //                 ),
                                  //           ),
                                  //           Text(
                                  //             'You have free time today at 5 PM',
                                  //             style: FlutterFlowTheme.of(context)
                                  //                 .bodyMedium
                                  //                 .override(
                                  //                   fontFamily: 'Inter',
                                  //                   color:
                                  //                       FlutterFlowTheme.of(context)
                                  //                           .secondaryText,
                                  //                   letterSpacing: 0.0,
                                  //                 ),
                                  //           ),
                                  //         ].divide(SizedBox(height: 8.0)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                 
                                 //suggestion card sprint 2
                                  // Material(
                                  //   color: Colors.transparent,
                                  //   elevation: 2.0,
                                  //   shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(16.0),
                                  //   ),
                                  //   child: Container(
                                  //     width: 280.0,
                                  //     decoration: BoxDecoration(
                                  //       color: FlutterFlowTheme.of(context)
                                  //           .secondaryBackground,
                                  //       borderRadius: BorderRadius.circular(16.0),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: EdgeInsetsDirectional.fromSTEB(
                                  //           16.0, 16.0, 16.0, 16.0),
                                  //       child: Column(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             mainAxisSize: MainAxisSize.max,
                                  //             children: [
                                  //               Icon(
                                  //                 Icons.work,
                                  //                 color:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .secondary,
                                  //                 size: 24.0,
                                  //               ),
                                  //               Text(
                                  //                 'Work Suggestion',
                                  //                 style:
                                  //                     FlutterFlowTheme.of(context)
                                  //                         .bodySmall
                                  //                         .override(
                                  //                           fontFamily: 'Inter',
                                  //                           color:
                                  //                               FlutterFlowTheme.of(
                                  //                                       context)
                                  //                                   .secondary,
                                  //                           letterSpacing: 0.0,
                                  //                         ),
                                  //               ),
                                  //             ].divide(SizedBox(width: 12.0)),
                                  //           ),
                                  //           Text(
                                  //             'Schedule team meeting',
                                  //             style: FlutterFlowTheme.of(context)
                                  //                 .headlineSmall
                                  //                 .override(
                                  //                   fontFamily: 'Inter Tight',
                                  //                   letterSpacing: 0.0,
                                  //                 ),
                                  //           ),
                                  //           Text(
                                  //             'Wednesday afternoon is open',
                                  //             style: FlutterFlowTheme.of(context)
                                  //                 .bodyMedium
                                  //                 .override(
                                  //                   fontFamily: 'Inter',
                                  //                   color:
                                  //                       FlutterFlowTheme.of(context)
                                  //                           .secondaryText,
                                  //                   letterSpacing: 0.0,
                                  //                 ),
                                  //           ),
                                  //         ].divide(SizedBox(height: 8.0)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ]
                                //.divide(SizedBox(width: 16.0)),
                              ),
                            ),
                          ),
                          
                          
                          //generate with ai button sprint 2
                          wrapWithModel(
                            model: _model.generatebyaiModel,
                            updateCallback: () => safeSetState(() {}),
                            child: GeneratebyaiWidget(),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              height: 60.0,
                              decoration: BoxDecoration(),
                            ),
                            
                          ),
                            
                        ]
                            .divide(SizedBox(height: 25.0))
                            .around(SizedBox(height: 25.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isPopupVisible)
              if (_isPopupVisible)
                GestureDetector(
                  onTap: _togglePopup,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    child: 
                    Padding(padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 70.0),
                    child: 
                    Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 0.8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        margin: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: _buildPopupCard(),
                      ),
                    ),
                    ),
                  ),
                )],
        ),
      ),
    );
  }

  Widget _buildPopupCard() {
    return 
    
    Card(
      margin: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 8.0),
      child: Padding(
        padding:EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 8.0),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Event',
              style: FlutterFlowTheme.of(context).headlineSmall,
            ),
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            ListTile(
              title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () => selectDate(context),
            ),
            ListTile(
              title: Text("Time: ${selectedTime.format(context)}"),
              trailing: Icon(Icons.access_time),
              onTap: () => selectTime(context),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Add Guests',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Add Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(

              decoration: InputDecoration(
                labelText: 'Add Description or Attachment',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyCalendarWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  const WeeklyCalendarWidget({
    required this.onDateSelected,
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  _WeeklyCalendarWidgetState createState() => _WeeklyCalendarWidgetState();
}

class _WeeklyCalendarWidgetState extends State<WeeklyCalendarWidget> {
  DateTime _currentWeekStart = _getStartOfWeek(DateTime.now());
  bool _isSwiping = false;

  static DateTime _getStartOfWeek(DateTime date) {
    int daysToSubtract = date.weekday % 7;
    return date.subtract(Duration(days: daysToSubtract));
  }

  void _goToPreviousWeek() {
    setState(() {
      _isSwiping = true;
      _currentWeekStart = _currentWeekStart.subtract(Duration(days: 7));
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isSwiping = false;
      });
    });
  }

  void _goToNextWeek() {
    setState(() {
      _isSwiping = true;
      _currentWeekStart = _currentWeekStart.add(Duration(days: 7));
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isSwiping = false;
      });
    });
  }

  List<DateTime> _getWeekDates() {
    return List.generate(7, (index) => _currentWeekStart.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _goToNextWeek();
        } else if (details.primaryVelocity! > 0) {
          _goToPreviousWeek();
        }
      },
      child: AnimatedOpacity(
        opacity: _isSwiping ? 0.5 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goToPreviousWeek,
                ),
                Text(
                  'Weekly View',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _goToNextWeek,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getWeekDates().map((date) {
                return GestureDetector(
                  onTap: () {
                    widget.onDateSelected(date);
                  },
                  child: Column(
                    children: [
                      Text(
                        ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: date == widget.selectedDate
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: date == widget.selectedDate
                                  ? FlutterFlowTheme.of(context).info
                                  : FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
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
  
class EventList extends StatefulWidget {
  final List<Event> events; // Use Event class instead of Map<String, dynamic>

  const EventList({Key? key, required this.events}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    // Adding events one by one with a delay
    Future.delayed(Duration.zero, () async {
      for (int i = 0; i < widget.events.length; i++) {
        await Future.delayed(Duration(milliseconds: 300));
        _listKey.currentState?.insertItem(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: 0, // Initially, the list is empty; items are added dynamically
      itemBuilder: (context, index, animation) {
        final event = widget.events[index];
        return _buildAnimatedCard(event, animation);
      },
    );
  }

  Widget _buildAnimatedCard(Event event, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0), // Slide in from the left
        end: Offset(0, 0),    // Final position
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: EventCardWidget(
          title: event.title,
          color: event.color,
          startTime: event.startTime,
          endTime: event.endTime,
        ),
      ),
    );
  }
}


class EventCardWidget extends StatelessWidget {
  final String title;
  final Color color;
  final String startTime;
  final String endTime;

  const EventCardWidget({
    Key? key,
    required this.title,
    required this.color,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  String _formatTime(String time) {
    final dateTime = DateTime.parse(time);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final AnimationController _controller = AnimationController(
      vsync: Scaffold.of(context), // Ensure context has a TickerProvider
      duration: Duration(milliseconds: 900),
    );

    final Animation<double> _fadeAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start the animation when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    bool isStartTimeAM = DateTime.parse(startTime).hour < 12;
    bool isEndTimeAM = DateTime.parse(endTime).hour < 12;

    return FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
      color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 4.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                isStartTimeAM && isEndTimeAM ? '${_formatTime(startTime)} AM - ${_formatTime(endTime)} AM ': 
                        !isStartTimeAM && isEndTimeAM ? '${_formatTime(startTime)} PM - ${_formatTime(endTime)} AM ':
                          isStartTimeAM && !isEndTimeAM ? '${_formatTime(startTime)} AM - ${_formatTime(endTime)} PM ': 
                            '${_formatTime(startTime)} PM - ${_formatTime(endTime)} PM ',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
                      ),
                    ],
                  ),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
          ),
        ),
      );
  }
}
