abstract class CampUpdateEvent {}

class FetchDataEvent extends CampUpdateEvent {}

class UpdateCampEvent extends CampUpdateEvent {
  final String employeeId; // The employee document ID
  final String campId; // The camp document ID to update
  final Map<String, dynamic> updatedData; // The updated data for the camp

  UpdateCampEvent({
    required this.employeeId,
    required this.campId,
    required this.updatedData,
  });
}
