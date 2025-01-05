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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


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


class _MainpageWidgetState extends State<MainpageWidget> with WidgetsBindingObserver {
  late MainpageModel _model;
  bool isDarkMode = false;
  //should be changed to the user id from the firebase auth
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('users/userId1/events');
  int globalEventCounter = 20; // Global counter

  final scaffoldKey = GlobalKey<ScaffoldState>();

// support for greetings based on time of the day
  

  DateTime _selectedDate = DateTime.now();
  bool _isPopupVisible = false;
  bool _isFabVisible = true;
  String _eventTitle = ''; 
  String _eventGuests = ''; 
  String _eventLocation = ''; 
  String _eventDescription = '';
  String _eventStartTime = ''; 
  String _eventEndTime = ''; 
  Color selectedColor = Colors.blue;
  bool _isKeyboardVisible = false;
  
  /// Adds a new event with the specified details and saves it to the events list.
  ///
  /// This function handles the creation of a new event by generating necessary 
  /// IDs or data structures, then stores the result in the persistent data layer.
  /// Use this function in contexts where a fresh event is required to capture 
  /// user actions or system-triggered occurrences.
  ///
  /// Returns 1 if the event name is empty.
  /// Returns 2 if the event location is empty.
  /// Returns 3 if the event description is empty.
  /// returns 4 if the start time is after the end time.
  /// returns 5 if the start time or end time is empty.
  /// Returns 10 if the event is successfully added.  



  int _addNewEvent(String eventName, Color select_color,  DateTime startTime, DateTime endTime,  String description , String location) {
    // Check if any parameter is empty
    if (eventName.isEmpty)
      return 1;
    if (location.isEmpty)
      return 2;
    if (description.isEmpty)
      return 3;
    if (startTime.isAfter(endTime))
      return 4;
    if(startTime.toIso8601String() == "" || endTime.toIso8601String() == "")
      return 5;



    // Save the new event in Firebase Realtime Database
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('users/userId1/events');
      final eventId = 'eventId${globalEventCounter++}';
    databaseReference.child('/$eventId').set({
      'title': eventName,
      'color': select_color.value,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'description': _eventDescription,
    });

    return 10;
  }

