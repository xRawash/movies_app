import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:libtorrent_flutter/libtorrent_flutter.dart';
import 'package:movies_app/config/theme_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/prefs_manager/prefs_manager.dart';
import 'package:movies_app/provider/config_provider.dart';
import 'package:movies_app/repos/bookmark_repo/bookmark_repo.dart';
import 'package:movies_app/view_models/bookmark_view_model/bookmark_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PrefsManager.init();
  await GoogleSignIn.instance.initialize(
    serverClientId: '1073046631409-j38p3tdr2m7lpf2obhsbvnl159in4gkj.apps.googleusercontent.com',
  );
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    final user = await FirebaseServices.getCurrentUser(firebaseUser.uid);
    if (user == null) {
      await FirebaseAuth.instance.signOut();
    } else {
      UserModel.loggedInUser = user;
    }
  }
  await LibtorrentFlutter.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConfigProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkViewModel(bookmarkRepo: BookmarkRepo())),
      ],
      child: const MoviesApp(),
    ),
  );
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    bool isFinishedOnboarding = PrefsManager.getIsFinishedOnboarding() ?? false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(configProvider.currentLanguage == 'en' ? 'en' : 'ar'),
      initialRoute: !isFinishedOnboarding
          ? RoutesManager.onboarding
          : UserModel.loggedInUser != null
          ? RoutesManager.mainScreen
          : RoutesManager.register,
      onGenerateRoute: RoutesManager.getRoute,
      theme: ThemeManager.light,
      darkTheme: ThemeManager.dark,
      themeMode: ThemeMode.system,
    );
  }
}
