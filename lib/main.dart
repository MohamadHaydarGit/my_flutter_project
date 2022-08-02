import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:turtle_ninja/models/CharacterData.dart';
import 'package:turtle_ninja/models/lastUpdate.dart';
import 'package:turtle_ninja/models/userCredentials.dart';
import 'package:turtle_ninja/models/userLikes.dart';
import 'package:turtle_ninja/pages/details/details.dart';
import 'package:turtle_ninja/pages/map/map.dart';
import 'package:turtle_ninja/pages/wrapper.dart';
import 'package:turtle_ninja/services/auth.dart';
import 'package:turtle_ninja/services/boxes.dart';
import 'package:turtle_ninja/services/localNotificationService.dart';
import 'connection/connectionStatusSingleton.dart';
import 'drawer/drawer.dart';
import 'models/city.dart';
import 'models/mission.dart';
import 'models/myuser.dart';
import 'models/secureStorage.dart';
import 'pages/home/homePage.dart';
import 'pages/settingsPage.dart';
import 'package:turtle_ninja/services/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:timezone/data/latest.dart' as tz;
GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<DataBaseService>(() => DataBaseService());
  locator.registerLazySingleton<SingletonUser>(() => SingletonUser());
}
///Receice message when app in background
Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);

}

void main() async {
  setupSingletons();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // final SecureStorage secureStorage = SecureStorage();
  // secureStorage.deleteSecureData('email');
  //await secureStorage.deleteSecureData('credentials');
  //Hive
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  Hive.registerAdapter(CharacterDataAdapter());
  await Hive.openBox<CharacterData>('characterData');

  Hive.registerAdapter(CityAdapter());
  await Hive.openBox<City>('cities');


  Hive.registerAdapter(MissionAdapter());
  await Hive.openBox<Mission>('M');

  Hive.registerAdapter(LastUpdateAdapter());
  await Hive.openBox<LastUpdate>('lastUpdate');

  Hive.registerAdapter(UserLikesAdapter());
  await Hive.openBox<UserLikes>('userLikes');

  //check connectivity
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();


  //Firebase
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(StreamProvider<MyUser?>.value(
    initialData: null,
    value: GetIt.I.get<AuthService>().user,
    child: ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/':(context) => Wrapper(),
            '/home':(context) => NinjaCard(),
           // '/settings':(context) => Settings(),
            '/details':(context) => Details(docID: '',),
           // '/details/map':(context) => MapScreen(),

          },
        );
      },
      designSize: const Size(1080, 2400),
      minTextAdapt: true,
    ),
  ));
}
