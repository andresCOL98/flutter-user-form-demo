import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_users_usecase.dart';
import '../../../domain/usecases/get_user_usecase.dart';
import '../../../../../core/usecases/usecase.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

@injectable
class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsersUseCase getUsersUseCase;
  final GetUserUseCase getUserUseCase;

  UserListBloc({
    required this.getUsersUseCase,
    required this.getUserUseCase,
  }) : super(UserListInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<LoadUserDetailsEvent>(_onLoadUserDetails);
  }

  void _onLoadUsers(LoadUsersEvent event, Emitter<UserListState> emit) async {
    emit(UserListLoading());
    await _fetchUsers(emit);
  }

  void _onRefreshUsers(
      RefreshUsersEvent event, Emitter<UserListState> emit) async {
    await _fetchUsers(emit);
  }

  void _onSearchUsers(
      SearchUsersEvent event, Emitter<UserListState> emit) async {
    if (event.query.isEmpty) {
      add(LoadUsersEvent());
      return;
    }

    emit(UserListLoading());
    // For now, we'll load all users and filter locally
    // In a real app, you might want to implement server-side search
    await _fetchUsers(emit);
  }

  void _onLoadUserDetails(
      LoadUserDetailsEvent event, Emitter<UserListState> emit) async {
    emit(UserListLoading());

    final params = GetUserParams(userId: event.userId);
    final result = await getUserUseCase(params);

    result.fold(
      (failure) => emit(UserListError(message: failure.message)),
      (user) => emit(UserDetailsLoaded(user: user)),
    );
  }

  Future<void> _fetchUsers(Emitter<UserListState> emit) async {
    final result = await getUsersUseCase(NoParams());

    result.fold(
      (failure) => emit(UserListError(message: failure.message)),
      (users) {
        if (users.isEmpty) {
          emit(UserListEmpty());
        } else {
          emit(UserListLoaded(users: users));
        }
      },
    );
  }
}
