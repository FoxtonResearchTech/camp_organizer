import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'onsite_add_team_event.dart';
import 'onsite_add_team_state.dart';


class AddTeamBloc extends Bloc<AddTeamEvent, AddTeamState> {
  final FirebaseFirestore firestore;

  AddTeamBloc({required this.firestore}) : super(AddTeamInitial()) {
    on<AddTeamWithDocumentId>(_onAddTeamWithDocumentId);
  }

  Future<void> _onAddTeamWithDocumentId(
      AddTeamWithDocumentId event, Emitter<AddTeamState> emit) async {
    emit(AddTeamLoading());
    try {
      // Reference to the camp document
      final campRef = FirebaseFirestore.instance
          .collection('employees')
          .doc('osVjMnYxkRdBZAK8gp7hSGsVr1o1')
          .collection('camps')
          .doc(event.documentId);


      // Add the team information to the "teams" array field
      await campRef.update({
        'teams': FieldValue.arrayUnion([event.teamInfo]),
      });

      emit(AddTeamSuccess());
    } catch (e) {
      emit(AddTeamError(message: e.toString()));
    }
  }
}
