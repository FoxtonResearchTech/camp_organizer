import 'package:camp_organizer/bloc/AddEvent/event_bloc.dart';
import 'package:camp_organizer/bloc/auth/auth_bloc.dart';
import 'package:camp_organizer/firebase_options.dart';
import 'package:camp_organizer/presentation/Event/add_event.dart';
import 'package:camp_organizer/presentation/authentication/login_screen.dart';
import 'package:camp_organizer/presentation/module/admin/add_employee.dart';
import 'package:camp_organizer/presentation/module/admin/approvals.dart';
import 'package:camp_organizer/presentation/module/admin/dashboard.dart';
import 'package:camp_organizer/presentation/module/admin/edit_employee_account.dart';
import 'package:camp_organizer/presentation/module/admin/manage_employee_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_add_employee.dart';
import 'repository/auth_repository.dart';
import 'widgets/bottom_navigation_bar/fluid_bottom_navigation_bar.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: ManageEmployeeAccount(), // Starting screen is the splash screen

        //  home: PdfPage(),
      ),
    );
  }
}
