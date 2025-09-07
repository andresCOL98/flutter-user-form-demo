part of 'user_form_bloc.dart';

abstract class UserFormState extends Equatable {
  const UserFormState();

  @override
  List<Object?> get props => [];
}

class UserFormInitial extends UserFormState {}

class UserFormLoading extends UserFormState {}

class UserFormSuccess extends UserFormState {
  final User user;

  const UserFormSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserFormError extends UserFormState {
  final String message;

  const UserFormError({required this.message});

  @override
  List<Object?> get props => [message];
}
