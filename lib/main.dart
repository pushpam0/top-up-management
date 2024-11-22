import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_up_management/presentation/blocs/top_up_event.dart';
import 'presentation/blocs/top_up_bloc.dart';
import 'data/repositories/mock_repository.dart';
import 'presentation/pages/home_page.dart';

void main() {
  // Create a repository with the desired initial state
  final repository = MockRepository()..isVerified = false;

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final MockRepository repository;

  MyApp({required this.repository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => TopUpBloc(repository)..add(FetchBeneficiaries()),
        child: HomePage(repository: repository),
      ),
    );
  }
}
