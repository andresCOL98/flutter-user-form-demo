import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/create_user_usecase.dart';
import '../../../domain/usecases/update_user_usecase.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';

@injectable
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
