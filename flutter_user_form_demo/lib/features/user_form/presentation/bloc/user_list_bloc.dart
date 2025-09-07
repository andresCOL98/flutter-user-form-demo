import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../../../core/usecases/usecase.dart';

// Events
abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UserListEvent {}

class RefreshUsersEvent extends UserListEvent {}

class SearchUsersEvent extends UserListEvent {
  final String query;

  const SearchUsersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadUserDetailsEvent extends UserListEvent {
  final String userId;

  const LoadUserDetailsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// States
abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<User> users;

  const UserListLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class UserListEmpty extends UserListState {}

class UserListError extends UserListState {
  final String message;

  const UserListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserDetailsLoaded extends UserListState {
  final User user;

  const UserDetailsLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

// BLoC
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
