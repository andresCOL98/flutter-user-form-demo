import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/theme/app_theme.dart';
import '../../user_form/data/datasources/local/database_initialization_data_source.dart';
import 'bloc/location_bloc.dart';
import 'bloc/user_form_bloc.dart';
import 'bloc/user_list_bloc.dart';
import 'pages/app_initialization_page.dart';
import 'pages/user_list_page.dart';

class UserFormApp extends StatelessWidget {
  final DatabaseInitializationResult? initializationResult;

  const UserFormApp({
    super.key,
    this.initializationResult,
  });

  @override
  Widget build(BuildContext context) {
    // Check if dependencies are configured
    if (!_areDependenciesReady()) {
      return MaterialApp(
        title: 'User Form Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const AppInitializationPage(
          message: 'Configurando dependencias...',
          isLoading: true,
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserFormBloc>(
          create: (context) => GetIt.instance<UserFormBloc>(),
        ),
        BlocProvider<UserListBloc>(
          create: (context) => GetIt.instance<UserListBloc>(),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => GetIt.instance<LocationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'User Form Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: _buildHomePage(),
      ),
    );
  }

  bool _areDependenciesReady() {
    try {
      // Try to check if the dependencies are registered
      return GetIt.instance.isRegistered<UserFormBloc>() &&
          GetIt.instance.isRegistered<UserListBloc>() &&
          GetIt.instance.isRegistered<LocationBloc>();
    } catch (e) {
      return false;
    }
  }

  Widget _buildHomePage() {
    if (initializationResult == null) {
      // Normal flow - dependencies are ready, show UserListPage
      return const UserListPage();
    }

    if (!initializationResult!.isSuccess) {
      return AppInitializationPage(
        message: 'Error de inicialización',
        isLoading: false,
        error: initializationResult!.errorMessage,
        canRetry: true,
      );
    }

    // If we have a successful initialization result, still show UserListPage
    return const UserListPage();
  }
}
