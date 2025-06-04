import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/features/Home/Bloc/Scheduled_Bloc/ScheduledTransactionBloc.dart';
import 'package:wealthlet/features/Home/Bloc/Scheduled_Bloc/ScheduledTransactionEvent.dart';
import 'package:wealthlet/features/Home/Bloc/Scheduled_Bloc/ScheduledTransactionState.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/ScheduleTransactionScreenMain.dart';
import 'package:wealthlet/main.dart';

class ScheduledTransactionsScreen extends StatefulWidget {
  @override
  _ScheduledTransactionsScreenState createState() =>
      _ScheduledTransactionsScreenState();
}

class _ScheduledTransactionsScreenState extends State<ScheduledTransactionsScreen>
    with RouteAware {
  late ScheduledTransactionBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    _bloc = ScheduledTransactionBloc()..add(LoadScheduledTransactions());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _bloc.close();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when user navigates back to this screen
    _bloc.add(LoadScheduledTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
           flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 22, 22, 22), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
          title: Text('Scheduled Transactions'),
          backgroundColor: ColorsField.buttonRed,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<ScheduledTransactionBloc, ScheduledTransactionState>(
          listener: (context, state) {
            if (state is ScheduledTransactionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ScheduledTransactionLoading) {
              return Center(
                  child: CircularProgressIndicator(color: ColorsField.buttonRed));
            }
            if (state is ScheduledTransactionError) {
              return Center(child: Text(state.message));
            }
            if (state is ScheduledTransactionLoaded) {
              if (state.transactions.isEmpty) {
                return Center(child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                                  width: 320,
                                  height: 320,
                                  child: Lottie.asset(
                    'assets/lottie/Empty.json',
                    fit: BoxFit.cover,
                    repeat: true, // Loop the animation
                                  ),
                                ),
                    Text('No Scheduled Transactions Found', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ColorsField.buttonRed),)
                  ],
                ),);
              }
              return RefreshIndicator(
                color: ColorsField.buttonRed,
                onRefresh: () async {
                  _bloc.add(LoadScheduledTransactions());
                    await Future.delayed(Duration(seconds: 1));
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          '${transaction.type} to ${transaction.recipient}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Amount: ₹${transaction.amount} | Date: ${transaction.date.toString().split(' ')[0]} | Status: ${transaction.status}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: ColorsField.buttonRed),
                          onPressed: () {
                            context.read<ScheduledTransactionBloc>().add(
                                  DeleteScheduledTransaction(transaction.id),
                                );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Center(child:  Container(
              width: 250,
              height: 250,
              child: Lottie.asset(
                'assets/lottie/Empty.json',
                fit: BoxFit.contain,
                repeat: true, // Loop the animation
              ),
            ),);
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsField.buttonRed,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => BlocProvider.value(
                  value: _bloc,
                  child: ScheduleTransactionScreen(),
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
