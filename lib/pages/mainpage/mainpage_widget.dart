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

  DateTime _selectedDate = DateTime.now();

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

  List<Event> _getTodayEvents() {
    DateTime now = DateTime.now();
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

  Widget buildEventCard(String title, Color color, String startTime, String endTime) {
    return Container(
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
                    '${_formatTime(startTime)} - ${_formatTime(endTime)}',
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
    );
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('FloatingActionButton pressed ...');
          },
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
              Size.fromHeight(MediaQuery.sizeOf(context).height * 0.08),
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
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            child: Column(
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
                                for (var event in _getTodayEvents())
                                  buildEventCard(event.title, event.color, event.startTime, event.endTime),
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
                              Material(
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Container(
                                  width: 280.0,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.fitness_center,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 24.0,
                                            ),
                                            Text(
                                              'Fitness Suggestion',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ].divide(SizedBox(width: 12.0)),
                                        ),
                                        Text(
                                          'Add gym to your schedule',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                fontFamily: 'Inter Tight',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          'You have free time today at 5 PM',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Container(
                                  width: 280.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.work,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 24.0,
                                            ),
                                            Text(
                                              'Work Suggestion',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ].divide(SizedBox(width: 12.0)),
                                        ),
                                        Text(
                                          'Schedule team meeting',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                fontFamily: 'Inter Tight',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          'Wednesday afternoon is open',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ),
                      ),
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
                  'This Week',
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

