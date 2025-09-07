import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_list_bloc/user_list_bloc.dart';
import '../../domain/entities/user.dart';
import '../widgets/user_list_sections.dart';
import '../widgets/user_list_logic.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    UserListLogic.initializeUsers(context);
  }

  void _handleAddUser() {
    UserListLogic.navigateToUserForm(context, _refreshUsers);
  }

  void _refreshUsers() {
    UserListLogic.refreshUsers(context);
  }

  Future<void> _onRefresh() async {
    await UserListLogic.onRefresh(context);
  }

  void _handleUserTap(User user) {
    UserListLogic.navigateToUserDetail(context, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: UserListAppBar(onAddUser: _handleAddUser),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          return UserListLogic.buildStateWidget(
            state: state,
            onRetry: _refreshUsers,
            onAddUser: _handleAddUser,
            onUserTap: _handleUserTap,
            onRefresh: _onRefresh,
          );
        },
      ),
    );
  }
}
