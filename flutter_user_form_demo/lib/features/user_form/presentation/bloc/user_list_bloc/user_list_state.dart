part of 'user_list_bloc.dart';

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
