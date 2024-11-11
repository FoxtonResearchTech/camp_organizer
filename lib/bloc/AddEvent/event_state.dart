// event_state.dart
abstract class EventFormState {}

class EventFormInitial extends EventFormState {}

class FormSubmitting extends EventFormState {}

class FormSubmitSuccess extends EventFormState {}

class FormSubmitFailure extends EventFormState {
  final String error;

  FormSubmitFailure(this.error);
}
class FormSubmitDuplicate extends EventFormState {}