import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminapproval_event.dart';
import 'adminapproval_state.dart';

class AdminApprovalBloc extends Bloc<AdminApprovalEvent, AdminApprovalState> {
  AdminApprovalBloc() : super(AdminApprovalInitial()) {
    // Fetch camps data from Firestore
    on<FetchDataEvents>((event, emit) async {
      emit(AdminApprovalLoading());
      try {
        final employeesSnapshot =
            await FirebaseFirestore.instance.collection('employees').get();

        List<Map<String, dynamic>> allCamps = [];
        List<String> campDocIds = [];
        List<String> employeeDocIds = []; // Store all employee IDs

        // Loop through employees
        for (var employeeDoc in employeesSnapshot.docs) {
          final employeeId = employeeDoc.id; // This is the employeeDocId
          employeeDocIds.add(employeeId); // Collect employeeDocId

          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          final camps = campsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['documentId'] = doc.id; // Add the camp document ID to the data
            data['employeeDocId'] = employeeId; // Add employeeDocId to the data
            campDocIds.add(doc.id); // Store the camp document IDs
            return data;
          }).toList();

          allCamps.addAll(camps);
        }

        // Emit the AdminApprovalLoaded state with the camps, employeeDocIds, and campDocIds
        emit(AdminApprovalLoaded(allCamps, employeeDocIds, campDocIds));
      } catch (e) {
        print("Error in fetching camps: $e");
        emit(AdminApprovalError(e.toString()));
      }
    });

    // Update status to 'Approved' or 'Rejected'
    on<UpdateStatusEvent>((event, emit) async {
      try {
        String employeeId = event.employeeId;
        String campDocId = event.campDocId;
        String newStatus = event.newStatus; // Dynamic status

        // Fetch the specific camp document
        final campDoc = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .doc(campDocId)
            .get();

        if (campDoc.exists) {
          // Update the 'campStatus' field in the specific camp document
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .doc(campDocId)
              .update({'campStatus': newStatus});

          emit(AdminApprovalUpdated());
        } else {
          emit(AdminApprovalError("Camp document not found"));
        }
      } catch (e) {
        emit(AdminApprovalError("Failed to update status: ${e.toString()}"));
      }
    });

    // Add reason for rejection or any status update
    on<AddReasonEvent>((event, emit) async {
      try {
        String reasonText = event.reasonText; // Reason passed from the event
        String employeeId =
            event.employeeId; // Use the employeeId passed in the event
        String campDocId =
            event.campDocId; // Use the campDocId passed in the event

        // Check if the reason is not empty
        if (reasonText.isEmpty) {
          emit(AdminApprovalError("Reason cannot be empty"));
          return;
        }

        // Fetch the specific camp document
        final campDoc = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .doc(campDocId)
            .get();

        if (campDoc.exists) {
          // Update the 'reason' field in the specific camp document
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .doc(campDocId)
              .update({'reason': reasonText});

          emit(AdminApprovalUpdated());
        } else {
          emit(AdminApprovalError("Camp document not found"));
        }
      } catch (e) {
        emit(AdminApprovalError("Failed to add reason: ${e.toString()}"));
      }
    });
    // adminapproval_bloc.dart
    on<DeleteCampEvent>((event, emit) async {
      try {
        String employeeId = event.employeeId;
        String campDocId = event.campDocId;

        // Delete the specific camp document
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .collection('camps')
            .doc(campDocId)
            .delete();

        // Fetch the updated list of camps
        final employeesSnapshot =
            await FirebaseFirestore.instance.collection('employees').get();
        List<Map<String, dynamic>> allCamps = [];
        List<String> campDocIds = [];
        List<String> employeeDocIds = [];

        for (var employeeDoc in employeesSnapshot.docs) {
          final employeeId = employeeDoc.id;
          employeeDocIds.add(employeeId);

          final campsSnapshot = await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .collection('camps')
              .get();

          final camps = campsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['documentId'] = doc.id;
            data['employeeDocId'] = employeeId;
            campDocIds.add(doc.id);
            return data;
          }).toList();

          allCamps.addAll(camps);
        }

        // Emit the updated list of camps
        emit(AdminApprovalLoaded(allCamps, employeeDocIds, campDocIds));
      } catch (e) {
        emit(AdminApprovalError("Failed to delete camp: ${e.toString()}"));
      }
    });
    on<SelectedEmployeeFetchEvent>((event, emit) async {
      emit(AdminApprovalLoading());

      try {
        final employeesSnapshot =
            await FirebaseFirestore.instance.collection('employees').get();

        List<Map<String, dynamic>> allCamps = [];
        List<String> campDocIds = [];
        List<String> employeeDocIds = [];

        // Loop through employees
        for (var employeeDoc in employeesSnapshot.docs) {
          final employeeId = employeeDoc.id;
          final employeeData = employeeDoc.data();
          final firstName = employeeData['firstName'] ?? '';
          final lastName = employeeData['lastName'] ?? '';
          final employeeFullName = '$firstName $lastName';

          // Check if the employee name matches the passed name
          if (employeeFullName == event.employeeName) {
            employeeDocIds.add(employeeId);

            final campsSnapshot = await FirebaseFirestore.instance
                .collection('employees')
                .doc(employeeId)
                .collection('camps')
                .get();

            final camps = campsSnapshot.docs.map((doc) {
              final data = doc.data();
              data['documentId'] =
                  doc.id; // Add the camp document ID to the data
              data['employeeDocId'] =
                  employeeId; // Add employeeDocId to the data
              campDocIds.add(doc.id); // Store the camp document IDs
              return data;
            }).toList();

            allCamps.addAll(camps);
          }
        }

        // Emit the AdminApprovalLoaded state with the camps, employeeDocIds, and campDocIds
        emit(AdminApprovalLoaded(allCamps, employeeDocIds, campDocIds));
      } catch (e) {
        print("Error in fetching camps: $e");
        emit(AdminApprovalError(e.toString()));
      }
    });
  }
}
