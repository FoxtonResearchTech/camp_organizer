import 'package:camp_organizer/presentation/authentication/login_screen.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/fluid_bottom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_add_employee.dart';
import 'bloc/AddEvent/event_bloc.dart';
import 'bloc/Employee_registration/employee_registration_bloc.dart';
import 'bloc/Status/status_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AuthRepository authRepository =
      AuthRepository(); // Initialize your AuthRepository

  runApp(
      MyApp(authRepository: authRepository)); // Pass the repository to the app
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider(
          create: (context) => EventFormBloc(),
        ),
        BlocProvider(
          create: (context) => RegistrationBloc(),
        ),
        BlocProvider<StatusBloc>(
          // Add StatusBloc here
          create: (context) => StatusBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: CampOrganizerLoginPage(), // Starting screen is the splash screen

        //  home: PdfPage(),
      ),
    );
  }
}
