import 'package:expensetrackerapp/widgets/chart/chart.dart';
import 'package:expensetrackerapp/widgets/expenses_list/expenses_list.dart';
import 'package:expensetrackerapp/widgets/new_expence.dart';
import 'package:flutter/material.dart';
import 'package:expensetrackerapp/models/expense_model.dart';

//firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "flutter course",
        amount: 19.992115,
        category: Category.work,
        date: DateTime.now()),
    Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.leisure,
        date: DateTime.now()),
    Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.travel,
        date: DateTime.now()), Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.leisure,
        date: DateTime.now()), Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.work,
        date: DateTime.now()), Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.leisure,
        date: DateTime.now()), Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.food,
        date: DateTime.now()), Expense(
        title: "cinema",
        amount: 15.421449,
        category: Category.travel,
        date: DateTime.now()),
    Expense(
        title: "Pizza",
        amount: 15.421449,
        category: Category.food,
        date: DateTime.now()),
  ];

  void _openAddExpenceOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpence(_addExpense);
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Expense has deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      appBar: AppBar(title: const Text("Flutter Expenses Tracker"), actions: [
        IconButton(
          onPressed: _openAddExpenceOverlay,
          icon: const Icon(Icons.add),
        )
      ]),
      body: screenHeight > screenWidth
          ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent)
        ],
      )
          : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
