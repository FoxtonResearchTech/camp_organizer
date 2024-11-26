import 'package:camp_organizer/bloc/AddEvent/onsite_add_team_bloc.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_bloc.dart';
import 'package:camp_organizer/camp_update/camp_update_bloc.dart';
import 'package:camp_organizer/presentation/authentication/login_screen.dart';
import 'package:camp_organizer/presentation/module/Finance_Reports/finance_dashboard.dart';
import 'package:camp_organizer/presentation/module/Onsite_Management_team/onsite_camp_timeline.dart';
import 'package:camp_organizer/presentation/module/camp_incharge/camp_incharge_dashboard.dart';
import 'package:camp_organizer/presentation/module/logistics/logistics_dashboard.dart';
import 'package:camp_organizer/presentation/module/post_camp_followup/post_camp_dashboard.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/onsite_management_nav_bar.dart';
import 'package:camp_organizer/widgets/bottom_navigation_bar/super_admin_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_add_employee.dart';
import 'bloc/AddEvent/event_bloc.dart';
import 'bloc/AddEvent/patient_follow_ups_bloc.dart';
import 'bloc/Employee_registration/employee_registration_bloc.dart';
import 'bloc/Status/status_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'repository/auth_repository.dart';
import 'services/notification/email_notification.dart';

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
          create: (context) => StatusBloc(),
        ),
        BlocProvider(
          create: (context) => AdminApprovalBloc(),
        ),
        BlocProvider(
          create: (context) => CampUpdateBloc(),
        ),
        BlocProvider(
          create: (context) =>
              AddTeamBloc(firestore: FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) =>
              PatientFollowUpsBloc(firestore: FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: PostCampDashboard(), // Starting screen is the splash screen

        //  home: PdfPage(),
      ),
    );
  }
}
