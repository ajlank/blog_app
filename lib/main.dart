import 'package:blog_app/controller/home_user_profile_notifier.dart';
import 'package:blog_app/controller/post_comment_notifier.dart';
import 'package:blog_app/controller/profile_settings_notifier.dart';
import 'package:blog_app/firebase_options.dart';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:blog_app/views/auth_views/login_view.dart';
import 'package:blog_app/views/auth_views/sign_up.dart';
import 'package:blog_app/views/home_view.dart';
import 'package:blog_app/views/profile_view.dart';
import 'package:blog_app/views/settings/profile_settings.dart';
import 'package:blog_app/views/user_posts/create_post.dart';
import 'package:blog_app/views/user_posts/home_user_view.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(
    cloudName: 'dyn1z1hjj',
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileSettingsNotifier()),
        ChangeNotifierProvider(create: (context) => PostCommentNotifier()),
        ChangeNotifierProvider(create: (context) => HomeUserProfileNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          if (snapshot.data != null) {
            return HomeView();
          }
          return LoginView();
        },
      ),
      routes: {
        loginRoute: (context) => LoginView(),
        signUpRoute: (context) => SignUp(),
        profileRoute: (context) => ProfileView(),
        profileSettingsRoute: (context) => ProfileSettings(),
        createPostRoute: (context) => CreatePost(),
        homeRoute: (context) => HomeView(),
        homeUserRoute: (context) => HomeUserView(),
      },
    );
  }
}
