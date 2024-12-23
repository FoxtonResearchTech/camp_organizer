import 'package:camp_organizer/bloc/AddEvent/add_finance_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/add_logistics_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/incharge_report_bloc.dart';
import 'package:camp_organizer/bloc/AddEvent/onsite_add_team_bloc.dart';
import 'package:camp_organizer/bloc/approval/adminapproval_bloc.dart';
import 'package:camp_organizer/bloc/approval/onsite_approval_bloc.dart';
import 'package:camp_organizer/bloc/approval/onsite_approval_state.dart';
import 'package:camp_organizer/camp_update/camp_update_bloc.dart';
import 'package:camp_organizer/presentation/authentication/login_screen.dart';

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
import 'connectivity_checker.dart';
import 'firebase_options.dart';
import 'presentation/module/Finance_Reports/finance_timeline.dart';
import 'presentation/module/camp_incharge/camp_incharge_timeline.dart';
import 'presentation/module/logistics/logistics_timeline.dart';
import 'presentation/module/post_camp_followup/post_camp_timeline.dart';
import 'repository/auth_repository.dart';
import 'services/notification/email_notification.dart';
import 'widgets/bottom_navigation_bar/camp_incharge_nav_bar.dart';
import 'widgets/bottom_navigation_bar/post_camp_nav_bar.dart';

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
        BlocProvider(
          create: (context) =>
              AddLogisticsBloc(firestore: FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) =>
              InchargeReportBloc(firestore: FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => OnsiteApprovalBloc(),
        ),
        BlocProvider(
          create: (context) =>
              AddFinanceBloc(firestore: FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: ConnectivityChecker(
          child: CampOrganizerLoginPage(), // Your app's home page
        ), // Starting screen is the splash screen

        //  home: PdfPage(),
      ),
    );
  }
}
