import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

// Events
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

// States
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

// BLoC
class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  UserFormBloc({
    required this.createUserUseCase,
    required this.updateUserUseCase,
  }) : super(UserFormInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<ResetFormEvent>(_onResetForm);
  }

  void _onCreateUser(CreateUserEvent event, Emitter<UserFormState> emit) async {
    emit(UserFormLoading());

    // Create user entity
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: event.firstName,
      lastName: event.lastName,
      dateOfBirth: event.dateOfBirth,
      email: event.email,
      phoneNumber: event.phoneNumber,
      isActive: true,
      createdAt: DateTime.now(),
    );

    final params = CreateUserParams(user: user);
    final result = await createUserUseCase(params);

    result.fold(
      (failure) => emit(UserFormError(message: failure.message)),
      (createdUser) => emit(UserFormSuccess(user: createdUser)),
    );
  }

  void _onUpdateUser(UpdateUserEvent event, Emitter<UserFormState> emit) async {
    emit(UserFormLoading());

    final params = UpdateUserParams(user: event.user);
    final result = await updateUserUseCase(params);

    result.fold(
      (failure) => emit(UserFormError(message: failure.message)),
      (updatedUser) => emit(UserFormSuccess(user: updatedUser)),
    );
  }

  void _onResetForm(ResetFormEvent event, Emitter<UserFormState> emit) {
    emit(UserFormInitial());
  }
}
