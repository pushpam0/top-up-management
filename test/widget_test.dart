import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_management/data/repositories/mock_repository.dart';
import 'package:top_up_management/presentation/blocs/top_up_bloc.dart';
import 'package:top_up_management/presentation/blocs/top_up_state.dart';
import 'package:top_up_management/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage displays balance and beneficiaries', (WidgetTester tester) async {
    // Mock repository setup
    final repository = MockRepository(); // Create mock repository
    repository.beneficiaries[0].monthlyTopUp = 200.0; // Mock some data
    repository.beneficiaries[1].monthlyTopUp = 0.0;   // Mock another value

    // Inject the BlocProvider and initial state
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => TopUpBloc(repository)..emit(TopUpLoaded(repository.beneficiaries, repository.balance)),
          child: HomePage(repository: repository),
        ),
      ),
    );

    // Verify the UI
    expect(find.textContaining("Balance: AED"), findsOneWidget); // Check for balance text
    expect(find.textContaining("Verified"), findsNothing);       // Default unverified
    expect(find.text("Unverified"), findsOneWidget);             // Verification status
    expect(find.textContaining("John"), findsOneWidget);         // Beneficiary name
    expect(find.text("AED 200.0"), findsOneWidget);              // First beneficiary top-up
    expect(find.text("AED 0.0"), findsOneWidget);                // Second beneficiary top-up
  });
}