  void _togglePopup() {
    _eventTitle = '';
    _eventGuests = '';
    _eventLocation = '';
    _eventDescription = '';
    _eventStartTime = '';
    _eventEndTime = '';
    setState(() {
      _isPopupVisible = !_isPopupVisible;
      _isFabVisible = !_isPopupVisible; // Add this line
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

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        _eventStartTime = picked.format(context); // Add this line
      });
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        _eventEndTime = picked.format(context); // Add this line
      });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainpageModel());
    _fetchEvents();
    _selectedDate = DateTime.now(); // Select the current date when the app is loaded
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  //   void _showColorPicker(BuildContext context) {
  //   final List<Color> colors = [
  //     Colors.red,
  //     Colors.green,
  //     Colors.blue,
  //     Colors.orange,
  //     Colors.purple,
  //     Colors.yellow,
  //   ];

  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return GridView.builder(
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 4,
  //           crossAxisSpacing: 8,
  //           mainAxisSpacing: 8,
  //         ),
  //         itemCount: colors.length,
  //         padding: EdgeInsets.all(16.0),
  //         itemBuilder: (BuildContext context, int index) {
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 selectedColor = colors[index];
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: colors[index],
  //                 shape: BoxShape.circle,
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showColorPicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Pick a Color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Select"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
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
        floatingActionButton: _isFabVisible && !_isKeyboardVisible // Modify this line
            ? FloatingActionButton.extended(
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
              )
            : 
            FloatingActionButton(
                onPressed: _togglePopup, 
                backgroundColor: FlutterFlowTheme.of(context).primaryText,
                child: Icon(
                  Icons.more_time_rounded,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 25.0,
                ),
                elevation: 8.0,
              ), // Add this line
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
                          Padding(padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                
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
                          
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(
                          //       16.0, 0.0, 16.0, 0.0),
                          //   child: Container(
                          //     width: MediaQuery.sizeOf(context).width * 1.0,
                          //     height: 190.0,
                          //     decoration: BoxDecoration(),
                          //     child: ListView(
                          //       padding: EdgeInsets.fromLTRB(
                          //         16.0,
                          //         0,
                          //         16.0,
                          //         0,
                          //       ),
                          //       primary: false,
                          //       scrollDirection: Axis.horizontal,
                          //       children: [
                          //         SuggestWidget(
                          //           icon: Icons.fitness_center,
                          //           categoryTitle: 'Fitness Suggestion',
                          //           mainTitle: 'Add gym to your schedule',
                          //           descriptionTime: 'You have free time today at 5 PM',
                          //         ),
                          //         SizedBox(width: 16.0),
                          //         SuggestWidget(
                          //           icon: Icons.work,
                          //           categoryTitle: 'Work Suggestion',
                          //           mainTitle: 'Schedule team meeting',
                          //           descriptionTime: 'Wednesday afternoon is open',
                          //         ),
                          //       ]
                          //                                       //.divide(SizedBox(width: 16.0)),
                          //     ),
                          //   ),
                          // ),
                          
                          
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
                GestureDetector(
                  onTap: null ,//_togglePopup,
                  child: Container(
                    //width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).brightness != Brightness.dark 
                        ? Colors.black.withOpacity(0.6)
                        :Colors.white.withOpacity(0.6),
                    child: 
                    Padding(padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 70.0),
                    child: 
                    Align(
                      alignment: Alignment.bottomCenter,
                      //heightFactor: 0.8,
                      child: 
                        Container(
                        width: MediaQuery.of(context).size.width* 0.95,
                        height: MediaQuery.of(context).size.height *0.70,
                        child: _buildPopupCard(),
                        ),
                      ),
                      
                    ),
                    ),
                  ),
        
                ],
                 
        ),
      ),
    );
  }



  Widget _buildPopupCard() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return 
    SingleChildScrollView(
      child: 
    Card(
      color: isDarkMode ? Colors.white: Colors.grey[900],
      //margin: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 8.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 8.0),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Event',
              style: TextStyle( 
                color: !isDarkMode ? Colors.white : Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',

              ),
              
              
            ),
            SizedBox(height: 12.0),
            
            SizedBox(
              height: 40,
              child:
              TextField(
              decoration: InputDecoration(
                labelText: 'Event Title',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                labelStyle: TextStyle(color: !isDarkMode ? Colors.white : Colors.grey[800]),
              ),
              style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
              onChanged: (value) {
                setState(() {
                  _eventTitle = value; // Add this line
                });
              },
            ),
            
            ),
            SizedBox(height: 10.0),
          
            ListTile(
              title: Text(
                "Date: ${selectedDate.toLocal().day}/${selectedDate.toLocal().month}/${selectedDate.toLocal().year}",
                style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
              ),
              trailing: Icon(Icons.calendar_today, color: !isDarkMode ? Colors.white : Colors.black),
              onTap: () => selectDate(context),
            ),

            
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Start Time: $_eventStartTime",
                          style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                        ),
                        IconButton(
                          icon: Icon(Icons.schedule, color: !isDarkMode ? Colors.white : Colors.black),
                          onPressed: () => selectStartTime(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "End Time: $_eventEndTime",
                          style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                        ),
                        IconButton(
                          icon: Icon(Icons.timer_off, color: !isDarkMode ? Colors.white : Colors.black),
                          onPressed: () => selectEndTime(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            
            
            SizedBox(height: 12.0),
             Row(
                children: [
                  Expanded(
                    child: 
                     SizedBox(
                    height: 40,
                    child:
                      TextField(
                      decoration: InputDecoration(
                        labelText: 'Add Guests - Not Implemented Yet',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        labelStyle: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                      ),
                      style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                      onChanged: (value) {
                        setState(() {
                          _eventGuests = value; // Add this line
                        });
                      },
                    ),
                     ),
                  ),
                  SizedBox(width: 12.0),
                  Icon(Icons.group, color: !isDarkMode ? Colors.white : Colors.black),
                ],
              ),
            SizedBox(height: 12.0),
             Row(
                children: [
                  Expanded(
                    child: 
                     SizedBox(
                    height: 40,
                    child:
                      TextField(
                      decoration: InputDecoration(
                        labelText: 'Add Location',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        labelStyle: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                      ),
                      style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                      onChanged: (value) {
                        setState(() {
                          _eventLocation = value; // Add this line
                        });
                      },
                    ),
                     ),
                  ),
                  SizedBox(width: 12.0),
                  Icon(Icons.location_pin, color: !isDarkMode ? Colors.white : Colors.black),
                ],
              ),


            SizedBox(height: 12.0),
             SizedBox(
              height: 80,
              child:
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Add Description or Attachment',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    labelStyle: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                  ),
                  style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black),
                  maxLines: 2,
                  onChanged: (value) {
                    setState(() {
                      _eventDescription = value; // Add this line
                    });
                  },
                  ),
              ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.brush, color: !isDarkMode ? Colors.white : Colors.black),
                  onPressed: () => _showColorPicker(context),
                ),
                //SizedBox(width: 5),
                 Text(
                  'Choose Color:',
                  style: TextStyle(
                    color: !isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                
                
                SizedBox(width: 30),
              
                
                GestureDetector(
                        onTap: () {
                          _showColorPicker(context);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: selectedColor, // The color chosen by the user
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                        ),
                      )
                // Label
               
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: _togglePopup,
                  child: Text("Cancel", style: TextStyle(color: !isDarkMode ? Colors.white : Colors.black)),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Parse times (adjust as needed for your time format).
                    final timeFormat = TimeOfDayFormat.H_colon_mm;
                    final now = DateTime.now();
                    TimeOfDay parseToTimeOfDay(String timeStr) {
                      // Basic split by space or handle 24-hour time accordingly.
                      // This example assumes "HH:MM" with optional AM/PM. 
                      // Adjust for your specific time format.
                      final parts = timeStr.split(' ');
                      final hhmm = parts[0].split(':');
                      int hour = int.tryParse(hhmm[0]) ?? 0;
                      final minute = int.tryParse(hhmm[1]) ?? 0;
                      final meridian = parts.length > 1 ? parts[1].toLowerCase() : '';
                      if (meridian == 'pm' && hour < 12) hour += 12;
                      if (meridian == 'am' && hour == 12) hour = 0;
                      return TimeOfDay(hour: hour, minute: minute);
                    }

                    // Build full start/end DateTime from selected date + chosen times
                    final startTimeOfDay = parseToTimeOfDay(_eventStartTime);
                    final endTimeOfDay = parseToTimeOfDay(_eventEndTime);
                    final startDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      startTimeOfDay.hour,
                      startTimeOfDay.minute,
                    );
                    final endDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      endTimeOfDay.hour,
                      endTimeOfDay.minute,
                    );

                  

                    final result = _addNewEvent(
                      _eventTitle.trim(),
                      selectedColor,
                      startDateTime,
                      endDateTime,
                      _eventDescription.trim(),
                     _eventLocation.trim(),
                    );

                    String message;
                    switch (result) {
                      case 1:
                        message = 'Event name is empty!';
                        break;
                      case 2:
                        message = 'Event location is empty!';
                        break;
                      case 3:
                        message = 'Event description is empty!';
                        break;
                      case 4:
                        message = 'Start time can\'t be after end time!';
                        break;
                      case 5:
                        message = 'Start or end time is empty!';
                        break;
                      case 10:
                        // clear back all the field
                        
                        message = 'Event Added Successfully!';
                        _togglePopup(); // If you prefer closing the popup on success
                        break;
                      default:
                        message = 'Unknown error!';
                        break;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: !isDarkMode ? Colors.grey[800] : Colors.blue,
                  ),
                  child: Text("Save", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    )
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

class SuggestWidget extends StatelessWidget {
  final IconData icon;
  final String categoryTitle;
  final String mainTitle;
  final String descriptionTime;

  const SuggestWidget({
    Key? key,
    required this.icon,
    required this.categoryTitle,
    required this.mainTitle,
    required this.descriptionTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 280.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    icon,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    categoryTitle,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                mainTitle,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Inter Tight',
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 8.0),
              Text(
                descriptionTime,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
