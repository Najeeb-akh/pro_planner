import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pro_planner/pages/mainpage/mainpage_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'test.dart';
import 'package:pro_planner/theme/theme_notifier.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );

  // MaterialApp(
  //     title: 'App Title',
  //     theme: ThemeData(
  //       brightness: Brightness.light,
  //       /* light theme settings */
  //     ),
  //     darkTheme: ThemeData(
  //       brightness: Brightness.dark,
  //       /* dark theme settings */
  //     ),
  //     themeMode: ThemeMode.light,
  //     /* ThemeMode.system to follow system theme,
  //        ThemeMode.light for light theme,
  //        ThemeMode.dark for dark theme
  //     */
  //     debugShowCheckedModeBanner: false,
  //     home: MyApp(),
  //     //MyApp_test(),
  //   )
  //   );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  //ThemeMode _themeMode = ThemeMode.dark;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    _themeMode = FlutterFlowTheme.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeNotifier()), // Add ThemeNotifier
        ChangeNotifierProvider(create: (_) => _appStateNotifier),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
              title: 'ProPlanner',
              theme: themeNotifier.currentTheme,
              home: Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return auth.isLoggedIn ? MainpageWidget() : LoginWidget();
                },
              ) //LoginWidget(), //MainpageWidget(),
              );
        },
      ),
    );
  }

  // return MaterialApp(
  //   title: 'ProPlanner',
  //   localizationsDelegates: [
  //     GlobalMaterialLocalizations.delegate,
  //     GlobalWidgetsLocalizations.delegate,
  //     GlobalCupertinoLocalizations.delegate,
  //   ],
  //   supportedLocales: const [Locale('en', '')],
  //   theme: ThemeData(
  //     brightness: Brightness.light,
  //     useMaterial3: false,
  //   ),
  //   darkTheme: ThemeData(
  //     brightness: Brightness.dark,
  //     useMaterial3: false,
  //   ),
  //   themeMode: _themeMode,
  //   //routerConfig: _router,
  //   home: MyApp_test()

  //   //MyApp_test(),

  //   );
}
//}
