import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_bloc.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_state.dart';

class BalanceDisplay extends StatelessWidget {
  final String accountType; // 'source' or 'destination'
  final TextStyle? balanceTextStyle; // Style for balance text
  final TextStyle? errorTextStyle; // Style for error text

  const BalanceDisplay({
    super.key,
    required this.accountType,
    this.balanceTextStyle,
    this.errorTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Default styles
    final defaultBalanceStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white, // Matches Dashboard's CarouselSlider card
    );

    final defaultErrorStyle = TextStyle(
      fontSize: 16,
      color: Colors.red,
      fontWeight: FontWeight.normal,
    );

    return BlocBuilder<InternalTransferBloc, InternalTransferState>(
      builder: (context, state) {
        if (state is InternalTransferLoading) {
          return Center(child: SpinKitThreeBounce(
            color: ColorsField.buttonRed,
            size: 25,
          ));
        } else if (state is InternalTransferError) {
          return Text(
            state.message,
            style: errorTextStyle ?? defaultErrorStyle,
            textAlign: TextAlign.center,
          );
        } else if (state is InternalTransferLoaded) {
          final account = accountType == 'source'
              ? state.sourceAccount
              : state.destinationAccount;
          final balance = (account?['balance'] is int
                  ? (account!['balance'] as int).toDouble()
                  : account?['balance'] as double?) ??
              0.0;
          return Text(
            '\₹${balance.toStringAsFixed(2)}',
            style: balanceTextStyle ?? defaultBalanceStyle,
          );
        }
        return Text(
          '\₹0.00',
          style: balanceTextStyle ?? defaultBalanceStyle,
        );
      },
    );
  }
}