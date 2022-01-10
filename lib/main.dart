import 'package:facemash_clone/view/home_screen.dart';
import 'package:facemash_clone/viewmodels/home_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference profileRef =
    FirebaseDatabase.instance.ref().child('profile');

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);

    profileRef.keepSynced(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
        child: MaterialApp(
          title: 'Codemash',
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Tahoma',
          ),
          initialRoute: HomeActivity.id,
          routes: {
            HomeActivity.id: (context) => const HomeActivity(),
          },
        ));
  }
}
