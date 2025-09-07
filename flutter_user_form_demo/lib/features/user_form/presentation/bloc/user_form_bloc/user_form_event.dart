part of 'user_form_bloc.dart';

abstract class UserFormEvent extends Equatable {
  const UserFormEvent();

  @override
  List<Object?> get props => [];
}

class CreateUserEvent extends UserFormEvent {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? email;
  final String? phoneNumber;

  const CreateUserEvent({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.email,
    this.phoneNumber,
  });

  @override
  List<Object?> get props =>
      [firstName, lastName, dateOfBirth, email, phoneNumber];
}

class UpdateUserEvent extends UserFormEvent {
  final User user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class ResetFormEvent extends UserFormEvent {}
