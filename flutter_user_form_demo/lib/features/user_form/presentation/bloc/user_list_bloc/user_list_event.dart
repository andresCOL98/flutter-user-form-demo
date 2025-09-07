part of 'user_list_bloc.dart';

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
