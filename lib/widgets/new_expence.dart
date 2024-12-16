import 'package:expensetrackerapp/models/expense_model.dart';

import 'package:flutter/material.dart';

class NewExpence extends StatefulWidget {
  const NewExpence(this._onAddExpense, {super.key});
  final void Function(Expense) _onAddExpense;

  @override
  State<NewExpence> createState() {
    return _NewExpenceState();
  }
}

class _NewExpenceState extends State<NewExpence> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.work;

  DateTime? _selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = now.year - 1;
    final lastDate = now.year + 1;
    final pickDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(firstDate, now.month, now.day),
        lastDate: DateTime(lastDate, now.month, now.day));

    setState(() {
      _selectedDate = pickDate;
    });
  }

  void _submitExpenseDate() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isInvalidAmount = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        isInvalidAmount ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text(
                  'Please make sure that you entered valid Title, amount, Date and Category'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                )
              ],
            );
          });
      return;
    }

    widget._onAddExpense(Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        category: _selectedCategory,
        date: _selectedDate!));

    Navigator.pop(context);
  }

  // String _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    double screenWidth =MediaQuery.of(context).size.width;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16, 48, 16,keyboardSpace+ 16),
          child: Column(children: [
            TextField(
              controller: _titleController,
              // onChanged: _saveTitleInput,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text("Title"),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                        label: Text('Amount'), prefixText: '\$ '),
                    keyboardType: TextInputType.number,
                  ),
                ),
                 SizedBox(
                  width:screenWidth*0.05 ,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedDate == null
                          ? 'No selected Date'
                          : formatter.format(_selectedDate!),style: const TextStyle(fontSize: 10),),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _selectedCategory = value;
                    });

                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: _submitExpenseDate,
                    child: const Text('Save Expense')),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
