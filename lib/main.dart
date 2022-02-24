import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/screens/subscribe_file/identify_identity/upload_id.dart';
import 'package:uy/screens/subscribe_file/journalist_Kind.dart';
import 'package:uy/screens/subscribe_file/identify_identity/choose_country.dart';
import 'package:uy/screens/subscribe_file/sign_up_reader.dart';
import 'package:uy/services/provider/LanguageChangeProvider.dart';
import 'package:uy/screens/splashScreen.dart';
import 'package:uy/screens/forgetPassword_file/1_find_Account.dart';
import 'package:uy/screens/forgetPassword_file/2_pass_code.dart';
import 'package:uy/screens/forgetPassword_file/3_create_new_pass.dart';
import 'package:uy/screens/home/home_View.dart';
import 'package:uy/screens/subscribe_file/sign_Up_writer.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:uy/services/provider/article_search_provider.dart';
import 'package:uy/services/provider/attachementProvider.dart';
import 'package:uy/services/provider/centerBoxProvider.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/provider/current_position_provider.dart';
import 'package:uy/services/provider/hide_left_bar_provider.dart';
import 'package:uy/services/provider/media_message_provider.dart';
import 'package:uy/services/provider/message_list_provider.dart';
import 'package:uy/services/provider/message_provider.dart';
import 'package:uy/services/provider/profile_centerBar_provider.dart';
import 'package:uy/services/provider/profile_image_provider.dart';
import 'package:uy/services/provider/profile_provider.dart';
import 'package:uy/services/provider/read_filter_provider.dart';
import 'package:uy/services/provider/home_partProvider.dart';
import 'package:uy/services/provider/read_post_provider.dart';
import 'package:uy/services/provider/right_bar_provider.dart';
import 'package:uy/services/provider/search_details_provider.dart';
import 'package:uy/services/provider/search_field_provider.dart';
import 'package:uy/services/provider/settings_provider.dart';
import 'package:uy/services/provider/switch_provider.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
import 'package:uy/services/provider/topic_provider.dart';
import 'package:uy/services/provider/watch_filter_provider.dart';
import 'package:uy/services/routing.dart';
import 'package:uy/screens/onboarding_file/add_Profile_image.dart';
import 'package:uy/screens/onboarding_file/add_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:uy/screens/login_page/logInPage.dart';
import 'package:uy/screens/onboarding_file/welcome_page.dart';
import 'package:uy/screens/onboarding_file/review.dart';
import 'package:uy/screens/subscribe_file/subscribe_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:provider/provider.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //await firebase.auth(firebase.app("teltrue_web")).onAuthStateChanged.first;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CenterBoxProvider>.value(
          value: CenterBoxProvider(),
        ),
        ChangeNotifierProvider<FilterProvider>.value(
          value: FilterProvider(),
        ),
        ChangeNotifierProvider<FilterProviderChangeState>.value(
          value: FilterProviderChangeState(),
        ),
        ChangeNotifierProvider<HomePartIndexProvider>.value(
          value: HomePartIndexProvider(),
        ),
        ChangeNotifierProvider<WatchFilterProvider>.value(
          value: WatchFilterProvider(),
        ),
        ChangeNotifierProvider<RightBarProvider>.value(
          value: RightBarProvider(),
        ),
        ChangeNotifierProvider<SearchDetailsProvider>.value(
          value: SearchDetailsProvider(),
        ),
        ChangeNotifierProvider<SearchFieldProvider>.value(
          value: SearchFieldProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>.value(
          value: ProfileProvider(),
        ),
        ChangeNotifierProvider<ProfileImageProvider>.value(
          value: ProfileImageProvider(),
        ),
        ChangeNotifierProvider<ProfileCenterBarProvider>.value(
          value: ProfileCenterBarProvider(),
        ),
        ChangeNotifierProvider<TopicProvider>.value(
          value: TopicProvider(),
        ),
        ChangeNotifierProvider<ReadPostProvider>.value(
          value: ReadPostProvider(),
        ),
        ChangeNotifierProvider<MessageProvider>.value(
          value: MessageProvider(),
        ),
        ChangeNotifierProvider<AttachementMessageProvider>.value(
          value: AttachementMessageProvider(),
        ),
        ChangeNotifierProvider<MediaMessageProvider>.value(
          value: MediaMessageProvider(),
        ),
        ChangeNotifierProvider<MessageListProvider>.value(
          value: MessageListProvider(),
        ),
        ChangeNotifierProvider<SwitchProvider>.value(
          value: SwitchProvider(),
        ),
        ChangeNotifierProvider<HideLeftBarProvider>.value(
          value: HideLeftBarProvider(),
        ),
        ChangeNotifierProvider<SettingProvider>.value(
          value: SettingProvider(),
        ),
        ChangeNotifierProvider<TagPostProvider>.value(
          value: TagPostProvider(),
        ),
        ChangeNotifierProvider<SearchArticleProvider>.value(
          value: SearchArticleProvider(),
        ),
        ChangeNotifierProvider<GoogleMapsBlocsProvider>.value(
          value: GoogleMapsBlocsProvider(),
        ),
        ChangeNotifierProvider<CreateLocationProvider>.value(
          value: CreateLocationProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool active = false;
  bool firstTime = false;

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    return Locale(prefs.getString('langkey'));
  }

  activeCheck() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    if (doc.data()["active"] == true) {
      setState(() {
        active = true;
      });
    } else {
      setState(() {
        active = false;
      });
    }
  }

  firstTimeToLogIn() async {
    DocumentSnapshot doc = await users.doc(currentUser.uid).get();
    if (doc.data()["firstTime"] == false) {
      setState(() {
        firstTime = false;
      });
    } else {
      setState(() {
        firstTime = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    activeCheck();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null) {
        return Home();
      } else {
        return LoginPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
        builder: (context) => FutureBuilder(
            future: _fetchLocale(),
            builder: (context, snapshot) {
              Locale fetchedLocale = snapshot.data;

              return MaterialApp(
                locale: fetchedLocale,
                navigatorKey: navigatorKey,
                onGenerateRoute: RouteGenerator.generateRoute,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  S.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                routes: {
                  "/Sign_Up_choice": (context) => SubscribeMode(),
                  "/LogIn": (context) => LoginPage(),
                  "/SignUpWithEmail": (context) => SignUpWithEmail(),
                  "/signUpReader": (context) => SignUpReader(),
                  "/JournalistKind": (context) => JournalistKind(),
                  "/VerifyYourIdentity": (context) =>
                      IdentifyIdentityChooseCountry(),
                  "/VerifyYourIdentity2": (context) =>
                      IdentifyIdentityUploadId(),
                  "/PassCode": (context) => PassCode(),
                  "/Home": (context) => Home(),
                  "/AddProfileImage": (context) => AddProfileReaderImage(),
                  "/ForgetPassword": (context) => ForgetPassword(),
                  "/ForgetPassword3": (context) => ForgetPassword3(),
                  "/WelcomePage": (context) => WelcomePage(),
                  "/ReviewPage": (context) => ReviewPage(),
                  "/SplashScreen": (context) => SplashScreen(),
                  "/SuggestionPage": (context) => AddAndFollow(),
                },
                //initialRoute: "/Home",
                home: AnimatedSplashScreen(
                  duration: 4000,
                  splash: SplashScreen(),
                  curve: Curves.decelerate,
                  nextScreen: currentUser == null
                      ? LoginPage()
                      : currentUser != null && active
                          ? Home()
                          : ReviewPage(),
                  splashTransition: SplashTransition.fadeTransition,
                  backgroundColor: Colors.white,
                ),
              );
            }),
      ),
    );
  }
}
